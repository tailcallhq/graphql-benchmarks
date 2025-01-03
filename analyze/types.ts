export interface ServerMetrics {
  reqSec: number;
  latency: number;
}

export interface FormattedServerNames {
  [key: string]: string;
}
