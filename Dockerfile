FROM php:7.2.17-cli-stretch
LABEL maintainer="digitalpulp"

COPY .pre-commit-config.yaml /root/pre-commit/.pre-commit-config.yaml
COPY  nodesource.sh /usr/local/bin/
COPY pre-commit.sh /usr/local/bin/

RUN chmod ugo=rx /usr/local/bin/pre-commit.sh \
   && apt-get update \
   && bash nodesource.sh \
   && apt-get install -y nodejs build-essential \
   && apt-get install -y bash bash-doc bash-completion \
   && apt-get install -y git zip \
   && apt-get upgrade -y python python-pip  \
   && apt-get install -y python3-virtualenv  \
   && apt-get -y clean \
   && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
   && php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
   && php composer-setup.php \
   && php -r "unlink('composer-setup.php');" \
   && mv composer.phar /usr/local/bin/composer \
   && composer global require drupal/coder \
   && ln -s /root/.composer/vendor/squizlabs/php_codesniffer/bin/phpcs /usr/local/bin/phpcs \
   && ln -s /root/.composer/vendor/squizlabs/php_codesniffer/bin/phpcbf /usr/local/bin/phpcbf \
   && pip install pre-commit \
   && cd /root/pre-commit \
   && git init \
   && pre-commit install-hooks


CMD ["tail", "-f", "/dev/null"]
