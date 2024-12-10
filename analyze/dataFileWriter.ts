import { writeDataFile } from './fileUtils';
import { ServerMetrics } from './types';

export function writeMetricsDataFiles(serverMetrics: Record<string, ServerMetrics>, servers: string[]): void {
  const reqSecData = "/tmp/reqSec.dat";
  const latencyData = "/tmp/latency.dat";

  writeDataFile(reqSecData, "Server Value\n" + servers.map(server => `${server} ${serverMetrics[server].reqSec}`).join('\n'));
  writeDataFile(latencyData, "Server Value\n" + servers.map(server => `${server} ${serverMetrics[server].latency}`).join('\n'));
}
