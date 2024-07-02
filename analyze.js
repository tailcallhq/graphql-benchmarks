const fs = require('fs');
const path = require('path');
const exec = require('child_process').execSync;

const extractMetric = (file, metric) => {
    const content = fs.readFileSync(file, 'utf-8');
    const line = content.split('\n').find(line => line.includes(metric));
    return line ? line.split(' ')[1].replace('ms', '') : null;
};

const average = (values) => {
    const sum = values.reduce((acc, val) => acc + parseFloat(val), 0);
    return sum / values.length;
};

const formattedServerNames = {
    tailcall: 'Tailcall',
    gqlgen: 'Gqlgen',
    apollo: 'Apollo GraphQL',
    netflixdgs: 'Netflix DGS',
    caliban: 'Caliban',
    async_graphql: 'async-graphql'
};

const servers = ['apollo', 'caliban', 'netflixdgs', 'gqlgen', 'tailcall', 'async_graphql'];
const resultFiles = process.argv.slice(2);
const avgReqSecs = {};
const avgLatencies = {};

servers.forEach((server, idx) => {
    const startIdx = idx * 3;
    const reqSecVals = [];
    const latencyVals = [];

    for (let j = 0; j < 3; j++) {
        const fileIdx = startIdx + j;
        reqSecVals.push(extractMetric(resultFiles[fileIdx], 'Requests/sec'));
        latencyVals.push(extractMetric(resultFiles[fileIdx], 'Latency'));
    }

    avgReqSecs[server] = average(reqSecVals);
    avgLatencies[server] = average(latencyVals);
});

// Generating data files for gnuplot
const reqSecData = '/tmp/reqSec.dat';
const latencyData = '/tmp/latency.dat';

fs.writeFileSync(reqSecData, 'Server Value\n' + servers.map(server => `${server} ${avgReqSecs[server]}`).join('\n'));
fs.writeFileSync(latencyData, 'Server Value\n' + servers.map(server => `${server} ${avgLatencies[server]}`).join('\n'));

const whichBench = resultFiles[0].startsWith('bench2') ? 2 : 1;

const reqSecHistogramFile = `req_sec_histogram${whichBench}.png`;
const latencyHistogramFile = `latency_histogram${whichBench}.png`;

// Plotting using gnuplot
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

exec(`gnuplot -e "${gnuplotScript}"`);

const assetsDir = 'assets';
if (!fs.existsSync(assetsDir)) {
    fs.mkdirSync(assetsDir);
}

fs.renameSync(reqSecHistogramFile, path.join(assetsDir, reqSecHistogramFile));
fs.renameSync(latencyHistogramFile, path.join(assetsDir, latencyHistogramFile));

const serverRPS = {};
servers.forEach(server => {
    serverRPS[server] = avgReqSecs[server];
});

const sortedServers = Object.keys(serverRPS).sort((a, b) => serverRPS[b] - serverRPS[a]);

const resultsTable = [
    `<!-- PERFORMANCE_RESULTS_START_${whichBench} -->`,
    '',
    '| Server | Requests/sec | Latency (ms) |',
    '|--------:|--------------:|--------------:|',
    ...sortedServers.map(server => {
        const formattedReqSecs = parseFloat(avgReqSecs[server]).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        const formattedLatencies = parseFloat(avgLatencies[server]).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        return `| [${formattedServerNames[server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` |`;
    }),
    '',
    `<!-- PERFORMANCE_RESULTS_END_${whichBench} -->`
].join('\n');

const readmeFile = 'README.md';
const readmeContent = fs.readFileSync(readmeFile, 'utf-8');

if (readmeContent.includes(`PERFORMANCE_RESULTS_START_${whichBench}`)) {
    const newContent = readmeContent.replace(
        new RegExp(`<!-- PERFORMANCE_RESULTS_START_${whichBench} -->[\\s\\S]*<!-- PERFORMANCE_RESULTS_END_${whichBench} -->`, 'm'),
        resultsTable
    );
    fs.writeFileSync(readmeFile, newContent);
} else {
    fs.appendFileSync(readmeFile, `\n${resultsTable}`);
}

const resultsFile = 'results.md';
fs.writeFileSync(resultsFile, `## Benchmark ${whichBench} results\n\n${resultsTable}`);

console.log(resultsTable.replace(`<!-- PERFORMANCE_RESULTS_START_${whichBench} -->`, '').replace(`<!-- PERFORMANCE_RESULTS_END_${whichBench} -->`, ''));

resultFiles.forEach(file => fs.unlinkSync(file));
