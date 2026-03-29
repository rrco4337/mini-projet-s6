# Guide de Déploiement - Iran War News

## 🚀 Déploiement automatisé (Recommandé)

### Prérequis
- Docker 20.0+
- Docker Compose 2.0+
- 2 Go RAM libre
- Ports 8080 et 5433 libres

### Installation en une commande

```bash
# 1. Cloner le projet
git clone <URL_DU_REPO>
cd mini-projet-s6

# 2. Démarrer l'application
chmod +x start.sh
./start.sh
```

**C'est tout !** L'application sera disponible sur http://localhost:8080

### Vérification
```bash
# Vérifier que tous les services sont en marche
docker-compose ps

# Doit afficher :
# mini-projet-s6-postgres   Up      5432/tcp, 0.0.0.0:5433->5432/tcp
# mini-projet-s6-app        Up      0.0.0.0:8080->8080/tcp
```

## 🔧 Déploiement manuel

### Étape 1 : Lancement de la base de données

```bash
# Démarrer PostgreSQL seul
docker-compose up postgres -d

# Attendre que la base soit prête (10-15 secondes)
docker-compose logs postgres
```

### Étape 2 : Initialisation de la base

```bash
# Exécuter les scripts d'initialisation
docker exec -i mini-projet-s6-postgres psql -U postgres -d mini_projet_s6 < bd/base.sql

# Créer le hash admin
docker exec -i mini-projet-s6-postgres psql -U postgres -d mini_projet_s6 << 'EOF'
UPDATE users SET password_hash = '$2a$10$cZjDNEqOn3IO2Ua8edEg9eVYyPf0ZR0nEw1TCYJ0s38C20xftPf0O'
WHERE username = 'admin';
EOF
```

### Étape 3 : Compilation et lancement de l'application

```bash
# Construction de l'image
docker-compose build app

# Démarrage de l'application
docker-compose up app -d
```

## 🛠️ Déploiement en mode développement

### Prérequis
- Java 17+
- Maven 3.9+
- PostgreSQL (via Docker)

### Configuration

```bash
# 1. Base de données
docker-compose up postgres -d
docker exec -i mini-projet-s6-postgres psql -U postgres -d mini_projet_s6 < bd/base.sql

# 2. Configuration du hash admin
docker exec -i mini-projet-s6-postgres psql -U postgres -d mini_projet_s6 << 'EOF'
UPDATE users SET password_hash = '$2a$10$cZjDNEqOn3IO2Ua8edEg9eVYyPf0ZR0nEw1TCYJ0s38C20xftPf0O'
WHERE username = 'admin';
EOF

# 3. Lancement Spring Boot
mvn spring-boot:run
```

## 📊 Variables d'environnement

### Configuration par défaut
```bash
DB_URL=jdbc:postgresql://localhost:5433/mini_projet_s6
DB_USERNAME=postgres
DB_PASSWORD=postgres
SERVER_PORT=8080
SPRING_PROFILES_ACTIVE=default
```

### Configuration Docker
```bash
DB_URL=jdbc:postgresql://postgres:5432/mini_projet_s6
DB_USERNAME=postgres
DB_PASSWORD=postgres
SERVER_PORT=8080
SPRING_PROFILES_ACTIVE=docker
```

### Personnalisation
```bash
# Créer un fichier .env (optionnel)
cat > .env << 'EOF'
DB_USERNAME=myuser
DB_PASSWORD=mypassword
SERVER_PORT=9000
EOF

# Modifier docker-compose.yml pour utiliser le .env
```

## 🔍 Vérifications post-déploiement

### Tests de base
```bash
# 1. Santé de l'application
curl -f http://localhost:8080/ || echo "❌ App non accessible"

# 2. Base de données
docker exec mini-projet-s6-postgres psql -U postgres -d mini_projet_s6 -c "SELECT count(*) FROM articles;" || echo "❌ DB non accessible"

# 3. Connexion admin
curl -f http://localhost:8080/admin || echo "✅ Redirection vers login"

# 4. Logs
docker-compose logs app | grep "Started MiniProjetS6Application" || echo "❌ App non démarrée"
```

### Tests fonctionnels
1. **Page d'accueil** : http://localhost:8080
2. **Article de test** : http://localhost:8080/article/tensions-geopolitiques-iran-2026
3. **Connexion admin** : http://localhost:8080/login (admin/admin123)
4. **Dashboard admin** : http://localhost:8080/admin
5. **Gestion articles** : http://localhost:8080/admin/articles

## 🛑 Arrêt et nettoyage

### Arrêt simple
```bash
# Arrêter les services
docker-compose down

# OU utiliser le script
./stop.sh
```

### Nettoyage complet
```bash
# Arrêter et supprimer les volumes (données perdues !)
docker-compose down -v

# Nettoyage des images
docker image prune -f
```

### Redémarrage
```bash
# Redémarrer sans reconstruction
docker-compose restart

# Redémarrer avec reconstruction
docker-compose up --build -d
```

## 🚨 Dépannage

### Port 8080 occupé
```bash
# Option 1 : Changer le port
export SERVER_PORT=9000
docker-compose up -d

# Option 2 : Modifier docker-compose.yml
ports: ["9000:8080"]
```

### Port 5433 occupé
```bash
# Modifier le port PostgreSQL
ports: ["5434:5432"]

# Adapter DB_URL
export DB_URL="jdbc:postgresql://localhost:5434/mini_projet_s6"
```

### Problème de base de données
```bash
# Recréer la base
docker-compose down -v
docker-compose up postgres -d
sleep 10
docker exec -i mini-projet-s6-postgres psql -U postgres -d mini_projet_s6 < bd/base.sql
```

### Problème d'authentification
```bash
# Régénérer le hash admin
docker exec -i mini-projet-s6-postgres psql -U postgres -d mini_projet_s6 << 'EOF'
UPDATE users SET password_hash = '$2a$10$cZjDNEqOn3IO2Ua8edEg9eVYyPf0ZR0nEw1TCYJ0s38C20xftPf0O'
WHERE username = 'admin';
EOF
```

### Logs de débogage
```bash
# Logs en temps réel
docker-compose logs -f app

# Logs spécifiques
docker-compose logs postgres
docker-compose logs app

# Accès shell conteneur
docker exec -it mini-projet-s6-app sh
docker exec -it mini-projet-s6-postgres psql -U postgres -d mini_projet_s6
```

## 🌐 Déploiement production

### Configuration production
1. **Changer les mots de passe par défaut**
2. **Configurer HTTPS** (reverse proxy nginx/Apache)
3. **Sauvegardes** automatiques base de données
4. **Monitoring** (logs, métriques)
5. **Limits** ressources Docker

### Exemple nginx (reverse proxy)
```nginx
server {
    listen 80;
    server_name iranwar-news.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Sauvegarde base de données
```bash
# Dump automatique
docker exec mini-projet-s6-postgres pg_dump -U postgres mini_projet_s6 > backup_$(date +%Y%m%d).sql

# Restauration
docker exec -i mini-projet-s6-postgres psql -U postgres -d mini_projet_s6 < backup_20260329.sql
```

## ✅ Checklist de déploiement

### Avant déploiement
- [ ] Docker et Docker Compose installés
- [ ] Ports 8080 et 5433 libres
- [ ] 2 Go RAM disponibles
- [ ] Dépôt Git cloné

### Après déploiement
- [ ] Services démarrés (`docker-compose ps`)
- [ ] Page d'accueil accessible (http://localhost:8080)
- [ ] Connexion admin fonctionnelle (admin/admin123)
- [ ] Article de test visible
- [ ] URL rewriting fonctionnel

### Tests de validation
- [ ] Test Lighthouse possible
- [ ] Pages d'erreur (404, 403) stylées
- [ ] Navigation responsive
- [ ] SEO meta tags présents

---

**🚀 Déploiement Iran War News - ETU3367 Mars 2026**