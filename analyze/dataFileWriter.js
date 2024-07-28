"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.writeMetricsDataFiles = writeMetricsDataFiles;
var fileUtils_1 = require("./fileUtils");
function writeMetricsDataFiles(serverMetrics, servers) {
    var reqSecData = "/tmp/reqSec.dat";
    var latencyData = "/tmp/latency.dat";
    (0, fileUtils_1.writeDataFile)(reqSecData, "Server Value\n" + servers.map(function (server) { return "".concat(server, " ").concat(serverMetrics[server].reqSec); }).join('\n'));
    (0, fileUtils_1.writeDataFile)(latencyData, "Server Value\n" + servers.map(function (server) { return "".concat(server, " ").concat(serverMetrics[server].latency); }).join('\n'));
}
