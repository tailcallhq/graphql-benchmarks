curl -sSL https://raw.githubusercontent.com/tailcallhq/tailcall/main/install.sh | bash -s -- v0.9.0
export PATH=$PATH:~/.tailcall/bin
tc start benchmark.graphql