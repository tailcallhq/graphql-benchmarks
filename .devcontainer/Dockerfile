# Start with the Microsoft's Ubuntu 20.04 base image for Codespaces
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-20.04

# Install Go
RUN wget https://dl.google.com/go/go1.17.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz && \
    rm go1.17.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin


# Install OpenJDK-11
RUN apt-get install -y openjdk-11-jdk

# Install Nginx
RUN apt-get install -y nginx

# Set the working directory (if you want to change the default set by Microsoft's base image)
WORKDIR /workspace

# Expose any ports you might need (though keep in mind, external access in Codespaces might be limited)
EXPOSE 8080 8081 8082 8083 3000

# Use the default command provided by Microsoft's base image (no need to add "sleep infinity")
