"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.formatResults = formatResults;
exports.writeResults = writeResults;
var fs = require("fs");
function formatResults(serverMetrics, formattedServerNames, whichBench) {
    var sortedServers = Object.keys(serverMetrics).sort(function (a, b) { return serverMetrics[b].reqSec - serverMetrics[a].reqSec; });
    var lastServer = sortedServers[sortedServers.length - 1];
    var lastServerReqSecs = serverMetrics[lastServer].reqSec;
    var resultsTable = "";
    if (whichBench === 1) {
        resultsTable += "\n| ".concat(whichBench, " | `{ posts { id userId title user { id name email }}}` |");
    }
    else if (whichBench === 2) {
        resultsTable += "\n| ".concat(whichBench, " | `{ posts { title }}` |");
    }
    else if (whichBench === 3) {
        resultsTable += "\n| ".concat(whichBench, " | `{ greet }` |");
    }
    sortedServers.forEach(function (server) {
        var formattedReqSecs = serverMetrics[server].reqSec.toLocaleString(undefined, {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
        });
        var formattedLatencies = serverMetrics[server].latency.toLocaleString(undefined, {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
        });
        var relativePerformance = (serverMetrics[server].reqSec / lastServerReqSecs).toFixed(2);
        resultsTable += "\n|| [".concat(formattedServerNames[server], "] | `").concat(formattedReqSecs, "` | `").concat(formattedLatencies, "` | `").concat(relativePerformance, "x` |");
    });
    return resultsTable;
}
function writeResults(resultsTable, whichBench) {
    var resultsFile = "results.md";
    try {
        if (!fs.existsSync(resultsFile) || fs.readFileSync(resultsFile, 'utf8').trim() === '') {
            fs.writeFileSync(resultsFile, "<!-- PERFORMANCE_RESULTS_START -->\n\n| Query | Server | Requests/sec | Latency (ms) | Relative |\n|-------:|--------:|--------------:|--------------:|---------:|");
        }
        fs.appendFileSync(resultsFile, resultsTable);
        if (whichBench === 3) {
            fs.appendFileSync(resultsFile, "\n\n<!-- PERFORMANCE_RESULTS_END -->");
            updateReadme(resultsFile);
        }
    }
    catch (error) {
        console.error("Error writing results: ".concat(error.message));
    }
}
function updateReadme(resultsFile) {
    try {
        var finalResults = fs
            .readFileSync(resultsFile, "utf-8")
            .replace(/\\/g, ''); // Remove backslashes
        var readmePath = "README.md";
        var readmeContent = fs.readFileSync(readmePath, "utf-8");
        var performanceResultsRegex = /<!-- PERFORMANCE_RESULTS_START -->[\s\S]*<!-- PERFORMANCE_RESULTS_END -->/;
        if (performanceResultsRegex.test(readmeContent)) {
            readmeContent = readmeContent.replace(performanceResultsRegex, finalResults);
        }
        else {
            readmeContent += "\n".concat(finalResults);
        }
        fs.writeFileSync(readmePath, readmeContent);
        console.log("README.md updated successfully");
    }
    catch (error) {
        console.error("Error updating README: ".concat(error.message));
    }
}
