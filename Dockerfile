# Dockerfile
FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    supervisor \
    curl

# Set up supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create a non-root user
RUN useradd -m mytestuser

# Set working directory
WORKDIR /home/mytestuser

# Copy script files
COPY report-generator.sh /usr/local/bin/report-generator

# Set file permissions
RUN chmod 755 /usr/local/bin/report-generator

# Download the CSV file
RUN curl -o organizations.csv https://github.com/datablist/sample-csv-files/raw/main/files/organizations/organizations-100.csv

# Switch to the non-root user
USER mytestuser

# Execute supervisord as the entrypoint
ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
