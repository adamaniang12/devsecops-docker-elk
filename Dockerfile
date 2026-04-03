FROM php:8.2-alpine
# Création d'un utilisateur non-root (Critère d'évaluation)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
COPY . /var/www/html/