#!/bin/bash

# Script de démarrage pour Iran War News
echo "======================================"
echo "  🚀 Iran War News - Démarrage"
echo "======================================"

# Vérification de Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé"
    exit 1
fi

echo "📦 Arrêt et nettoyage des conteneurs existants..."
docker-compose down

echo "🔧 Construction des images..."
docker-compose build --no-cache

echo "🚀 Démarrage des services..."
docker-compose up -d

echo "⏳ Attente du démarrage des services..."
sleep 10

# Vérification des services
APP_STATUS=$(docker-compose ps -q app | xargs docker inspect -f '{{.State.Status}}' 2>/dev/null)
POSTGRES_STATUS=$(docker-compose ps -q postgres | xargs docker inspect -f '{{.State.Status}}' 2>/dev/null)

if [ "$APP_STATUS" = "running" ] && [ "$POSTGRES_STATUS" = "running" ]; then
    echo "✅ Tous les services sont démarrés"
    echo ""
    echo "🌐 Application disponible sur : http://localhost:8080"
    echo "📊 Base de données sur : localhost:5433"
    echo ""
    echo "🔑 Identifiants admin :"
    echo "   Username: admin"
    echo "   Password: admin123"
    echo ""
    echo "📋 Commandes utiles :"
    echo "   - Voir les logs : docker-compose logs -f"
    echo "   - Arrêter : docker-compose down"
    echo "   - Redémarrer : docker-compose restart"
else
    echo "❌ Erreur lors du démarrage"
    docker-compose logs
fi