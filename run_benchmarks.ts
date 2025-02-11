import { exec, execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import * as util from 'util';

const execAsync = util.promisify(exec);

// Start services and run benchmarks
function killServerOnPort(port: number): void {
  try {
    const pid: string = execSync(`lsof -t -i:${port}`).toString().trim();
    if (pid) {
      execSync(`kill ${pid}`);
      console.log(`Killed process running on port ${port}`);
    } else {
      console.log(`No process found running on port ${port}`);
    }
  } catch (error) {
    console.error(`Error killing server on port ${port}:`, (error as Error).message);
  }
}

const bench1Results: string[] = [];
const bench2Results: string[] = [];
const bench3Results: string[] = [];

killServerOnPort(3000);
execSync('sh nginx/run.sh');

async function runBenchmarkAsync(serviceScript: string, bench: number): Promise<void> {
  let graphqlEndpoint = 'http://localhost:8000/graphql';
  if (serviceScript.includes('hasura')) {
    graphqlEndpoint = 'http://127.0.0.1:8080/v1/graphql';
  }
  const benchmarkScript = 'wrk/bench.sh';
  const sanitizedServiceScriptName = serviceScript.replace(/\//g, '_');
  const resultFiles = [
    `result1_${sanitizedServiceScriptName}.txt`,
    `result2_${sanitizedServiceScriptName}.txt`,
    `result3_${sanitizedServiceScriptName}.txt`
  ];

  await execAsync(`bash test_query${bench}.sh ${graphqlEndpoint}`);

  // Warmup run
  for (let i = 0; i < 3; i++) {
    await execAsync(`bash ${benchmarkScript} ${graphqlEndpoint} ${bench} > /dev/null`);
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  // 3 benchmark runs
  for (const resultFile of resultFiles) {
    console.log(`Running benchmark ${bench} for ${serviceScript}`);
    const outputFile = `bench${bench}_${resultFile}`;
    await execAsync(`bash ${benchmarkScript} ${graphqlEndpoint} ${bench} > ${outputFile}`);
    if (bench === 1) {
      bench1Results.push(outputFile);
    } else if (bench === 2) {
      bench2Results.push(outputFile);
    } else if (bench === 3) {
      bench3Results.push(outputFile);
    }
  }
}

async function runBenchmark(serviceScript: string): Promise<void> {
  killServerOnPort(8000);
  execSync('sleep 5');
  if (serviceScript.includes('hasura')) {
    execSync(`bash ${serviceScript}`, { stdio: 'inherit' });
  } else {
    execSync(`bash ${serviceScript} &`, { stdio: 'inherit' });
  }
  execSync('sleep 15');

  const benchmarks = [1, 2, 3];
  const benchmarkPromises: Promise<void>[] = benchmarks.map(bench => runBenchmarkAsync(serviceScript, bench));
  await Promise.all(benchmarkPromises);
}

// Main script
if (process.argv.length < 3) {
  console.log('Usage: node script.js <service_name>');
  console.log('Available services: apollo_server, caliban, netflix_dgs, gqlgen, tailcall, async_graphql, hasura, graphql_jit');
  process.exit(1);
}

const service: string = process.argv[2];
const validServices: string[] = ['apollo_server', 'caliban', 'netflix_dgs', 'gqlgen', 'tailcall', 'async_graphql', 'hasura', 'graphql_jit'];

if (!validServices.includes(service)) {
  console.log(`Invalid service name. Available services: ${validServices.join(', ')}`);
  process.exit(1);
}

if (fs.existsSync('results.md')) {
  fs.unlinkSync('results.md');
}

async function main(): Promise<void> {
  await runBenchmark(`graphql/${service}/run.sh`);
  if (service === 'apollo_server') {
    process.chdir('graphql/apollo_server');
    execSync('npm stop');
    process.chdir('../../');
  } else if (service === 'hasura') {
    execSync('bash graphql/hasura/kill.sh');
  }
}

main().catch((error: Error) => {
  console.error("An error occurred:", error);
  process.exit(1);
});
