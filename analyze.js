const fs = require('fs').promises;
const path = require('path');
const { execSync } = require('child_process');

// You'll need to install these packages:
// npm install d3-array gnuplot

const d3 = require('d3-array');
const gnuplot = require('gnuplot');

const formattedServerNames = {
  tailcall: "Tailcall",
  gqlgen: "Gqlgen",
  apollo: "Apollo GraphQL",
  netflixdgs: "Netflix DGS",
  caliban: "Caliban",
  async_graphql: "async-graphql",
  hasura: "Hasura",
  graphql_jit: "GraphQL JIT"
};

const servers = ["apollo", "caliban", "netflixdgs", "gqlgen", "tailcall", "async_graphql", "hasura", "graphql_jit"];

async function extractMetric(file, metric) {
  const content = await fs.readFile(file, 'utf8');
  const match = content.match(new RegExp(`${metric}\\s+(\\d+(?:\\.\\d+)?)`));
  return match ? parseFloat(match[1]) : null;
}

async function processResults(resultFiles) {
  const avgReqSecs = {};
  const avgLatencies = {};

  for (let idx = 0; idx < servers.length; idx++) {
    const server = servers[idx];
    const startIdx = idx * 3;
    const reqSecVals = [];
    const latencyVals = [];

    for (let j = 0; j < 3; j++) {
      const fileIdx = startIdx + j;
      const reqSec = await extractMetric(resultFiles[fileIdx], "Requests/sec");
      const latency = await extractMetric(resultFiles[fileIdx], "Latency");
      if (reqSec) reqSecVals.push(reqSec);
      if (latency) latencyVals.push(latency);
    }

    avgReqSecs[server] = d3.mean(reqSecVals);
    avgLatencies[server] = d3.mean(latencyVals);
  }

  return { avgReqSecs, avgLatencies };
}

async function generatePlots(data, whichBench) {
  const reqSecData = Object.entries(data.avgReqSecs).map(([server, value]) => `${server} ${value}`).join('\n');
  const latencyData = Object.entries(data.avgLatencies).map(([server, value]) => `${server} ${value}`).join('\n');

  await fs.writeFile('/tmp/reqSec.dat', `Server Value\n${reqSecData}`);
  await fs.writeFile('/tmp/latency.dat', `Server Value\n${latencyData}`);

  const reqSecHistogramFile = `req_sec_histogram${whichBench}.png`;
  const latencyHistogramFile = `latency_histogram${whichBench}.png`;

  const gnuplotScript = `
    set term pngcairo size 1280,720 enhanced font "Courier,12"
    set output "${reqSecHistogramFile}"
    set style data histograms
    set style histogram cluster gap 1
    set style fill solid border -1
    set xtics rotate by -45
    set boxwidth 0.9
    set title "Requests/Sec"
    stats "/tmp/reqSec.dat" using 2 nooutput
    set yrange [0:STATS_max*1.2]
    set key outside right top
    plot "/tmp/reqSec.dat" using 2:xtic(1) title "Req/Sec"

    set output "${latencyHistogramFile}"
    set title "Latency (in ms)"
    stats "/tmp/latency.dat" using 2 nooutput
    set yrange [0:STATS_max*1.2]
    plot "/tmp/latency.dat" using 2:xtic(1) title "Latency"
  `;

  await fs.writeFile('/tmp/plot.gp', gnuplotScript);
  execSync('gnuplot /tmp/plot.gp');

  await fs.mkdir('assets', { recursive: true });
  await fs.rename(reqSecHistogramFile, path.join('assets', reqSecHistogramFile));
  await fs.rename(latencyHistogramFile, path.join('assets', latencyHistogramFile));
}

async function generateResultsTable(data, whichBench) {
  const sortedServers = Object.entries(data.avgReqSecs)
    .sort(([, a], [, b]) => b - a)
    .map(([server]) => server);

  const lastServer = sortedServers[sortedServers.length - 1];
  const lastServerReqSecs = data.avgReqSecs[lastServer];

  let resultsTable = "<!-- PERFORMANCE_RESULTS_START -->\n\n";
  resultsTable += "| Query | Server | Requests/sec | Latency (ms) | Relative |\n";
  resultsTable += "|-------:|--------:|--------------:|--------------:|---------:|\n";

  const queryMap = {
    1: "{ posts { id userId title user { id name email }}}",
    2: "{ posts { title }}",
    3: "{ greet }"
  };

  resultsTable += `| ${whichBench} | \`${queryMap[whichBench]}\` |`;

  for (const server of sortedServers) {
    const formattedReqSecs = data.avgReqSecs[server].toLocaleString('en-US', { maximumFractionDigits: 2 });
    const formattedLatencies = data.avgLatencies[server].toLocaleString('en-US', { maximumFractionDigits: 2 });
    const relativePerformance = (data.avgReqSecs[server] / lastServerReqSecs).toFixed(2);

    resultsTable += `\n|| [${formattedServerNames[server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` | \`${relativePerformance}x\` |`;
  }

  if (whichBench === 3) {
    resultsTable += "\n\n<!-- PERFORMANCE_RESULTS_END -->";
  }

  return resultsTable;
}

async function main(resultFiles) {
  const whichBench = resultFiles[0].startsWith('bench2') ? 2 : resultFiles[0].startsWith('bench3') ? 3 : 1;

  const data = await processResults(resultFiles);
  await generatePlots(data, whichBench);

  const resultsTable = await generateResultsTable(data, whichBench);
  await fs.appendFile('results.md', resultsTable + '\n');

  if (whichBench === 3) {
    const finalResults = (await fs.readFile('results.md', 'utf8')).replace(/\n/g, '\\n');
    console.log(finalResults.replace(/<!-- PERFORMANCE_RESULTS_START-->//g, '').replace(/<!-- PERFORMANCE_RESULTS_END-->/g, ''));

    const readmeContent = await fs.readFile('README.md', 'utf8');
    if (readmeContent.includes('PERFORMANCE_RESULTS_START')) {
      const newReadmeContent = readmeContent.replace(/PERFORMANCE_RESULTS_START[\s\S]*PERFORMANCE_RESULTS_END/, finalResults);
      await fs.writeFile('README.md', newReadmeContent);
    } else {
      await fs.appendFile('README.md', `\n${finalResults}`);
    }
  }

  for (const file of resultFiles) {
    await fs.unlink(file);
  }
}

// Usage: node script.js bench1_apollo_1.txt bench1_apollo_2.txt bench1_apollo_3.txt ...
main(process.argv.slice(2)).catch(console.error);
