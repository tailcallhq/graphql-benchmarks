import { ServerMetrics } from './types';

export function parseMetric(input: string, metric: string): number | null {
  const lines = input.split('\n');
  let metricLine: string | undefined;

  if (metric === "Latency") {
    metricLine = lines.find(line => line.trim().startsWith("Latency"));
  } else if (metric === "Requests/sec") {
    metricLine = lines.find(line => line.trim().startsWith("Requests/sec"));
  }

  if (!metricLine) return null;

  const match = metricLine.match(/([\d.]+)/);
  return match ? parseFloat(match[1]) : null;
}

export function calculateAverage(values: number[]): number {
  if (values.length === 0) return 0;
  const sum = values.reduce((a, b) => a + b, 0);
  return sum / values.length;
}

export function parseServerMetrics(servers: string[], inputs: string[]): Record<string, ServerMetrics> {
  const serverMetrics: Record<string, ServerMetrics> = {};

  servers.forEach((server, idx) => {
    const startIdx = idx * 3;
    const reqSecVals: number[] = [];
    const latencyVals: number[] = [];
    for (let j = 0; j < 3; j++) {
      const inputIdx = startIdx + j;
      if (inputIdx < inputs.length) {
        const reqSec = parseMetric(inputs[inputIdx], "Requests/sec");
        const latency = parseMetric(inputs[inputIdx], "Latency");
        if (reqSec !== null) reqSecVals.push(reqSec);
        if (latency !== null) latencyVals.push(latency);
      }
    }
    serverMetrics[server] = {
      reqSec: calculateAverage(reqSecVals),
      latency: calculateAverage(latencyVals)
    };
  });

  return serverMetrics;
}
