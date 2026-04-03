# Utilisation de l'image minimale demandée (Critère 1)
FROM php:8.2-alpine

# Création d'un utilisateur non-root pour la sécurité (Critère 2)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /var/www/html

# On copie le contenu du dossier app dans le conteneur
COPY ./app /var/www/html/

# On active l'utilisateur non-root
USER appuser

EXPOSE 80