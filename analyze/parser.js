"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseMetric = parseMetric;
exports.calculateAverage = calculateAverage;
exports.parseServerMetrics = parseServerMetrics;
function parseMetric(input, metric) {
    var lines = input.split('\n');
    var metricLine;
    if (metric === "Latency") {
        metricLine = lines.find(function (line) { return line.trim().startsWith("Latency"); });
    }
    else if (metric === "Requests/sec") {
        metricLine = lines.find(function (line) { return line.trim().startsWith("Requests/sec"); });
    }
    if (!metricLine)
        return null;
    var match = metricLine.match(/([\d.]+)/);
    return match ? parseFloat(match[1]) : null;
}
function calculateAverage(values) {
    if (values.length === 0)
        return 0;
    var sum = values.reduce(function (a, b) { return a + b; }, 0);
    return sum / values.length;
}
function parseServerMetrics(servers, inputs) {
    var serverMetrics = {};
    servers.forEach(function (server, idx) {
        var startIdx = idx * 3;
        var reqSecVals = [];
        var latencyVals = [];
        for (var j = 0; j < 3; j++) {
            var inputIdx = startIdx + j;
            if (inputIdx < inputs.length) {
                var reqSec = parseMetric(inputs[inputIdx], "Requests/sec");
                var latency = parseMetric(inputs[inputIdx], "Latency");
                if (reqSec !== null)
                    reqSecVals.push(reqSec);
                if (latency !== null)
                    latencyVals.push(latency);
            }
        }
        serverMetrics[server] = {
            reqSec: calculateAverage(reqSecVals),
            latency: calculateAverage(latencyVals)
        };
    });
    return serverMetrics;
}
