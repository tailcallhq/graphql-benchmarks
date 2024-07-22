# Start with the Microsoft's Ubuntu 22.04 base image for Codespaces
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Install necessary packages and tools
RUN apt-get update && apt-get install -y \
  build-essential \
  libssl-dev \
  pkg-config \
  nginx \
  openjdk-17-jdk \
  git \
  curl \
  wget \
  wrk \
  gnuplot \
  postgresql \
  postgresql-client \
  python3 \
  && rm -rf /var/lib/apt/lists/*

# Install docker engine in linux
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
  sudo sh get-docker.sh

# Install the latest LTS version of Node.js
RUN curl -L https://deb.nodesource.com/nsolid_setup_deb.sh | bash -s -- 18 && \
  apt-get install -y nodejs

# Install Go
RUN wget https://dl.google.com/go/go1.21.1.linux-amd64.tar.gz -O- | tar xz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin

# Nginx configurations
RUN mkdir -p /var/cache/nginx-cache \
  /var/lib/nginx/body \
  /var/lib/nginx/proxy \
  /var/lib/nginx/fastcgi \
  /var/lib/nginx/uwsgi \
  /var/lib/nginx/scgi \
  /var/log/nginx \
  && touch /var/log/nginx/access.log /var/log/nginx/error.log \
  && chown -R www-data:www-data /var/cache/nginx-cache /var/log/nginx /var/lib/nginx

# Set the working directory
WORKDIR /workspace

# Expose necessary ports
EXPOSE 8000 3000
