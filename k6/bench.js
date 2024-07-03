import http from 'k6/http';
import { check } from 'k6';

const whichBenchmark = Number(__ENV.BENCHMARK);

export const options = {
  scenarios: {
    posts: {
      executor: 'constant-vus',
      duration: whichBenchmark === 2 ? '30s' : '10s',
      gracefulStop: '0s',
      vus: 100,
    }
  },
  cloud: {
    name: __ENV.TEST_NAME + '-' + whichBenchmark,
  },
};

const url = 'http://localhost:8000/graphql';
const params = {
  headers: {
    'Connection': 'keep-alive',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
    'Content-Type': 'application/json',
  },
};

export default function() {
  const payload = JSON.stringify({
    operationName: null,
    variables: {},
    query: whichBenchmark === 2 ? '{posts{id,userId,title,user{id,name,email}}}' : '{posts{title}}',
  });

  const res = http.post(url, payload, params);
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
}

export function handleSummary(data) {
  const med_request_count = data.metrics.http_reqs.values.count;
  const avg_latency = data.metrics.http_req_duration.values.avg;
  const trimmed_avg_latency = Math.round(avg_latency * 100) / 100;
  const request_count_message = `Requests/sec: ${med_request_count}\n`;
  const latency_message = `Latency: ${trimmed_avg_latency} ms\n`;

  return {
    stdout: request_count_message + latency_message,
  };
}
