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
  const requestCount = data.metrics.http_reqs.values.count;
  const avgLatency = Math.round(data.metrics.http_req_duration.values.avg * 100) / 100;
  const requestCountMessage = `Requests/sec: ${requestCount}\n`;
  const latencyMessage = `Latency: ${avgLatency} ms\n`;

  return {
    stdout: requestCountMessage + latencyMessage,
  };
}
