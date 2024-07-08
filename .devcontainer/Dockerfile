# Start with the Microsoft's Ubuntu 22.04 base image for Codespaces
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Install necessary packages and tools
RUN apt-get update && apt-get install -y \
  build-essential \
  libssl-dev \
  pkg-config \
  openjdk-17-jdk \
  git \
  curl \
  wget \
  wrk \
  gnuplot \
  postgresql \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Install the latest LTS version of Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
  apt-get install -y nodejs

# Install Go
RUN wget https://dl.google.com/go/go1.21.1.linux-amd64.tar.gz -O- | tar xz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin

# Install Nginx with echo module
RUN wget http://nginx.org/download/nginx-1.11.2.tar.gz && \
  tar -xzvf nginx-1.11.2.tar.gz && \
  git clone https://github.com/openresty/echo-nginx-module.git && \
  cd nginx-1.11.2 && \
  ./configure --prefix=/opt/nginx --add-module=../echo-nginx-module && \
  make -j2 && \
  make install

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
