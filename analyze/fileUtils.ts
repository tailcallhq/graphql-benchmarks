import * as fs from 'fs';
import * as path from 'path';

export function writeDataFile(filename: string, data: string): void {
  try {
    fs.writeFileSync(filename, data);
  } catch (error) {
    console.error(`Error writing data file ${filename}: ${(error as Error).message}`);
  }
}

export function readFileContent(filename: string): string {
  try {
    return fs.readFileSync(filename, 'utf-8');
  } catch (error) {
    console.error(`Error reading file ${filename}: ${(error as Error).message}`);
    return '';
  }
}

export function moveFile(source: string, destination: string): void {
  try {
    if (fs.existsSync(source)) {
      fs.renameSync(source, destination);
      console.log(`Moved ${source} to ${destination}`);
    } else {
      console.log(`Source file ${source} does not exist`);
    }
  } catch (error) {
    console.error(`Error moving file ${source}: ${(error as Error).message}`);
  }
}

export function createDirectoryIfNotExists(dir: string): void {
  if (!fs.existsSync(dir)) {
    try {
      fs.mkdirSync(dir);
    } catch (error) {
      console.error(`Error creating directory: ${(error as Error).message}`);
    }
  }
}
