"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateGnuplotScript = generateGnuplotScript;
exports.writeGnuplotScript = writeGnuplotScript;
var fileUtils_1 = require("./fileUtils");
function generateGnuplotScript(whichBench, reqSecMax, latencyMax) {
    var reqSecHistogramFile = "req_sec_histogram".concat(whichBench, ".png");
    var latencyHistogramFile = "latency_histogram".concat(whichBench, ".png");
    return "\nset term pngcairo size 1280,720 enhanced font 'Courier,12'\nset output '".concat(reqSecHistogramFile, "'\nset style data histograms\nset style histogram cluster gap 1\nset style fill solid border -1\nset xtics rotate by -45\nset boxwidth 0.9\nset title 'Requests/Sec'\nset yrange [0:").concat(reqSecMax, "]\nset key outside right top\nplot '/tmp/reqSec.dat' using 2:xtic(1) title 'Req/Sec'\n\nset output '").concat(latencyHistogramFile, "'\nset title 'Latency (in ms)'\nset yrange [0:").concat(latencyMax, "]\nplot '/tmp/latency.dat' using 2:xtic(1) title 'Latency'\n");
}
function writeGnuplotScript(script) {
    var gnuplotScriptFile = '/tmp/gnuplot_script.gp';
    (0, fileUtils_1.writeDataFile)(gnuplotScriptFile, script);
}
