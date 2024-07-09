import { spawn } from "child_process";
import { execaSync } from "execa";

export type Duration = `${string}s` | `${string}m`;

const execCommand = (cli: string, arg: string[], background = false) => {
  try {
    const { stdout, stderr } = execaSync(cli, arg, {
      ...(background ? { stdio: "ignore" } : {}),
    });
    if (stderr) {
      console.error(`Error: ${stderr}`);
    }
    return stdout;
  } catch (error) {
    console.error(`Execution failed: ${error.message}`);
  }
};

const execCommandBackground = (cli: string, arg: string[]) => {
  try {
    const subprocess = spawn(cli, arg, { stdio: "ignore", detached: true });
    subprocess.unref();
    return;
  } catch (error) {
    console.error(`Execution failed: ${error.message}`);
  }
};

const loadTestEndpoint = (
  duration: Duration,
  query: string,
  endpoint = "http://localhost:8000/graphql"
) => {
   const data = execCommand("oha", [
       "-z", duration,
       "-c", "100",
       "-m", "POST",
       "-H", "Connection: keep-alive",
       "-H", "Content-Type: application/json",
       "-d", query,
       "--json",
       endpoint
   ]);
   return data;
};

const killServerOnPort = (port: number) => {
  try {
    const command = `lsof -ti:${port} | xargs -r kill -9`;
    execCommand("bash", ["-c", command]);
    console.log(`Killed process running on port ${port}`);
  } catch (error) {
    console.log(`No process found running on port ${port}`);
  }
};

const sleep = (ms: number) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

const average = (numbers: number[]): number => {
  return numbers.reduce((sum, num) => sum + num, 0) / numbers.length;
};

const formatNumber = (num: number) => {
  new Intl.NumberFormat("en-US", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(num);
};

export {
  execCommandBackground,
  execCommand,
  loadTestEndpoint,
  killServerOnPort,
  formatNumber,
  average,
  sleep,
};
