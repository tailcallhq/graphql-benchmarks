import * as fs from 'fs';
import { FormattedServerNames, ServerMetrics } from './types';

export function formatResults(serverMetrics: Record<string, ServerMetrics>, formattedServerNames: FormattedServerNames, whichBench: number): string {
  const sortedServers = Object.keys(serverMetrics).sort(
    (a, b) => serverMetrics[b].reqSec - serverMetrics[a].reqSec
  );
  const lastServer = sortedServers[sortedServers.length - 1];
  const lastServerReqSecs = serverMetrics[lastServer].reqSec;

  let resultsTable = "";

  if (whichBench === 1) {
    resultsTable += `\n| ${whichBench} | \`{ posts { id userId title user { id name email }}}\` |`;
  } else if (whichBench === 2) {
    resultsTable += `\n| ${whichBench} | \`{ posts { title }}\` |`;
  } else if (whichBench === 3) {
    resultsTable += `\n| ${whichBench} | \`{ greet }\` |`;
  }

  sortedServers.forEach((server) => {
    const formattedReqSecs = serverMetrics[server].reqSec.toLocaleString(undefined, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
    const formattedLatencies = serverMetrics[server].latency.toLocaleString(undefined, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
    const relativePerformance = (serverMetrics[server].reqSec / lastServerReqSecs).toFixed(2);

    resultsTable += `\n|| [${formattedServerNames[server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` | \`${relativePerformance}x\` |`;
  });

  return resultsTable;
}

export function writeResults(resultsTable: string, whichBench: number): void {
  const resultsFile = "results.md";

  try {
    if (!fs.existsSync(resultsFile) || fs.readFileSync(resultsFile, 'utf8').trim() === '') {
      fs.writeFileSync(resultsFile, `<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|`);
    }

    fs.appendFileSync(resultsFile, resultsTable);

    if (whichBench === 3) {
      fs.appendFileSync(resultsFile, "\n\n<!-- PERFORMANCE_RESULTS_END -->");
      updateReadme(resultsFile);
    }
  } catch (error) {
    console.error(`Error writing results: ${(error as Error).message}`);
  }
}

function updateReadme(resultsFile: string): void {
  try {
    const finalResults = fs
      .readFileSync(resultsFile, "utf-8")
      .replace(/\\/g, '');  // Remove backslashes

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
    console.log("README.md updated successfully");
  } catch (error) {
    console.error(`Error updating README: ${(error as Error).message}`);
  }
}
