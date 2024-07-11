#!/usr/bin/env node

const fs = require("fs");
const { exec } = require("child_process");
const path = require("path");

// Helper functions
const extractMetric = (file, metric) => {
  const content = fs.readFileSync(file, "utf-8");
  const regex = new RegExp(`${metric}\\s+(\\d+\\.?\\d*)`);
  const match = content.match(regex);
  return match ? parseFloat(match[1]) : null;
};

const average = (values) =>
  values.reduce((sum, value) => sum + value, 0) / values.length;

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

const servers = [
  "apollo",
  "caliban",
  "netflixdgs",
  "gqlgen",
  "tailcall",
  "async_graphql",
  "hasura",
  "graphql_jit",
];
const resultFiles = process.argv.slice(2);
const avgReqSecs = {};
const avgLatencies = {};

// Extract metrics and calculate averages
servers.forEach((server, idx) => {
  const reqSecVals = [];
  const latencyVals = [];
  for (let j = 0; j < 3; j++) {
    const fileIdx = idx * 3 + j;
    reqSecVals.push(extractMetric(resultFiles[fileIdx], "Requests/sec"));
    latencyVals.push(extractMetric(resultFiles[fileIdx], "Latency"));
  }
  avgReqSecs[server] = average(reqSecVals);
  avgLatencies[server] = average(latencyVals);
});

// Generating data files for gnuplot
const reqSecData = "/tmp/reqSec.dat";
const latencyData = "/tmp/latency.dat";

const writeDataFile = (filePath, data) => {
  const content = [
    "Server Value",
    ...data.map(({ server, value }) => `${server} ${value}`),
  ].join("\n");
  fs.writeFileSync(filePath, content);
};

writeDataFile(
  reqSecData,
  servers.map((server) => ({ server, value: avgReqSecs[server] }))
);
writeDataFile(
  latencyData,
  servers.map((server) => ({ server, value: avgLatencies[server] }))
);

// Determine which benchmark to use
let whichBench = 1;
if (resultFiles[0].startsWith("bench2")) {
  whichBench = 2;
} else if (resultFiles[0].startsWith("bench3")) {
  whichBench = 3;
}

const reqSecHistogramFile = `req_sec_histogram${whichBench}.png`;
const latencyHistogramFile = `latency_histogram${whichBench}.png`;

// Plotting using gnuplot
const plotWithGnuplot = (outputFile, title, dataFile) => {
  const script = `
    set term pngcairo size 1280,720 enhanced font "Courier,12"
    set output "${outputFile}"
    set style data histograms
    set style histogram cluster gap 1
    set style fill solid border -1
    set xtics rotate by -45
    set boxwidth 0.9
    set title "${title}"
    stats "${dataFile}" using 2 nooutput
    set yrange [0:STATS_max*1.2]
    set key outside right top
    plot "${dataFile}" using 2:xtic(1) title "${title.split(" ")[0]}"
  `;
  exec(`gnuplot -e '${script}'`);
};

plotWithGnuplot(reqSecHistogramFile, "Requests/Sec", reqSecData);
plotWithGnuplot(latencyHistogramFile, "Latency (in ms)", latencyData);

// Move PNGs to assets
const assetsDir = path.join(__dirname, "assets");
if (!fs.existsSync(assetsDir)) {
  fs.mkdirSync(assetsDir);
}
fs.renameSync(reqSecHistogramFile, path.join(assetsDir, reqSecHistogramFile));
fs.renameSync(latencyHistogramFile, path.join(assetsDir, latencyHistogramFile));

// Calculate relative performance and build the results table
const serverRPS = {};
servers.forEach((server) => {
  serverRPS[server] = avgReqSecs[server];
});

const sortedServers = Object.keys(serverRPS).sort(
  (a, b) => serverRPS[b] - serverRPS[a]
);
const lastServer = sortedServers[sortedServers.length - 1];
const lastServerReqSecs = avgReqSecs[lastServer];

let resultsTable = "";

if (whichBench === 1) {
  resultsTable += `<!-- PERFORMANCE_RESULTS_START -->\n\n| Query | Server | Requests/sec | Latency (ms) | Relative |\n|-------:|--------:|--------------:|--------------:|---------:|\n| ${whichBench} | \`{ posts { id userId title user { id name email }}}\` |`;
} else if (whichBench === 2) {
  resultsTable += `| ${whichBench} | \`{ posts { title }}\` |`;
} else if (whichBench === 3) {
  resultsTable += `| ${whichBench} | \`{ greet }\` |`;
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
  const relativePerformance = (avgReqSecs[server] / lastServerReqSecs).toFixed(
    2
  );

  resultsTable += `\n|| [${formattedServerNames[server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` | \`${relativePerformance}x\` |`;
});

if (whichBench === 3) {
  resultsTable += `\n\n<!-- PERFORMANCE_RESULTS_END -->`;
}

const resultsFile = "results.md";
fs.writeFileSync(resultsFile, resultsTable);

if (whichBench === 3) {
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

// Delete the result TXT files
resultFiles.forEach((file) => {
  fs.unlinkSync(file);
});
