-- ============================================================
--  Mini-Projet Web Design 2026 - Site d'informations sur la guerre en Iran
--  Base de données MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS iran_war_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE iran_war_db;

-- ============================================================
-- TABLE : categories
-- Catégories des articles (Politique, Militaire, Humanitaire, etc.)
-- ============================================================
CREATE TABLE categories (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nom         VARCHAR(100)  NOT NULL,
  slug        VARCHAR(110)  NOT NULL UNIQUE,   -- URL rewriting
  description TEXT,
  created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE : tags
-- Mots-clés associés aux articles (SEO)
-- ============================================================
CREATE TABLE tags (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nom        VARCHAR(80)  NOT NULL,
  slug       VARCHAR(90)  NOT NULL UNIQUE,
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE : users  (BackOffice)
-- Administrateurs et rédacteurs du backoffice
-- ============================================================
CREATE TABLE users (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(60)  NOT NULL UNIQUE,
  email         VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,          -- bcrypt
  role          ENUM('admin','editeur','lecteur') NOT NULL DEFAULT 'editeur',
  actif         TINYINT(1)   NOT NULL DEFAULT 1,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE : medias
-- Images et fichiers (alt obligatoire pour SEO)
-- ============================================================
CREATE TABLE medias (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fichier     VARCHAR(255) NOT NULL,            -- chemin relatif
  alt         VARCHAR(200) NOT NULL,            -- balise alt (SEO)
  titre       VARCHAR(200),
  description TEXT,
  mime_type   VARCHAR(60),
  taille      INT UNSIGNED,                     -- octets
  uploaded_by INT UNSIGNED,
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_media_user FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- TABLE : articles
-- Contenu principal du site (FrontOffice)
-- ============================================================
CREATE TABLE articles (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  titre           VARCHAR(255) NOT NULL,               -- balise <title> et <h1>
  slug            VARCHAR(270) NOT NULL UNIQUE,         -- URL rewriting
  sous_titre      VARCHAR(255),                         -- <h2>
  chapeau         TEXT,                                 -- intro visible en liste
  contenu         LONGTEXT     NOT NULL,                -- corps de l'article (HTML)
  meta_title      VARCHAR(70),                          -- <title> SEO (≤ 60 car.)
  meta_description VARCHAR(165),                        -- <meta name="description"> (≤ 155 car.)
  meta_keywords   VARCHAR(255),                         -- <meta name="keywords">
  image_une       INT UNSIGNED,                         -- media principal
  categorie_id    INT UNSIGNED,
  auteur_id       INT UNSIGNED,
  statut          ENUM('brouillon','publie','archive') NOT NULL DEFAULT 'brouillon',
  a_la_une        TINYINT(1)   NOT NULL DEFAULT 0,      -- mise en avant FO
  vues            INT UNSIGNED NOT NULL DEFAULT 0,
  date_publication DATETIME,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_article_media    FOREIGN KEY (image_une)    REFERENCES medias(id)     ON DELETE SET NULL,
  CONSTRAINT fk_article_categorie FOREIGN KEY (categorie_id) REFERENCES categories(id) ON DELETE SET NULL,
  CONSTRAINT fk_article_auteur   FOREIGN KEY (auteur_id)    REFERENCES users(id)      ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- TABLE PIVOT : article_tag
-- Relation N-N articles <-> tags
-- ============================================================
CREATE TABLE article_tag (
  article_id INT UNSIGNED NOT NULL,
  tag_id     INT UNSIGNED NOT NULL,
  PRIMARY KEY (article_id, tag_id),
  CONSTRAINT fk_at_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
  CONSTRAINT fk_at_tag     FOREIGN KEY (tag_id)     REFERENCES tags(id)     ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE : commentaires
-- Commentaires des visiteurs (modérés via BO)
-- ============================================================
CREATE TABLE commentaires (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  article_id  INT UNSIGNED NOT NULL,
  auteur_nom  VARCHAR(100) NOT NULL,
  auteur_email VARCHAR(150),
  contenu     TEXT         NOT NULL,
  statut      ENUM('en_attente','approuve','rejete') NOT NULL DEFAULT 'en_attente',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_comment_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE : pages_statiques
-- Pages fixes : À propos, Contact, Mentions légales…
-- ============================================================
CREATE TABLE pages_statiques (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  titre            VARCHAR(255) NOT NULL,
  slug             VARCHAR(270) NOT NULL UNIQUE,
  contenu          LONGTEXT     NOT NULL,
  meta_title       VARCHAR(70),
  meta_description VARCHAR(165),
  statut           ENUM('publie','archive') NOT NULL DEFAULT 'publie',
  created_at       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE : parametres_site
-- Configuration globale (nom du site, slogan, réseaux sociaux…)
-- ============================================================
CREATE TABLE parametres_site (
  cle        VARCHAR(80)  NOT NULL PRIMARY KEY,
  valeur     TEXT,
  updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE : logs_connexion  (BackOffice)
-- Audit des connexions administrateurs
-- ============================================================
CREATE TABLE logs_connexion (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    INT UNSIGNED,
  ip         VARCHAR(45),
  user_agent VARCHAR(255),
  succes     TINYINT(1)   NOT NULL DEFAULT 1,
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_log_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- INDEX supplémentaires (performances + SEO)
-- ============================================================
CREATE INDEX idx_articles_statut    ON articles(statut);
CREATE INDEX idx_articles_categorie ON articles(categorie_id);
CREATE INDEX idx_articles_date      ON articles(date_publication DESC);
CREATE INDEX idx_commentaires_statut ON commentaires(statut);

-- ============================================================
-- DONNÉES INITIALES
-- ============================================================

-- Catégories
INSERT INTO categories (nom, slug, description) VALUES
  ('Politique',     'politique',     'Actualités politiques liées au conflit en Iran'),
  ('Militaire',     'militaire',     'Opérations, stratégies et forces en présence'),
  ('Humanitaire',   'humanitaire',   'Impact sur les populations civiles et aide humanitaire'),
  ('Diplomatie',    'diplomatie',    'Négociations, sanctions et relations internationales'),
  ('Économie',      'economie',      'Conséquences économiques du conflit'),
  ('Médias',        'medias',        'Couverture presse et désinformation');

-- Tags SEO
INSERT INTO tags (nom, slug) VALUES
  ('Iran',            'iran'),
  ('Moyen-Orient',    'moyen-orient'),
  ('ONU',             'onu'),
  ('Sanctions',       'sanctions'),
  ('Nucléaire',       'nucleaire'),
  ('Réfugiés',        'refugies'),
  ('OTAN',            'otan'),
  ('États-Unis',      'etats-unis'),
  ('Israël',          'israel'),
  ('Diplomatie',      'diplomatie-tag');

-- Utilisateur admin par défaut (mot de passe : Admin1234!)
-- Hash bcrypt généré côté application — valeur exemple ci-dessous
INSERT INTO users (username, email, password_hash, role) VALUES
  ('admin', 'admin@iranwar-news.local',
   '$2y$12$exampleHashToReplaceAtFirstLogin000000000000000000000u',
   'admin');

-- Paramètres du site
INSERT INTO parametres_site (cle, valeur) VALUES
  ('site_nom',         'Iran War News'),
  ('site_slogan',      'L\'information en temps réel sur le conflit en Iran'),
  ('site_email',       'contact@iranwar-news.local'),
  ('articles_par_page','10'),
  ('commentaires_actifs','1'),
  ('twitter',          ''),
  ('facebook',         '');