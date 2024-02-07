#!/bin/bash
cd graphql/async_graphql
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
~/.cargo/bin/cargo build --release
