# Documentation Technique - Iran War News

## 📋 Informations du projet

- **Projet :** Iran War News - Site d'informations sur la guerre en Iran
- **Type :** Mini-Projet Web Design S6
- **Date :** Mars 2026
- **ETU :** ETU3367
- **Technologies :** Spring Boot 3.3.5, PostgreSQL 16, Docker

## 🔑 Accès BackOffice

### Identifiants par défaut
- **URL :** http://localhost:8080/admin
- **Username :** `admin`
- **Password :** `admin123`

### Rôles utilisateur
- **admin :** Accès complet (articles, catégories, utilisateurs)
- **editeur :** Gestion des contenus (articles, catégories)
- **lecteur :** Lecture seule

## 📸 Captures d'écran

### FrontOffice

#### Page d'accueil
```
http://localhost:8080/
```
- Articles à la une mis en avant
- Liste chronologique des derniers articles
- Navigation par catégories
- Design responsive avec Bootstrap 5

#### Page détail article
```
http://localhost:8080/article/tensions-croissantes-iran
```
- URL rewriting avec slug
- Meta tags SEO optimisés
- Structure H1/H2 sémantique
- Informations d'article (date, vues, catégorie)
- Contenu HTML enrichi

#### Navigation
- Menu responsive avec dropdown catégories
- Footer avec liens et informations
- Breadcrumb et liens de retour

### BackOffice

#### Tableau de bord admin
```
http://localhost:8080/admin
```
- Statistiques articles et catégories
- Actions rapides (nouvelle article, catégorie)
- Navigation intuitive

#### Gestion des articles
```
http://localhost:8080/admin/articles
```
- Liste complète avec statuts (publié, brouillon, archivé)
- Actions : voir, modifier, supprimer
- Indicateurs visuels (à la une, nombre de vues)

#### Formulaire article
```
http://localhost:8080/admin/articles/new
http://localhost:8080/admin/articles/{id}/edit
```
- Champs complets : titre, slug, contenu, SEO
- Auto-génération du slug depuis le titre
- Compteurs de caractères pour SEO
- Sélection catégorie et statut
- Option "à la une"

#### Gestion des catégories
```
http://localhost:8080/categories
```
- CRUD complet des catégories
- Validation unicité du slug
- Interface similaire aux articles

### Pages d'erreur

#### Erreur 404
```
http://localhost:8080/page-inexistante
```
- Page d'erreur personnalisée
- Messages explicites
- Liens de retour

#### Erreur 403 (Accès refusé)
```
http://localhost:8080/admin (sans authentification)
```
- Page d'accès refusé
- Lien vers la connexion

#### Page de connexion
```
http://localhost:8080/login
```
- Interface sécurisée Spring Security
- Messages d'erreur clairs
- Design cohérent

## 🗃️ Modélisation de la base de données

### Diagramme ERD

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   categories    │    │    articles     │    │      users      │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ id (PK)         │◄──┐│ id (PK)         │┌──►│ id (PK)         │
│ nom             │   ││ titre           ││   │ username        │
│ slug (UNIQUE)   │   ││ slug (UNIQUE)   ││   │ email           │
│ description     │   ││ sous_titre      ││   │ password_hash   │
│ created_at      │   ││ chapeau         ││   │ role            │
│ updated_at      │   ││ contenu         ││   │ actif           │
└─────────────────┘   ││ meta_title      ││   │ created_at      │
                      ││ meta_description││   │ updated_at      │
                      ││ meta_keywords   ││   └─────────────────┘
                      ││ image_une       ││
                      ││ categorie_id(FK)│┘
                      ││ auteur_id (FK)  │────┘
                      ││ statut          │
                      ││ a_la_une        │
                      ││ vues            │
                      ││ date_publication│
                      ││ created_at      │
                      ││ updated_at      │
                      │└─────────────────┘
                      │
┌─────────────────┐   │
│     medias      │   │
├─────────────────┤   │
│ id (PK)         │◄──┘
│ fichier         │
│ alt             │
│ titre           │
│ description     │
│ mime_type       │
│ taille          │
│ uploaded_by (FK)│
│ created_at      │
└─────────────────┘
```

### Entités principales

#### Table `articles`
| Champ | Type | Description |
|-------|------|-------------|
| `id` | SERIAL PK | Identifiant unique |
| `titre` | VARCHAR(255) | Titre principal |
| `slug` | VARCHAR(270) UNIQUE | URL rewriting |
| `sous_titre` | VARCHAR(255) | Sous-titre optionnel |
| `chapeau` | TEXT | Introduction/résumé |
| `contenu` | TEXT | Corps de l'article (HTML) |
| `meta_title` | VARCHAR(70) | SEO - Titre (≤60 car.) |
| `meta_description` | VARCHAR(165) | SEO - Description (≤155 car.) |
| `meta_keywords` | VARCHAR(255) | SEO - Mots-clés |
| `categorie_id` | INTEGER FK | Référence catégorie |
| `auteur_id` | INTEGER FK | Référence utilisateur |
| `statut` | ENUM | brouillon/publie/archive |
| `a_la_une` | BOOLEAN | Mise en avant |
| `vues` | INTEGER | Compteur de vues |
| `date_publication` | TIMESTAMPTZ | Date de publication |

#### Table `categories`
| Champ | Type | Description |
|-------|------|-------------|
| `id` | SERIAL PK | Identifiant unique |
| `nom` | VARCHAR(100) | Nom de la catégorie |
| `slug` | VARCHAR(110) UNIQUE | URL rewriting |
| `description` | TEXT | Description |

#### Table `users`
| Champ | Type | Description |
|-------|------|-------------|
| `id` | SERIAL PK | Identifiant unique |
| `username` | VARCHAR(60) UNIQUE | Nom d'utilisateur |
| `email` | VARCHAR(150) UNIQUE | Email |
| `password_hash` | VARCHAR(255) | Hash bcrypt |
| `role` | ENUM | admin/editeur/lecteur |
| `actif` | BOOLEAN | Compte actif |

### Types ENUM
- `user_role` : admin, editeur, lecteur
- `article_statut` : brouillon, publie, archive

### Index de performance
- `idx_articles_statut` sur `articles(statut)`
- `idx_articles_categorie` sur `articles(categorie_id)`
- `idx_articles_date` sur `articles(date_publication DESC)`
- `idx_articles_publies` (partiel) pour le front-office

### Données initiales

#### Catégories
1. Politique - `politique`
2. Militaire - `militaire`
3. Humanitaire - `humanitaire`
4. Diplomatie - `diplomatie`
5. Économie - `economie`
6. Médias - `medias`

#### Utilisateur admin
- Username: `admin`
- Email: `admin@iranwar-news.local`
- Role: `admin`
- Mot de passe: `admin123` (hash BCrypt)

## 🛠️ Architecture technique

### Stack technologique
- **Backend :** Spring Boot 3.3.5, Spring Security, Spring Data JPA
- **Frontend :** JSP, JSTL, Bootstrap 5.3.3, CSS personnalisé
- **Base de données :** PostgreSQL 16 avec encodage UTF-8
- **Containérisation :** Docker, Docker Compose

### Configuration Spring Security
- Authentification form-based
- Protection des routes `/admin/*` et `/categories/*`
- Rôles : ROLE_ADMIN, ROLE_EDITEUR, ROLE_LECTEUR
- BCryptPasswordEncoder pour les mots de passe

### SEO et performances
- URL rewriting automatique via slug
- Meta tags dynamiques (title, description, keywords)
- Structure HTML sémantique (h1, h2, h3...)
- Pages d'erreur personnalisées
- CSS et JS optimisés

### Internationalisation
- Interface en français
- Encodage UTF-8 complet
- Messages d'erreur localisés

## 🐳 Déploiement Docker

### Services
- **app :** Application Spring Boot (port 8080)
- **postgres :** Base PostgreSQL (port 5433→5432)
- **init :** Initialisation données et hash admin

### Volumes
- `postgres_data` : Persistance base de données
- `app_logs` : Logs applicatifs

### Variables d'environnement
```yaml
DB_URL: jdbc:postgresql://postgres:5432/mini_projet_s6
DB_USERNAME: postgres
DB_PASSWORD: postgres
SPRING_PROFILES_ACTIVE: docker
```

## 📊 Tests et validation

### Tests fonctionnels
- [x] Affichage page d'accueil
- [x] Navigation entre pages
- [x] URL rewriting fonctionnel
- [x] Authentification admin
- [x] CRUD articles complet
- [x] CRUD catégories complet

### Tests SEO
- [x] Meta tags présents et dynamiques
- [x] Structure H1-H6 correcte
- [x] Balises alt sur images
- [x] URLs canoniques
- [x] Compatible test Lighthouse

### Tests techniques
- [x] Docker Compose opérationnel
- [x] Base de données initialisée
- [x] Authentification sécurisée
- [x] Pages d'erreur personnalisées

## 🚀 Performance

### Optimisations
- Index de base optimisés
- Requêtes JPA efficaces
- CSS/JS minifiés par Bootstrap
- Images optimisées
- Cache Hibernate

### Monitoring
- Logs applicatifs dans `/app/logs/`
- Health check Docker intégré
- Métriques Spring Boot Actuator (si activé)

## 📝 Livrables finaux

### ✅ Fichiers livrés
1. **Source complet** dans archive ZIP
2. **Docker Compose** fonctionnel
3. **Documentation technique** (ce fichier)
4. **README.md** avec instructions
5. **Accès BackOffice** configuré

### ✅ Critères respectés
- [x] URL rewriting obligatoire
- [x] Structure HTML h1-h6
- [x] Balises meta et title
- [x] Alt sur images
- [x] Test Lighthouse possible
- [x] Conteneurs Docker
- [x] Repository public

---

**📬 Contact :** ETU3367 - Mini-Projet S6 Mars 2026