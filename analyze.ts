#!/usr/bin/env node
import { execSync } from 'child_process';
import * as path from 'path';
import * as fs from 'fs';
import { servers, formattedServerNames } from './analyze/config';
import { createDirectoryIfNotExists, moveFile, readFileContent } from './analyze/fileUtils';
import { parseServerMetrics } from './analyze/parser';
import { writeMetricsDataFiles } from './analyze/dataFileWriter';
import { generateGnuplotScript, writeGnuplotScript } from './analyze/gnuplotGenerator';
import { formatResults, writeResults } from './analyze/resultsFormatter';

const resultFiles: string[] = process.argv.slice(2);

// Read content of result files
const resultContents: string[] = resultFiles.map(file => readFileContent(file));

const serverMetrics = parseServerMetrics(servers, resultContents);

writeMetricsDataFiles(serverMetrics, servers);

let whichBench = 1;
if (resultFiles.length > 0) {
  if (resultFiles[0].startsWith("bench2")) {
    whichBench = 2;
  } else if (resultFiles[0].startsWith("bench3")) {
    whichBench = 3;
  }
}

function getMaxValue(data: string): number {
  try {
    return Math.max(...data.split('\n')
      .slice(1)
      .map(line => {
        const [, valueStr] = line.split(' ');
        const value = parseFloat(valueStr);
        if (isNaN(value)) {
          throw new Error(`Invalid number in data: ${valueStr}`);
        }
        return value;
      }));
  } catch (error) {
    console.error(`Error getting max value: ${(error as Error).message}`);
    return 0;
  }
}

const reqSecMax = getMaxValue(readFileContent('/tmp/reqSec.dat')) * 1.2;
const latencyMax = getMaxValue(readFileContent('/tmp/latency.dat')) * 1.2;

const gnuplotScript = generateGnuplotScript(whichBench, reqSecMax, latencyMax);
writeGnuplotScript(gnuplotScript);

try {
  execSync(`gnuplot /tmp/gnuplot_script.gp`, { stdio: 'inherit' });
  console.log('Gnuplot executed successfully');
} catch (error) {
  console.error('Error executing gnuplot:', (error as Error).message);
}

const assetsDir = path.join(__dirname, "assets");
createDirectoryIfNotExists(assetsDir);

moveFile(`req_sec_histogram${whichBench}.png`, path.join(assetsDir, `req_sec_histogram${whichBench}.png`));
moveFile(`latency_histogram${whichBench}.png`, path.join(assetsDir, `latency_histogram${whichBench}.png`));

const resultsTable = formatResults(serverMetrics, formattedServerNames, whichBench);
writeResults(resultsTable, whichBench);

resultFiles.forEach((file) => {
  try {
    fs.unlinkSync(file);
  } catch (error) {
    console.error(`Error deleting file ${file}: ${(error as Error).message}`);
  }
});
