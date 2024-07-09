#!/usr/bin/env node

const fs = require('fs');
const { execSync } = require('child_process');

const extractMetric = (file, metric) => {
  const data = fs.readFileSync(file, 'utf8');
  const line = data.split('\n').find((line) => line.includes(metric));
  if (!line) return null;
  return parseFloat(line.split(' ')[1].replace('ms', ''));
};

const average = (arr) => arr.reduce((a, b) => a + b, 0) / arr.length;

const servers = [
  'apollo',
  'caliban',
  'netflixdgs',
  'gqlgen',
  'tailcall',
  'async_graphql',
  'hasura',
  'graphql_jit',
];

// Associative array for formatted server names
const formattedServerNames = {
  tailcall: 'Tailcall',
  gqlgen: 'Gqlgen',
  apollo: 'Apollo GraphQL',
  netflixdgs: 'Netflix DGZ',
  caliban: 'Caliban',
  async_graphql: 'async-graphql',
  hasura: 'Hasura',
  graphql_jit: 'GraphQL JIT',
};

const resultFiles = process.argv.slice(2).filter((arg) => fs.existsSync(arg));

// Extract metrics and calculate averages
const calculateAverages = () => {
  const avgReqSecs = {};
  const avgLatencies = {};

  servers.forEach((server, idx) => {
    const startIdx = idx * 3;
    const reqSecVals = [];
    const latencyVals = [];

    for (let j = 0; j < 3; j++) {
      const fileIdx = startIdx + j;
      reqSecVals.push(extractMetric(resultFiles[fileIdx], 'Requests/sec'));
      latencyVals.push(extractMetric(resultFiles[fileIdx], 'Latency'));
    }

    avgReqSecs[server] = average(reqSecVals);
    avgLatencies[server] = average(latencyVals);
  });

  return { avgReqSecs, avgLatencies };
};

const writeDataFile = (filename, data) => {
  fs.writeFileSync(filename, 'Server Value\n');
  Object.entries(data).forEach(([server, value]) => {
    fs.appendFileSync(filename, `${server} ${value}\n`);
  });
};

// Plotting using gnuplot
const generateGnuplotScript = (
  reqSecData,
  latencyData,
  reqSecHistogramFile,
  latencyHistogramFile,
) => `
set term pngcairo size 1280,720 enhanced font "Courier,12"
set style data histograms
set style histogram cluster gap 1
set style fill solid border -1
set xtics rotate by -45
set boxwidth 0.9
set key outside right top
set output "${reqSecHistogramFile}"
set title "Requests/Sec"
stats "${reqSecData}" using 2 nooutput
set yrange [0:STATS_max*1.2]
plot "${reqSecData}" using 2:xtic(1) title "Req/Sec"

set output "${latencyHistogramFile}"
set title "Latency (in ms)"
stats "${latencyData}" using 2 nooutput
set yrange [0:STATS_max*1.2]
plot "${latencyData}" using 2:xtic(1) title "Latency"
`;

// Generate the results table for README
const generateResultsTable = (avgReqSecs, avgLatencies, whichBench) => {
  const sortedServers = Object.keys(avgReqSecs).sort(
    (a, b) => avgReqSecs[b] - avgReqSecs[a],
  );
  const lastServer = sortedServers[sortedServers.length - 1];
  const lastServerReqSecs = avgReqSecs[lastServer];

  console.log(`Sorted servers: ${sortedServers.join(', ')}`);

  // Start building the resultsTable
  let resultsTable;
  if (whichBench === 1) {
    resultsTable =
      '<!-- PERFORMANCE_RESULTS_START -->\n\n| Query | Server | Requests/sec | Latency (ms) | Relative |\n|-------:|--------:|--------------:|--------------:|---------:|\n| ' +
      whichBench +
      ' | `{ posts { id userId title user { id name email }}}` |';
  } else if (whichBench === 2) {
    resultsTable = '| ' + whichBench + ' | `{ posts { title }}` |';
  } else if (whichBench === 3) {
    resultsTable = '| ' + whichBench + ' | `{ greet }` |';
  }

  // Build the resultsTable with sorted servers and formatted numbers
  sortedServers.forEach((server) => {
    const formattedReqSecs = avgReqSecs[server].toLocaleString(undefined, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
    const formattedLatencies = avgLatencies[server].toLocaleString(undefined, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
    const relativePerformance = (
      avgReqSecs[server] / lastServerReqSecs
    ).toFixed(2);

    resultsTable += `\n| [${formattedServerNames[server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` | \`${relativePerformance}x\` |`;
  });

  if (whichBench === 3) {
    resultsTable += '\n\n<!-- PERFORMANCE_RESULTS_END -->';
  }

  return resultsTable;
};

// Print the results table in a new file
const updateReadme = (resultsTable) => {
  const readmePath = 'README.md';
  let content = fs.readFileSync(readmePath, 'utf8');
  const regex =
    /<!-- PERFORMANCE_RESULTS_START -->[\s\S]*<!-- PERFORMANCE_RESULTS_END -->/;
  content = content.includes('PERFORMANCE_RESULTS_START')
    ? content.replace(regex, resultsTable)
    : content + '\n\n' + resultsTable;
  fs.writeFileSync(readmePath, content);
};

const main = () => {
  const { avgReqSecs, avgLatencies } = calculateAverages();

  // Generating data files for gnuplot
  const reqSecData = '/tmp/reqSec.dat';
  const latencyData = '/tmp/latency.dat';

  writeDataFile(reqSecData, avgReqSecs);
  writeDataFile(latencyData, avgLatencies);

  let whichBench = 1;
  if (resultFiles[0].startsWith('bench2')) {
    whichBench = 2;
  } else if (resultFiles[0].startsWith('bench3')) {
    whichBench = 3;
  }

  // Move the generated images to the assets folder
  const reqSecHistogramFile = `req_sec_histogram${whichBench}.png`;
  const latencyHistogramFile = `latency_histogram${whichBench}.png`;

  const gnuplotScript = generateGnuplotScript(
    reqSecData,
    latencyData,
    reqSecHistogramFile,
    latencyHistogramFile,
  );
  fs.writeFileSync('/tmp/gnuplot_script', gnuplotScript);
  execSync('gnuplot /tmp/gnuplot_script');

  // Move PNGs to assets
  if (!fs.existsSync('assets')) fs.mkdirSync('assets');
  fs.renameSync(reqSecHistogramFile, `assets/${reqSecHistogramFile}`);
  fs.renameSync(latencyHistogramFile, `assets/${latencyHistogramFile}`);

  const resultsTable = generateResultsTable(
    avgReqSecs,
    avgLatencies,
    whichBench,
  );
  const resultsFile = 'results.md';
  fs.writeFileSync(resultsFile, resultsTable);

  if (whichBench === 3) {
    const finalResults = resultsTable.replace(/<!--.*?-->\n?/g, '');
    console.log(finalResults);
    updateReadme(resultsTable);
  }

  // Delete the result TXT files
  resultFiles.forEach((file) => fs.unlinkSync(file));
};

main();
