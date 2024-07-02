const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const formattedServerNames = {
  tailcall: "Tailcall",
  gqlgen: "Gqlgen",
  apollo: "Apollo GraphQL",
  netflixdgs: "Netflix DGS",
  caliban: "Caliban",
  async_graphql: "async-graphql",
};

const servers = [
  "apollo",
  "caliban",
  "netflixdgs",
  "gqlgen",
  "tailcall",
  "async_graphql",
];

const resultFiles = process.argv.slice(2);

/** @type {Object.<string, number>} */
const avgReqSecs = {};

/** @type {Object.<string, number>} */
const avgLatencies = {};

/**
 * @param {number[]} numbers - The array of numbers to average.
 * @returns {number} The average of the input numbers.
 */
const average = (numbers) =>
  numbers.reduce((sum, num) => sum + num, 0) / numbers.length;

const processResultFiles = () => {
  servers.forEach((server, idx) => {
    const startIdx = idx * 3;
    const reqSecVals = [];
    const latencyVals = [];

    for (let j = 0; j < 3; j++) {
      const fileIdx = startIdx + j;
      const jsonData = JSON.parse(
        fs.readFileSync(resultFiles[fileIdx], "utf8")
      );
      reqSecVals.push(jsonData.summary.requestsPerSec);
      latencyVals.push(jsonData.summary.average * 1000);
    }

    avgReqSecs[server] = average(reqSecVals);
    avgLatencies[server] = average(latencyVals);
  });
};

/**
 * @returns {{reqSecData: string, latencyData: string}} Paths to the generated data files.
 */
const generateGnuplotDataFiles = () => {
  const reqSecData = "/tmp/reqSec.dat";
  const latencyData = "/tmp/latency.dat";

  fs.writeFileSync(reqSecData, "Server Value\n");
  fs.writeFileSync(latencyData, "Server Value\n");

  servers.forEach((server) => {
    fs.appendFileSync(reqSecData, `${server} ${avgReqSecs[server]}\n`);
    fs.appendFileSync(latencyData, `${server} ${avgLatencies[server]}\n`);
  });

  return { reqSecData, latencyData };
};

/**
 * @param {string} reqSecData - Path to the requests per second data file.
 * @param {string} latencyData - Path to the latency data file.
 * @param {number} whichBench - The benchmark number.
 * @returns {{reqSecHistogramFile: string, latencyHistogramFile: string}} Paths to the generated histogram images.
 */
const generateGnuplotScript = (reqSecData, latencyData, whichBench) => {
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
    stats "${reqSecData}" using 2 nooutput
    set yrange [0:STATS_max*1.2]
    set key outside right top
    plot "${reqSecData}" using 2:xtic(1) title "Req/Sec"

    set output "${latencyHistogramFile}"
    set title "Latency (in ms)"
    stats "${latencyData}" using 2 nooutput
    set yrange [0:STATS_max*1.2]
    plot "${latencyData}" using 2:xtic(1) title "Latency"
  `;

  fs.writeFileSync("/tmp/plot.gp", gnuplotScript);
  execSync("gnuplot /tmp/plot.gp");

  return { reqSecHistogramFile, latencyHistogramFile };
};

/**
 * @param {string} reqSecHistogramFile - Path to the requests per second histogram file.
 * @param {string} latencyHistogramFile - Path to the latency histogram file.
 */
const moveGeneratedImages = (reqSecHistogramFile, latencyHistogramFile) => {
  if (!fs.existsSync("assets")) {
    fs.mkdirSync("assets");
  }

  fs.renameSync(reqSecHistogramFile, path.join("assets", reqSecHistogramFile));
  fs.renameSync(
    latencyHistogramFile,
    path.join("assets", latencyHistogramFile)
  );
};

/**
 * @param {number} whichBench - The benchmark number.
 * @returns {string} A formatted Markdown table of results.
 */
const buildResultsTable = (whichBench) => {
  const sortedServers = servers.sort((a, b) => avgReqSecs[b] - avgReqSecs[a]);

  return [
    `<!-- PERFORMANCE_RESULTS_START_${whichBench} -->`,
    "",
    "| Server | Requests/sec | Latency (ms) |",
    "|--------:|--------------:|--------------:|",
    ...sortedServers.map((server) => {
      const formattedReqSecs = avgReqSecs[server]
        .toFixed(2)
        .replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      const formattedLatencies = avgLatencies[server]
        .toFixed(2)
        .replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      return `| [${formattedServerNames[server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` |`;
    }),
    "",
    `<!-- PERFORMANCE_RESULTS_END_${whichBench} -->`,
  ].join("\n");
};

/**
 * @param {string} resultsTable - The formatted Markdown table of results.
 * @param {number} whichBench - The benchmark number.
 */
const updateReadme = (resultsTable, whichBench) => {
  const readmeContent = fs.readFileSync("README.md", "utf8");
  const regex = new RegExp(
    `<!-- PERFORMANCE_RESULTS_START_${whichBench} -->([\\s\\S]*?)<!-- PERFORMANCE_RESULTS_END_${whichBench} -->`
  );
  const updatedReadmeContent = readmeContent.replace(regex, resultsTable);
  fs.writeFileSync("README.md", updatedReadmeContent);
};

/**
 * @param {string} resultsTable - The formatted Markdown table of results.
 * @param {number} whichBench - The benchmark number.
 */
const updateResultsMd = (resultsTable, whichBench) => {
  fs.appendFileSync(
    "results.md",
    `## Benchmark ${whichBench} results\n\n${resultsTable}\n`
  );
};

const main = () => {
  processResultFiles();
  const { reqSecData, latencyData } = generateGnuplotDataFiles();
  const whichBench = resultFiles[0].startsWith("bench2") ? 2 : 1;
  const { reqSecHistogramFile, latencyHistogramFile } = generateGnuplotScript(
    reqSecData,
    latencyData,
    whichBench
  );
  moveGeneratedImages(reqSecHistogramFile, latencyHistogramFile);
  const resultsTable = buildResultsTable(whichBench);
  console.log(resultsTable);
  updateReadme(resultsTable, whichBench);
  updateResultsMd(resultsTable, whichBench);
  resultFiles.forEach((file) => fs.unlinkSync(file));
};

main();
