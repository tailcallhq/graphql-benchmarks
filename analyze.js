#!/usr/bin/env node

const fs = require("fs");
const { execSync } = require("child_process");

const average = (arr) => arr.reduce((a, b) => a + b, 0) / arr.length;

const servers = ["apollo", "caliban", "netflixdgs", "gqlgen", "tailcall", "async_graphql", "hasura", "graphql_jit"];
const formattedServerNames = {
  "tailcall": "Tailcall",
  "gqlgen": "Gqlgen",
  "apollo": "Apollo GraphQL",
  "netflixdgs": "Netflix DGS",
  "caliban": "Caliban",
  "async_graphql": "async-graphql",
  "hasura": "Hasura",
  "graphql_jit": "GraphQL JIT"
};

const resultFiles = process.argv
  .slice(2)
  .filter((arg) => arg.startsWith("result") && fs.existsSync(arg));

const extractMetrics = (files) => {
  return files.map((file) => {
    const { summary } = JSON.parse(fs.readFileSync(file, "utf8"));
    return {
      requestsPerSec: summary.requestsPerSec,
      latency: summary.average * 1000,
    };
  });
};

const calculateAverages = (metrics) => {
  return servers.reduce((acc, server, index) => {
    const serverMetrics = metrics.slice(index * 3, (index + 1) * 3);
    acc[server] = {
      avgReqSec: average(serverMetrics.map((m) => m.requestsPerSec)),
      avgLatency: average(serverMetrics.map((m) => m.latency)),
    };
    return acc;
  }, {});
};

const writeDataFile = (filename, data) => {
  fs.writeFileSync(filename, "Server Value\n");
  Object.entries(data).forEach(([server, value]) => {
    fs.appendFileSync(filename, `${server} ${value}\n`);
  });
};

const generateGnuplotScript = (reqSecData, latencyData) => `
set term pngcairo size 1280,720 enhanced font "Courier,12"
set style data histograms
set style histogram cluster gap 1
set style fill solid border -1
set xtics rotate by -45
set boxwidth 0.9
set key outside right top
set output "req_sec_histogram.png"
set title "Requests/Sec"
stats "${reqSecData}" using 2 nooutput
set yrange [0:*]
plot "${reqSecData}" using 2:xtic(1) title "Req/Sec"
set output "latency_histogram.png"
set title "Latency (in ms)"
stats "${latencyData}" using 2 nooutput
set yrange [0:*]
plot "${latencyData}" using 2:xtic(1) title "Latency"
`;

const generateResultsTable = (averages) => {
  let table =
    "<!-- PERFORMANCE_RESULTS_START -->\n| Server | Requests/sec | Latency (ms) |\n|--------|--------------|--------------|";
  Object.entries(averages).forEach(([server, { avgReqSec, avgLatency }]) => {
    table += `\n| ${server} | ${avgReqSec} | ${avgLatency} |`;
  });
  return table + "\n<!-- PERFORMANCE_RESULTS_END -->";
};

const updateReadme = (resultsTable) => {
  const readmePath = "README.md";
  let content = fs.readFileSync(readmePath, "utf8");
  const regex =
    /<!-- PERFORMANCE_RESULTS_START -->[\s\S]*<!-- PERFORMANCE_RESULTS_END -->/;
  content = content.includes("PERFORMANCE_RESULTS_START")
    ? content.replace(regex, resultsTable)
    : content + "\n\n" + resultsTable;
  fs.writeFileSync(readmePath, content);
};

const main = () => {
  const metrics = extractMetrics(resultFiles);
  const averages = calculateAverages(metrics);

  resultFiles.forEach(fs.unlinkSync);

  const reqSecData = "/tmp/reqSec.dat";
  const latencyData = "/tmp/latency.dat";

  writeDataFile(
    reqSecData,
    Object.fromEntries(
      Object.entries(averages).map(([k, v]) => [k, v.avgReqSec])
    )
  );
  writeDataFile(
    latencyData,
    Object.fromEntries(
      Object.entries(averages).map(([k, v]) => [k, v.avgLatency])
    )
  );

  const gnuplotScript = generateGnuplotScript(reqSecData, latencyData);
  fs.writeFileSync("/tmp/gnuplot_script", gnuplotScript);
  execSync("gnuplot /tmp/gnuplot_script");

  if (!fs.existsSync("assets")) fs.mkdirSync("assets");
  ["req_sec_histogram.png", "latency_histogram.png"].forEach((file) =>
    fs.renameSync(file, `assets/${file}`)
  );

  const resultsTable = generateResultsTable(averages);
  updateReadme(resultsTable);

  console.log(resultsTable.replace(/<!--.*?-->\n?/g, ""));

  execSync(
    "git add README.md assets/req_sec_histogram.png assets/latency_histogram.png"
  );
  execSync('git commit -m "Updated performance results in README.md"');
  execSync("git push");

  resultFiles.forEach(fs.unlinkSync);
};

main();
