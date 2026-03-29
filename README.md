# 🌐 Iran War News - Mini-Projet S6

Site d'informations sur la guerre en Iran avec FrontOffice et BackOffice.

**📅 Mars 2026 - Projet Web Design**

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.5-brightgreen.svg)](https://spring.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue.svg)](https://postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com/)

## 🚀 Démarrage rapide

### Prérequis
- Docker 20.0+ et Docker Compose 2.0+

### Lancement
```bash
# Cloner le projet
git clone <url-du-repo>
cd mini-projet-s6

# Démarrer avec Docker Compose
chmod +x start.sh
./start.sh

# OU manuellement
docker-compose up --build -d
```

### 🔑 Accès
- **Site web :** http://localhost:8080
- **Admin :** http://localhost:8080/admin
  - Username: `admin`
  - Password: `admin123`

## 📦 Architecture technique

### Stack
- **Frontend :** JSP + Bootstrap 5 + CSS custom
- **Backend :** Spring Boot 3.3.5 + Spring Security
- **Base de données :** PostgreSQL 16
- **Conteneurisation :** Docker + Docker Compose

### Structure
```
Iran War News/
├── src/                    # Code source Spring Boot
│   ├── main/java/          # Classes Java
│   ├── main/resources/     # Configuration + JSP
│   └── main/webapp/        # Vues JSP
├── bd/                     # Scripts SQL
├── docker-compose.yml      # Configuration Docker
├── Dockerfile             # Image application
└── README.md              # Cette documentation
```

## ✅ Fonctionnalités implémentées

### 🎯 FrontOffice
- [x] **Page d'accueil** avec articles à la une
- [x] **Page détail article** avec URL rewriting (`/article/{slug}`)
- [x] **Navigation responsive** avec menu catégories
- [x] **SEO optimisé** (meta tags, structure h1-h6, canonical)
- [x] **Design moderne** avec animations CSS

### 🔧 BackOffice
- [x] **Authentification** Spring Security
- [x] **CRUD Articles** (Créer, Modifier, Supprimer)
- [x] **Dashboard admin** avec statistiques
- [x] **Gestion catégories** complète

### 🔍 SEO & Performance
- [x] **URL rewriting** obligatoire
- [x] **Structure h1-h6** respectée
- [x] **Balises meta** (title, description, keywords)
- [x] **Alt sur images** pour l'accessibilité
- [x] **Pages d'erreur** personnalisées (404, 500)

## 🐳 Déploiement Docker

### Services
| Service | Port | Description |
|---------|------|-------------|
| `app` | 8080 | Application Spring Boot |
| `postgres` | 5433 | Base PostgreSQL |
| `init` | - | Initialisation données |

### Commandes
```bash
# Voir les logs
docker-compose logs -f app

# Redémarrer
docker-compose restart

# Arrêter
./stop.sh
```

## 📊 Base de données

### Entités principales
- `articles` - Contenu editorial
- `categories` - Classification
- `users` - Utilisateurs admin
- `medias` - Fichiers uploadés

### Données de test
- 6 catégories (Politique, Militaire, etc.)
- 1 utilisateur admin
- 1 article de démonstration

## 🔧 Développement local

### Prérequis
- Java 17+
- Maven 3.9+
- PostgreSQL (via Docker)

### Configuration
```bash
# Base de données
docker-compose up postgres -d

# Application
mvn spring-boot:run
```

### Variables d'environnement
| Variable | Valeur par défaut | Description |
|----------|-------------------|-------------|
| `DB_URL` | `jdbc:postgresql://localhost:5433/mini_projet_s6` | URL base |
| `DB_USERNAME` | `postgres` | Utilisateur |
| `DB_PASSWORD` | `postgres` | Mot de passe |
| `SERVER_PORT` | `8080` | Port application |

## 📝 Livrables

### ✅ Complété
1. **Site fonctionnel** en conteneurs Docker ✓
2. **Dépôt GitHub** public ✓
3. **Documentation technique** (ce README) ✓

### 📋 Points de contrôle
- [x] URL rewriting fonctionnel
- [x] Structure HTML correcte
- [x] Balises meta présentes
- [x] Images avec alt
- [x] Test Lighthouse possible
- [x] Docker opérationnel

## 🚨 Dépannage

**Port 8080 occupé :**
```bash
# Modifier dans docker-compose.yml
ports: ["8081:8080"]
```

**Erreur de base :**
```bash
docker-compose restart postgres
```

**Logs détaillés :**
```bash
docker-compose logs postgres app
```

---

**🎓 ETU3367 - Mini-Projet S6 Mars 2026**

Projet réalisé dans le cadre du cours Web Design. Toutes les exigences techniques et fonctionnelles ont été respectées.