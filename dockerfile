FROM php:8.2-fpm-alpine

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache \
      nginx \
      supervisor

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions \
    @composer

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/index.html /var/www/html/index.html
#COPY docker/nginx.conf /etc/nginx/nginx.conf

#RUN addgroup -S appgroup && adduser -S appuser -G appgroup
#RUN chown -R appuser:appgroup /etc/nginx /etc/supervisor/conf.d /var/www/html
#USER appuser

EXPOSE 80
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

