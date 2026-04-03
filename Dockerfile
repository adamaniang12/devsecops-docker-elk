FROM php:8.2-apache

RUN useradd -m -u 1000 -s /bin/bash appuser

COPY app/ /var/www/html/

RUN chown -R appuser:www-data /var/www/html && \
    chmod -R 755 /var/www/html

USER appuser

EXPOSE 80
