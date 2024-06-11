FROM ubuntu:latest

RUN apt-get update
RUN apt-get install software-properties-common cron -y
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get -y --no-install-recommends install php php-fpm php-mbstring php-gd php-gmp php8.3-common nginx curl supervisor && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
RUN pecl install uv-beta
RUN echo extension=uv.so | tee $(php --ini | sed '/additional .ini/!d;s/.*: //g')/uv.ini
RUN echo ffi.enable=1 | tee $(php --ini | sed '/additional .ini/!d;s/.*: //g')/ffi.ini
RUN echo vm.max_map_count=262144 | tee /etc/sysctl.d/40-madelineproto.conf
RUN cd /tmp
RUN git clone https://github.com/danog/PrimeModule-ext
RUN cd PrimeModule-ext && make -j$(nproc) && make install
RUN cd /root
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY /docker/mpgram_web/php.ini /etc/php/8.3/cli
COPY /docker/mpgram_web/php.ini /etc/php/8.3/fpm
COPY /docker/nginx/conf/nginx.conf /etc/nginx/
COPY /docker/nginx/conf/http.conf /etc/nginx/conf.d/default.conf
COPY /docker/nginx/conf/upstream.conf /etc/nginx/conf.d/

RUN curl -o /usr/local/etc/browscap.ini http://browscap.org/stream?q=Lite_PHP_BrowsCapINI

COPY . /var/www/mpgram

WORKDIR /var/www/mpgram
RUN composer install

RUN cp /var/www/mpgram/config.php.example /var/www/mpgram/config.php
RUN cp /var/www/mpgram/api_values.php.example /var/www/mpgram/api_values.php
RUN chmod -R 777 /var/www/mpgram

COPY /docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/log/cron
RUN echo -e "#!/bin/bash\n/usr/sbin/php-fpm8.3 -t && kill -USR2 1" > /usr/local/bin/restart-php-fpm.sh && chmod +x /usr/local/bin/restart-php-fpm.sh
RUN echo "0 * * * * root /usr/local/bin/restart-php-fpm.sh" > /etc/cron.d/php-fpm-restart && chmod 0644 /etc/cron.d/php-fpm-restart
RUN echo "[program:cron]" > /etc/supervisor/conf.d/cron.conf && echo "command=cron -f" >> /etc/supervisor/conf.d/cron.conf

STOPSIGNAL SIGQUIT
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 80 443 9000

VOLUME /var/log/nginx
VOLUME /var/log/php
VOLUME /var/www/mpgram
