FROM php:7.1-cli-jessie
LABEL maintainer="digitalpulp"

COPY .pre-commit-config.yaml /root/pre-commit/.pre-commit-config.yaml
COPY  nodesource.sh /usr/local/bin/
COPY pre-commit.sh /usr/local/bin/

RUN chmod ugo=rx /usr/local/bin/pre-commit.sh \
   && bash nodesource.sh \
   && apt-get install -y nodejs build-essential \
   && apt-get install -y bash bash-doc bash-completion \
   && apt-get install -y git zip \
   && apt-get install -y python python-pip python-virtualenv ca-certificates \
   && apt-get -y clean \
   && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
   && php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
   && php composer-setup.php \
   && php -r "unlink('composer-setup.php');" \
   && mv composer.phar /usr/local/bin/composer \
   && composer global require drupal/coder \
   && ln -s /root/.composer/vendor/squizlabs/php_codesniffer/bin/phpcs /usr/local/bin/phpcs \
   && ln -s /root/.composer/vendor/squizlabs/php_codesniffer/bin/phpcbf /usr/local/bin/phpcbf \
   && pip install --upgrade pip setuptools \
   && pip install pre-commit \
   && cd /root/pre-commit \
   && git init \
   && pre-commit install-hooks


CMD ["tail", "-f", "/dev/null"]
