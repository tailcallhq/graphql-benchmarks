import { writeDataFile } from './fileUtils';

export function generateGnuplotScript(whichBench: number, reqSecMax: number, latencyMax: number): string {
  const reqSecHistogramFile = `req_sec_histogram${whichBench}.png`;
  const latencyHistogramFile = `latency_histogram${whichBench}.png`;

  return `
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
plot '/tmp/reqSec.dat' using 2:xtic(1) title 'Req/Sec'

set output '${latencyHistogramFile}'
set title 'Latency (in ms)'
set yrange [0:${latencyMax}]
plot '/tmp/latency.dat' using 2:xtic(1) title 'Latency'
`;
}

export function writeGnuplotScript(script: string): void {
  const gnuplotScriptFile = '/tmp/gnuplot_script.gp';
  writeDataFile(gnuplotScriptFile, script);
}
