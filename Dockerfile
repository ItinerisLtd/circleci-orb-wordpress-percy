###############################################################################################
# GitHub: https://github.com/ItinerisLtd/circleci-orbs-wordpress-percy/blob/master/Dockerfile #
###############################################################################################

ARG PHP_VERSION=7.3

FROM circleci/php:${PHP_VERSION}-node-browsers

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /home/circleci

### MySQL
RUN sudo apt-get -q update && \
    sudo apt-get install -q -y --no-install-recommends mariadb-client && \
    sudo apt-get clean && sudo apt-get -y autoremove && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

### WP CLI
RUN \
    # Download
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.asc && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/wp-cli.pgp && \
    # Verify PGP signature
    gpg --dearmor wp-cli.pgp && \
    gpg --lock-never --no-default-keyring --keyring ./wp-cli.pgp.gpg --verify wp-cli.phar.asc wp-cli.phar && \
    # Install
    sudo chmod +x wp-cli.phar && \
    sudo mv wp-cli.phar /usr/local/bin/wp && \
    rm wp-cli.*

### PHP extensions
RUN sudo docker-php-ext-install mysqli

### Basic smoke test
RUN echo 'node --version' && node --version && \
    echo 'npm --version' && npm --version && \
    echo 'npx --version' && npx --version && \
    echo 'yarn versions' && yarn versions && \
    echo 'php --version' && php --version && \
    echo 'wp --info' && wp --info && \
    echo 'mysql --help' && mysql --help

# Define default command.
CMD ["bash"]
