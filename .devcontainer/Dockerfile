# Start with the Microsoft's Ubuntu 20.04 base image for Codespaces
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Install Go
RUN wget https://dl.google.com/go/go1.17.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz && \
    rm go1.17.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Install OpenJDK-11
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Install OpenJDK-11
RUN apt-get install -y openjdk-11-jdk

# Install Nginx
RUN apt-get install -y nginx

# After installing Nginx
RUN mkdir -p /var/cache/nginx-cache && \
    touch /var/log/nginx/error.log && \
    chown -R www-data:www-data /var/cache/nginx-cache /var/log/nginx

# After the previous Nginx modifications
RUN mkdir -p /var/lib/nginx/body && \
    chown -R www-data:www-data /var/lib/nginx/body

# After the installation of Nginx and previous modifications
RUN mkdir -p /var/log/nginx /var/lib/nginx/body /var/lib/nginx/proxy /var/cache/nginx-cache && \
    chown -R www-data:www-data /var/log/nginx /var/lib/nginx/body /var/lib/nginx/proxy /var/cache/nginx-cache

# After the installation of Nginx and previous modifications
RUN mkdir -p /var/log/nginx /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx/fastcgi /var/cache/nginx-cache && \
    chown -R www-data:www-data /var/log/nginx /var/lib/nginx /var/cache/nginx-cache
# After the installation of Nginx and previous modifications
RUN mkdir -p /var/log/nginx /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx/fastcgi /var/cache/nginx-cache /var/lib/nginx/uwsgi && \
    chown -R www-data:www-data /var/log/nginx /var/lib/nginx /var/cache/nginx-cache
# After the installation of Nginx and previous modifications
RUN mkdir -p /var/log/nginx /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx/fastcgi /var/cache/nginx-cache /var/lib/nginx/uwsgi /var/lib/nginx/scgi && \
    chown -R www-data:www-data /var/log/nginx /var/lib/nginx /var/cache/nginx-cache

# After the installation of Nginx and previous modifications
RUN touch /var/log/nginx/access.log /var/log/nginx/error.log && \
    chown www-data:www-data /var/log/nginx/access.log /var/log/nginx/error.log

# Set the working directory (if you want to change the default set by Microsoft's base image)
WORKDIR /workspace

# Expose any ports you might need (though keep in mind, external access in Codespaces might be limited)
EXPOSE 8080 8081 8082 8083 3000

# Use the default command provided by Microsoft's base image (no need to add "sleep infinity")
