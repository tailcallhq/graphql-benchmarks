const { execSync, exec } = require("child_process");
const fs = require("fs");

const services = [
  "apollo_server",
  "caliban",
  "netflix_dgs",
  "gqlgen",
  "tailcall",
  "async_graphql",
];

let bench1Results = [];
let bench2Results = [];

/**
 * Kills the process running on the specified port
 * @param {number} port - The port number
 */
const killServerOnPort = (port) => {
  try {
    const command = `lsof -ti:${port} | xargs -r kill -9`;
    execSync(command, { stdio: "ignore" });
    console.log(`killed process on port ${port}`);
  } catch (error) {
    console.log(`No process found running on port ${port}`);
  }
};

/**
 * Run the benchmark for the specified service script.
 * @param {string} serviceScript - The path to the service script.
 */
const runBenchmark = (serviceScript) => {
  killServerOnPort(8000);
  execSync("sleep 5");

  const benchmarks = [1, 2];
  exec(`${serviceScript} &`);
  execSync("sleep 15");

  benchmarks.forEach((bench) => {
    const benchmarkScript = `oha/bench${bench}.sh`;
    const sanitizedServiceScriptName = serviceScript.replace(/\//g, "_");
    const resultFiles = Array.from(
      { length: 3 },
      (_, i) => `result${i + 1}_${sanitizedServiceScriptName}.json`
    );

    execSync(`bash test_query${bench}.sh`);

    Array.from({ length: 3 }).map(() => {
      execSync(`bash ${benchmarkScript} > /dev/null`);
      execSync("sleep 1");
    });

    resultFiles.map((resultFile) => {
      console.log(`Running benchmark ${bench} for ${serviceScript}`);
      execSync(`bash ${benchmarkScript} > bench${bench}_${resultFile}`);
      if (bench === 1) {
        bench1Results.push(`bench1_${resultFile}`);
      } else {
        bench2Results.push(`bench2_${resultFile}`);
      }
    });
  });
};

if (fs.existsSync("results.md")) {
  fs.unlinkSync("results.md");
}

services.map((service) => {
  runBenchmark(`graphql/${service}/run.sh`);
  if (service === "apollo_server") {
    process.chdir("graphql/apollo_server/");
    execSync("npm stop");
    process.chdir("../../");
  }
});

execSync(`node analyze.js ${bench1Results.join(" ")}`);
execSync(`node analyze.js ${bench2Results.join(" ")}`);

process.exit(0);