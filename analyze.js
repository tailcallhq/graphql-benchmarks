#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

function extractMetric(file, metric) {
  try {
    const command = `grep "${metric}" "${file}" | awk '{print $2}' | sed 's/ms//'`;
    const result = execSync(command, { encoding: 'utf-8' }).trim();
    return result;
  } catch (error) {
    console.error(`Error extracting metric from ${file}: ${error.message}`);
    return null;
  }
}

function average(values) {
  const sum = values.reduce((a, b) => parseFloat(a) + parseFloat(b), 0);
  return sum / values.length;
}

const formattedServerNames = {
  tailcall: "Tailcall",
  gqlgen: "Gqlgen",
  apollo: "Apollo GraphQL",
  netflixdgs: "Netflix DGS",
  caliban: "Caliban",
  async_graphql: "async-graphql",
  hasura: "Hasura",
  graphql_jit: "GraphQL JIT",
};

const servers = ["apollo", "caliban", "netflixdgs", "gqlgen", "tailcall", "async_graphql", "hasura", "graphql_jit"];
const resultFiles = process.argv.slice(2);
const avgReqSecs = {};
const avgLatencies = {};

servers.forEach((server, idx) => {
  const startIdx = idx * 3;
  const reqSecVals = [];
  const latencyVals = [];
  for (let j = 0; j < 3; j++) {
    const fileIdx = startIdx + j;
    const reqSec = extractMetric(resultFiles[fileIdx], "Requests/sec");
    const latency = extractMetric(resultFiles[fileIdx], "Latency");
    if (reqSec !== null) reqSecVals.push(reqSec);
    if (latency !== null) latencyVals.push(latency);
  }
  avgReqSecs[server] = average(reqSecVals);
  avgLatencies[server] = average(latencyVals);
});

const reqSecData = "/tmp/reqSec.dat";
const latencyData = "/tmp/latency.dat";

fs.writeFileSync(reqSecData, "Server Value\n" + servers.map(server => `${server} ${avgReqSecs[server]}`).join('\n'));
fs.writeFileSync(latencyData, "Server Value\n" + servers.map(server => `${server} ${avgLatencies[server]}`).join('\n'));

let whichBench = 1;
if (resultFiles[0].startsWith("bench2")) {
  whichBench = 2;
} else if (resultFiles[0].startsWith("bench3")) {
  whichBench = 3;
}

const reqSecHistogramFile = `req_sec_histogram${whichBench}.png`;
const latencyHistogramFile = `latency_histogram${whichBench}.png`;

function getMaxValue(data) {
  return Math.max(...data.split('\n').slice(1).map(line => parseFloat(line.split(' ')[1])));
}

const reqSecMax = getMaxValue(fs.readFileSync(reqSecData, 'utf-8')) * 1.2;
const latencyMax = getMaxValue(fs.readFileSync(latencyData, 'utf-8')) * 1.2;

const gnuplotScript = `
set term pngcairo size 1280,720 enhanced font 'Courier,12'
set output '${reqSecHistogramFile}'
set style data histograms
set style histogram cluster gap 1
set style fill solid border -1
set xtics rotate by -45
set boxwidth 0.9
set title 'Requests/Sec'
set yrange [0:${reqSecMax}]
set key outside right top
plot '${reqSecData}' using 2:xtic(1) title 'Req/Sec'

set output '${latencyHistogramFile}'
set title 'Latency (in ms)'
set yrange [0:${latencyMax}]
plot '${latencyData}' using 2:xtic(1) title 'Latency'
`;

const gnuplotScriptFile = '/tmp/gnuplot_script.gp';
fs.writeFileSync(gnuplotScriptFile, gnuplotScript);

try {
  execSync(`gnuplot ${gnuplotScriptFile}`, { stdio: 'inherit' });
  console.log('Gnuplot executed successfully');
} catch (error) {
  console.error('Error executing gnuplot:', error.message);
  process.exit(1);
}

const assetsDir = path.join(__dirname, "assets");
if (!fs.existsSync(assetsDir)) {
  fs.mkdirSync(assetsDir);
}

function moveFile(source, destination) {
  try {
    if (fs.existsSync(source)) {
      fs.renameSync(source, destination);
      console.log(`Moved ${source} to ${destination}`);
    } else {
      console.log(`Source file ${source} does not exist`);
    }
  } catch (error) {
    console.error(`Error moving file ${source}: ${error.message}`);
  }
}

moveFile(reqSecHistogramFile, path.join(assetsDir, reqSecHistogramFile));
moveFile(latencyHistogramFile, path.join(assetsDir, latencyHistogramFile));

const serverRPS = {};
servers.forEach((server) => {
  serverRPS[server] = avgReqSecs[server];
});

const sortedServers = Object.keys(serverRPS).sort(
  (a, b) => serverRPS[b] - serverRPS[a]
);
const lastServer = sortedServers[sortedServers.length - 1];
const lastServerReqSecs = avgReqSecs[lastServer];

const resultsFile = "results.md";

if (!fs.existsSync(resultsFile) || fs.readFileSync(resultsFile, 'utf8').trim() === '') {
  fs.writeFileSync(resultsFile, `<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|`);
}

let resultsTable = "";

if (whichBench === 1) {
  resultsTable += `\n| ${whichBench} | \`{ posts { id userId title user { id name email }}}\` |`;
} else if (whichBench === 2) {
  resultsTable += `\n| ${whichBench} | \`{ posts { title }}\` |`;
} else if (whichBench === 3) {
  resultsTable += `\n| ${whichBench} | \`{ greet }\` |`;
}

sortedServers.forEach((server) => {
  const formattedReqSecs = avgReqSecs[server].toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
  const formattedLatencies = avgLatencies[server].toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
  const relativePerformance = (avgReqSecs[server] / lastServerReqSecs).toFixed(2);

  resultsTable += `\n|| [${formattedServerNames[server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` | \`${relativePerformance}x\` |`;
});

fs.appendFileSync(resultsFile, resultsTable);

if (whichBench === 3) {
  fs.appendFileSync(resultsFile, "\n\n<!-- PERFORMANCE_RESULTS_END -->");
  
  const finalResults = fs
    .readFileSync(resultsFile, "utf-8")
    .replace(/(\r\n|\n|\r)/gm, "\\n");

  const readmePath = "README.md";
  let readmeContent = fs.readFileSync(readmePath, "utf-8");
  const performanceResultsRegex =
    /<!-- PERFORMANCE_RESULTS_START -->[\s\S]*<!-- PERFORMANCE_RESULTS_END -->/;
  if (performanceResultsRegex.test(readmeContent)) {
    readmeContent = readmeContent.replace(
      performanceResultsRegex,
      finalResults
    );
  } else {
    readmeContent += `\n${finalResults}`;
  }
  fs.writeFileSync(readmePath, readmeContent);
}

resultFiles.forEach((file) => {
  fs.unlinkSync(file);
});
