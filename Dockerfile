FROM sandymadaan/php7.4:0.1

COPY . /var/www/html

RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

RUN sed -ri -e 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

RUN a2enmod rewrite

RUN cp .env.example .env

RUN composer install -on --prefer-dist

RUN chown -R www-data:www-data storage bootstrap
RUN chmod -R 777 storage bootstrap

RUN php artisan key:generate

RUN cp .env.example .env.testing

