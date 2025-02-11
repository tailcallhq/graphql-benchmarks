use wasm_bindgen::prelude::*;
use serde::{Serialize, Deserialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize)]
pub struct ServerMetrics {
    req_sec: f64,
    latency: f64,
}

#[wasm_bindgen]
pub fn parse_server_metrics(servers: Vec<String>, result_contents: Vec<String>) -> JsValue {
    let server_metrics = calculate_server_metrics(&servers, &result_contents);
    serde_wasm_bindgen::to_value(&server_metrics).unwrap()
}

fn calculate_server_metrics(servers: &[String], result_contents: &[String]) -> HashMap<String, ServerMetrics> {
    let mut server_metrics = HashMap::new();

    for (idx, server) in servers.iter().enumerate() {
        let start_idx = idx * 3;
        let mut req_sec_vals = Vec::new();
        let mut latency_vals = Vec::new();

        for j in 0..3 {
            let input_idx = start_idx + j;
            if input_idx < result_contents.len() {
                if let Some(req_sec) = parse_metric(&result_contents[input_idx], "Requests/sec") {
                    req_sec_vals.push(req_sec);
                }
                if let Some(latency) = parse_metric(&result_contents[input_idx], "Latency") {
                    latency_vals.push(latency);
                }
            }
        }

        server_metrics.insert(server.clone(), ServerMetrics {
            req_sec: calculate_average(&req_sec_vals),
            latency: calculate_average(&latency_vals),
        });
    }

    server_metrics
}

fn parse_metric(input: &str, metric: &str) -> Option<f64> {
    let lines: Vec<&str> = input.lines().collect();
    let metric_line = lines.iter().find(|line| line.trim().starts_with(metric))?;
    
    let parts: Vec<&str> = metric_line.split_whitespace().collect();
    match metric {
        "Latency" => {
            // Assume format: "Latency    13.08ms    5.37ms 153.52ms   88.69%"
            parts.get(1).and_then(|val| val.trim_end_matches("ms").parse::<f64>().ok())
        },
        "Requests/sec" => {
            // Assume format: "Requests/sec:   7746.27"
            parts.get(1).and_then(|val| val.parse::<f64>().ok())
        },
        _ => None,
    }
}

fn calculate_average(values: &[f64]) -> f64 {
    if values.is_empty() {
        0.0
    } else {
        values.iter().sum::<f64>() / values.len() as f64
    }
}
