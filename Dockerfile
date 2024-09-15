# Pulls latest wordpress official image
FROM wordpress:latest

# Create the directory for CA certificates
RUN mkdir -p /usr/local/share/ca-certificates/

# Copy the RDS CA certificate from your local machine into the container
COPY global-bundle.pem /usr/local/share/ca-certificates/global-bundle.pem

# Update CA certificates
RUN update-ca-certificates
