const fs = require('fs');
const path = require('path');
const exec = require('child_process').execSync;

const extractMetric = (file, metric) => {
    console.log(`Reading file: ${file}`);
    const content = fs.readFileSync(file, 'utf-8');
    const match = content.match(new RegExp(`${metric}: (\\d+\\.?\\d*)`));
    return match ? parseFloat(match[1]) : null;
};

const average = (values) => {
    const sum = values.reduce((acc, val) => acc + val, 0);
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
    const reqSecVals = [];
    const latencyVals = [];
    for (let j = 0; j < 3; j++) {
        const fileIdx = idx * 3 + j;
        console.log(`Processing server: ${server}, file index: ${fileIdx}, file path: ${resultFiles[fileIdx]}`);
        reqSecVals.push(extractMetric(resultFiles[fileIdx], 'Requests/sec'));
        latencyVals.push(extractMetric(resultFiles[fileIdx], 'Latency'));
    }
    avgReqSecs[server] = average(reqSecVals);
    avgLatencies[server] = average(latencyVals);
});

// Generating data files for gnuplot
const reqSecData = '/tmp/reqSec.dat';
const latencyData = '/tmp/latency.dat';

const writeDataFile = (filePath, data) => {
    const content = 'Server Value\n' + data.map(([server, value]) => `${server} ${value}`).join('\n');
    fs.writeFileSync(filePath, content);
};

writeDataFile(reqSecData, servers.map(server => [server, avgReqSecs[server]]));
writeDataFile(latencyData, servers.map(server => [server, avgLatencies[server]]));

const whichBench = resultFiles[0].includes('bench2') ? 2 : 1;
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

exec(`echo "${gnuplotScript}" | gnuplot`);

const assetsDir = 'assets';
if (!fs.existsSync(assetsDir)) {
    fs.mkdirSync(assetsDir);
}

fs.renameSync(reqSecHistogramFile, path.join(assetsDir, reqSecHistogramFile));
fs.renameSync(latencyHistogramFile, path.join(assetsDir, latencyHistogramFile));

const resultsTable = [
    `<!-- PERFORMANCE_RESULTS_START_${whichBench} -->`,
    '',
    '| Server | Requests/sec | Latency (ms) |',
    '|--------:|--------------:|--------------:|',
    ...servers.map(server => {
        const formattedReqSecs = avgReqSecs[server].toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        const formattedLatencies = avgLatencies[server].toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        return `| ${formattedServerNames[server]} | \`${formattedReqSecs}\` | \`${formattedLatencies}\` |`;
    }),
    '',
    `<!-- PERFORMANCE_RESULTS_END_${whichBench} -->`
].join('\n');

const updateReadme = (table, whichBench) => {
    const readmePath = 'README.md';
    const readmeContent = fs.readFileSync(readmePath, 'utf-8');
    const newContent = readmeContent.replace(
        new RegExp(`<!-- PERFORMANCE_RESULTS_START_${whichBench} -->[\\s\\S]*<!-- PERFORMANCE_RESULTS_END_${whichBench} -->`, 'm'),
        table
    );
    fs.writeFileSync(readmePath, newContent);
};

updateReadme(resultsTable, whichBench);

console.log(resultsTable.replace(`<!-- PERFORMANCE_RESULTS_START_${whichBench} -->`, '').replace(`<!-- PERFORMANCE_RESULTS_END_${whichBench} -->`, ''));
