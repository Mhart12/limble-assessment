FROM wordpress:latest

## Install dependencies and PHP Memcached extension
#RUN apt-get update && \
#    apt-get install -y \
#    libmemcached-dev \
#    zlib1g-dev \
#    libssl-dev \
#    pkg-config \
#    && if ! pecl list | grep -q 'memcached'; then \
#         pecl install memcached; \
#         docker-php-ext-enable memcached; \
#       fi
#
## Install Session Manager Plugin
#RUN apt-get update && \
#    apt-get install -y \
#    curl \
#    unzip \
#    && curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" \
#    && dpkg -i session-manager-plugin.deb

# Create the directory for CA certificates
RUN mkdir -p /usr/local/share/ca-certificates/

# Copy the RDS CA certificate from your local machine into the container
COPY global-bundle.pem /usr/local/share/ca-certificates/global-bundle.pem

# Update CA certificates
RUN update-ca-certificates

##Copy the updated wp-config.php to the container
#COPY configs/wp-config.php /opt/bitnami/wordpress/wp-config.php
#
##Set the correct permissions and ownership
#RUN chown daemon:root /opt/bitnami/wordpress/wp-config.php && \
#    chmod 664 /opt/bitnami/wordpress/wp-config.php

# Set environment variables
#ENV DB_SSL=true
#ENV DB_SSL_CA=/usr/local/share/ca-certificates/global-bundle.pem
#ENV WP_DEBUG=true
#ENV WP_DEBUG_LOG=true
#ENV WP_DEBUG_DISPLAY=false

# Copy and run the script to configure WordPress
#COPY scripts/update-wp-config.sh /usr/local/bin/update-wp-config.sh
#RUN chmod +x /usr/local/bin/update-wp-config.sh

#NTRYPOINT [ "/usr/local/bin/update-wp-config.sh" ]
# Set the entry point
#ENTRYPOINT [ "/opt/bitnami/scripts/wordpress/entrypoint.sh" ]

# Override the CMD to include your custom setup
#CMD [ "/usr/local/bin/update-wp-config.sh", "/opt/bitnami/scripts/apache/run.sh" ]

#ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/update-wp-config.sh && /opt/bitnami/scripts/apache/run.sh"]

# Keep the container running by overriding the entry point
# ENTRYPOINT ["/bin/sh", "-c", "while :; do sleep 1; done"]