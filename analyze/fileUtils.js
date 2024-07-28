"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.writeDataFile = writeDataFile;
exports.readFileContent = readFileContent;
exports.moveFile = moveFile;
exports.createDirectoryIfNotExists = createDirectoryIfNotExists;
var fs = require("fs");
function writeDataFile(filename, data) {
    try {
        fs.writeFileSync(filename, data);
    }
    catch (error) {
        console.error("Error writing data file ".concat(filename, ": ").concat(error.message));
    }
}
function readFileContent(filename) {
    try {
        return fs.readFileSync(filename, 'utf-8');
    }
    catch (error) {
        console.error("Error reading file ".concat(filename, ": ").concat(error.message));
        return '';
    }
}
function moveFile(source, destination) {
    try {
        if (fs.existsSync(source)) {
            fs.renameSync(source, destination);
            console.log("Moved ".concat(source, " to ").concat(destination));
        }
        else {
            console.log("Source file ".concat(source, " does not exist"));
        }
    }
    catch (error) {
        console.error("Error moving file ".concat(source, ": ").concat(error.message));
    }
}
function createDirectoryIfNotExists(dir) {
    if (!fs.existsSync(dir)) {
        try {
            fs.mkdirSync(dir);
        }
        catch (error) {
            console.error("Error creating directory: ".concat(error.message));
        }
    }
}
