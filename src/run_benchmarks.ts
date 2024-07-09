import {
  killServerOnPort,
  execCommand,
  loadTestEndpoint,
  sleep,
  execCommandBackground,
} from "./utils";
import { analyzeBenchmarks } from "./analyze";
import { queries, servers } from "./config";
import fs from "fs";

const services = Object.keys(servers);

const bench1Results: string[] = [];
const bench2Results: string[] = [];
const bench3Results: string[] = [];

const beforeAll = async () => {
  killServerOnPort(8000);
  await sleep(5000);
  if (fs.existsSync("results.md")) {
    fs.unlinkSync("results.md");
  }
};

const afterAll = () => {
  [bench1Results, bench2Results, bench3Results].map((results) => {
    analyzeBenchmarks(results);
  });
};

async function runBenchmark(serviceScript: string) {
  const benchmarks = [1, 2, 3];
  const sanitizedServiceScriptName = serviceScript.replace(/\//g, "_");
  const resultFiles = Array.from(
    { length: 3 },
    (_, i) => `result${i + 1}_${sanitizedServiceScriptName}.json`
  );

  killServerOnPort(8000);
  await sleep(5000);

  execCommandBackground("bash", [serviceScript]);

  await sleep(15000);

  let graphqlEndpoint = "http://localhost:8000/graphql";
  if (serviceScript.includes("hasura")) {
    const stdout = execCommand("docker", [
      "inspect",
      "-f",
      "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}",
      "graphql-engine",
    ]);
    graphqlEndpoint = `http://${stdout?.trim()}:8080/v1/graphql`;
  }
  console.log(benchmarks, "benchmarks");
  
  for (const bench of benchmarks) {
    execCommand("bash", [`test_query${bench}.sh`, graphqlEndpoint]);

    for (const resultFile of resultFiles) {
      console.log(`Running benchmark ${bench} for ${serviceScript}`);
      const data = loadTestEndpoint(
        queries[bench].duration,
        queries[bench].query,
        graphqlEndpoint
      );

      fs.writeFileSync(`bench${bench}_${resultFile}`, data!);
      if (bench === 1) {
        bench1Results.push(`bench1_${resultFile}`);
      } else if (bench === 2) {
        bench2Results.push(`bench2_${resultFile}`);
      } else if (bench === 3) {
        bench3Results.push(`bench3_${resultFile}`);
      }
    }
  }
}

const runAllBenchmarks = async () => {
  for (const service of services) {
    await runBenchmark(`graphql/${service}/run.sh`);
    if (service === "apollo_server") {
      execCommand("cd", ["graphql/apollo_server/ && npm stop && cd ../../"]);
    } else if (service === "hasura") {
      execCommand("bash", ["graphql/hasura/kill.sh"]);
    }
  }
};

await beforeAll();
await runAllBenchmarks();
afterAll();
