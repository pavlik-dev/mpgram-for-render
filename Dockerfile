FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y --no-install-recommends install php php-fpm php-mbstring php-gd php-gmp php8.3-common nginx curl supervisor && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY /docker/mpgram_web/php.ini /etc/php/8.3/cli
COPY /docker/mpgram_web/php.ini /etc/php/8.3/fpm
COPY /docker/nginx/conf/nginx.conf /etc/nginx/
COPY /docker/nginx/conf/http.conf /etc/nginx/conf.d/default.conf
COPY /docker/nginx/conf/upstream.conf /etc/nginx/conf.d/

RUN curl -o /usr/local/etc/browscap.ini http://browscap.org/stream?q=Lite_PHP_BrowsCapINI

COPY . /var/www/mpgram

RUN cp /var/www/mpgram/config.php.example /var/www/mpgram/config.php
RUN cp /var/www/mpgram/api_values.php.example /var/www/mpgram/api_values.php
RUN chmod 777 /var/www/mpgram

COPY /docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

STOPSIGNAL SIGQUIT
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 80 443 9000

VOLUME /var/log/nginx
VOLUME /var/log/php
VOLUME /var/www/mpgram
