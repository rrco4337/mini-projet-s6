-- ============================================================
--  Mini-Projet Web Design 2026 - Site d'informations sur la guerre en Iran
--  Base de données PostgreSQL (converti depuis MySQL)
--  Encodage : UTF8 (géré au niveau de la base et de la connexion)
-- ============================================================

-- Créer la base avec encodage UTF8 explicite
-- À exécuter en tant que superutilisateur AVANT de se connecter à la base :
--
--   CREATE DATABASE iran_war_db
--     ENCODING    'UTF8'
--     LC_COLLATE  'fr_FR.UTF-8'
--     LC_CTYPE    'fr_FR.UTF-8'
--     TEMPLATE    template0;
--
-- Si la locale fr_FR n'est pas disponible sur le serveur, utiliser :
--     LC_COLLATE 'en_US.UTF-8'  LC_CTYPE 'en_US.UTF-8'
--
-- Puis se connecter à la base :
--   \c iran_war_db
--
-- Forcer l'encodage client pour la session (bonne pratique) :
SET client_encoding = 'UTF8';

-- ============================================================
-- Nettoyage préalable (ordre inverse des dépendances FK)
-- ============================================================
DROP TABLE IF EXISTS logs_connexion   CASCADE;
DROP TABLE IF EXISTS parametres_site  CASCADE;
DROP TABLE IF EXISTS pages_statiques  CASCADE;
DROP TABLE IF EXISTS commentaires     CASCADE;
DROP TABLE IF EXISTS article_tag      CASCADE;
DROP TABLE IF EXISTS articles         CASCADE;
DROP TABLE IF EXISTS medias           CASCADE;
DROP TABLE IF EXISTS users            CASCADE;
DROP TABLE IF EXISTS tags             CASCADE;
DROP TABLE IF EXISTS categories       CASCADE;

-- Nettoyage des types ENUM
DROP TYPE IF EXISTS user_role         CASCADE;
DROP TYPE IF EXISTS article_statut    CASCADE;
DROP TYPE IF EXISTS commentaire_statut CASCADE;
DROP TYPE IF EXISTS page_statut       CASCADE;

-- ============================================================
-- Types ENUM
-- PostgreSQL utilise des types CREATE TYPE pour les énumérations
-- ============================================================
CREATE TYPE user_role          AS ENUM ('admin', 'editeur', 'lecteur');
CREATE TYPE article_statut     AS ENUM ('brouillon', 'publie', 'archive');
CREATE TYPE commentaire_statut AS ENUM ('en_attente', 'approuve', 'rejete');
CREATE TYPE page_statut        AS ENUM ('publie', 'archive');

-- ============================================================
-- TABLE : categories
-- ============================================================
CREATE TABLE categories (
  id          SERIAL       PRIMARY KEY,
  nom         VARCHAR(100) NOT NULL,
  slug        VARCHAR(110) NOT NULL UNIQUE,
  description TEXT,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  categories        IS 'Catégories des articles (Politique, Militaire, Humanitaire…)';
COMMENT ON COLUMN categories.slug   IS 'URL rewriting – doit être unique et en minuscules';

-- ============================================================
-- TABLE : tags
-- ============================================================
CREATE TABLE tags (
  id         SERIAL      PRIMARY KEY,
  nom        VARCHAR(80) NOT NULL,
  slug       VARCHAR(90) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE tags IS 'Mots-clés SEO associés aux articles';

-- ============================================================
-- TABLE : users  (BackOffice)
-- ============================================================
CREATE TABLE users (
  id            SERIAL       PRIMARY KEY,
  username      VARCHAR(60)  NOT NULL UNIQUE,
  email         VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,          -- bcrypt
  role          user_role    NOT NULL DEFAULT 'editeur',
  actif         BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  users               IS 'Administrateurs et rédacteurs du backoffice';
COMMENT ON COLUMN users.password_hash IS 'Hash bcrypt – jamais en clair';

-- ============================================================
-- TABLE : medias
-- ============================================================
CREATE TABLE medias (
  id          SERIAL       PRIMARY KEY,
  fichier     VARCHAR(255) NOT NULL,            -- chemin relatif
  alt         VARCHAR(200) NOT NULL,            -- balise alt (SEO)
  titre       VARCHAR(200),
  description TEXT,
  mime_type   VARCHAR(60),
  taille      INTEGER      CHECK (taille >= 0), -- octets
  uploaded_by INTEGER      REFERENCES users(id) ON DELETE SET NULL,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  medias     IS 'Images et fichiers uploadés';
COMMENT ON COLUMN medias.alt IS 'Texte alternatif obligatoire pour accessibilité et SEO';

-- ============================================================
-- TABLE : articles
-- ============================================================
CREATE TABLE articles (
  id               SERIAL        PRIMARY KEY,
  titre            VARCHAR(255)  NOT NULL,
  slug             VARCHAR(270)  NOT NULL UNIQUE,
  sous_titre       VARCHAR(255),
  chapeau          TEXT,
  contenu          TEXT          NOT NULL,            -- corps HTML
  meta_title       VARCHAR(70),                       -- ≤ 60 caractères recommandés
  meta_description VARCHAR(165),                      -- ≤ 155 caractères recommandés
  meta_keywords    VARCHAR(255),
  image_une        INTEGER       REFERENCES medias(id)     ON DELETE SET NULL,
  categorie_id     INTEGER       REFERENCES categories(id) ON DELETE SET NULL,
  auteur_id        INTEGER       REFERENCES users(id)      ON DELETE SET NULL,
  statut           article_statut NOT NULL DEFAULT 'brouillon',
  a_la_une         BOOLEAN       NOT NULL DEFAULT FALSE,
  vues             INTEGER       NOT NULL DEFAULT 0 CHECK (vues >= 0),
  date_publication TIMESTAMPTZ,
  created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  articles               IS 'Contenu principal – front-office';
COMMENT ON COLUMN articles.contenu       IS 'Corps de l''article en HTML';
COMMENT ON COLUMN articles.a_la_une      IS 'Mis en avant sur la page d''accueil';
COMMENT ON COLUMN articles.meta_title    IS 'Balise <title> SEO – 60 caractères max';
COMMENT ON COLUMN articles.meta_description IS 'Balise <meta description> – 155 caractères max';

-- ============================================================
-- TABLE PIVOT : article_tag  (relation N-N)
-- ============================================================
CREATE TABLE article_tag (
  article_id INTEGER NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  tag_id     INTEGER NOT NULL REFERENCES tags(id)     ON DELETE CASCADE,
  PRIMARY KEY (article_id, tag_id)
);

-- ============================================================
-- TABLE : commentaires
-- ============================================================
CREATE TABLE commentaires (
  id           SERIAL             PRIMARY KEY,
  article_id   INTEGER            NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  auteur_nom   VARCHAR(100)       NOT NULL,
  auteur_email VARCHAR(150),
  contenu      TEXT               NOT NULL,
  statut       commentaire_statut NOT NULL DEFAULT 'en_attente',
  created_at   TIMESTAMPTZ        NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE commentaires IS 'Commentaires visiteurs – modérés via le back-office';

-- ============================================================
-- TABLE : pages_statiques
-- ============================================================
CREATE TABLE pages_statiques (
  id               SERIAL       PRIMARY KEY,
  titre            VARCHAR(255) NOT NULL,
  slug             VARCHAR(270) NOT NULL UNIQUE,
  contenu          TEXT         NOT NULL,
  meta_title       VARCHAR(70),
  meta_description VARCHAR(165),
  statut           page_statut  NOT NULL DEFAULT 'publie',
  created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE pages_statiques IS 'Pages fixes : À propos, Contact, Mentions légales…';

-- ============================================================
-- TABLE : parametres_site
-- ============================================================
CREATE TABLE parametres_site (
  cle        VARCHAR(80) NOT NULL PRIMARY KEY,
  valeur     TEXT,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE parametres_site IS 'Configuration globale : nom du site, slogan, réseaux sociaux…';

-- ============================================================
-- TABLE : logs_connexion  (BackOffice – audit)
-- ============================================================
CREATE TABLE logs_connexion (
  id         SERIAL      PRIMARY KEY,
  user_id    INTEGER     REFERENCES users(id) ON DELETE SET NULL,
  ip         VARCHAR(45),                             -- IPv4 et IPv6
  user_agent VARCHAR(255),
  succes     BOOLEAN     NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE logs_connexion IS 'Audit des connexions au back-office';

-- ============================================================
-- INDEX (performances + SEO)
-- ============================================================
CREATE INDEX idx_articles_statut    ON articles(statut);
CREATE INDEX idx_articles_categorie ON articles(categorie_id);
CREATE INDEX idx_articles_date      ON articles(date_publication DESC NULLS LAST);
CREATE INDEX idx_commentaires_statut ON commentaires(statut);

-- Index partiel : seuls les articles publiés sont requêtés en front-office
CREATE INDEX idx_articles_publies ON articles(date_publication DESC NULLS LAST)
  WHERE statut = 'publie';

-- ============================================================
-- TRIGGER : mise à jour automatique de updated_at
-- PostgreSQL ne supporte pas ON UPDATE CURRENT_TIMESTAMP nativement,
-- il faut utiliser une fonction + trigger sur chaque table concernée.
-- ============================================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_articles_updated_at
  BEFORE UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_pages_statiques_updated_at
  BEFORE UPDATE ON pages_statiques
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_parametres_site_updated_at
  BEFORE UPDATE ON parametres_site
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- DONNÉES INITIALES
-- ============================================================

-- Catégories
INSERT INTO categories (nom, slug, description) VALUES
  ('Politique',   'politique',   'Actualités politiques liées au conflit en Iran'),
  ('Militaire',   'militaire',   'Opérations, stratégies et forces en présence'),
  ('Humanitaire', 'humanitaire', 'Impact sur les populations civiles et aide humanitaire'),
  ('Diplomatie',  'diplomatie',  'Négociations, sanctions et relations internationales'),
  ('Économie',    'economie',    'Conséquences économiques du conflit'),
  ('Médias',      'medias',      'Couverture presse et désinformation');

-- Tags SEO
INSERT INTO tags (nom, slug) VALUES
  ('Iran',         'iran'),
  ('Moyen-Orient', 'moyen-orient'),
  ('ONU',          'onu'),
  ('Sanctions',    'sanctions'),
  ('Nucléaire',    'nucleaire'),
  ('Réfugiés',     'refugies'),
  ('OTAN',         'otan'),
  ('États-Unis',   'etats-unis'),
  ('Israël',       'israel'),
  ('Diplomatie',   'diplomatie-tag');

-- Utilisateur admin par défaut (mot de passe : Admin1234!)
-- Le hash bcrypt doit être regénéré côté application avant la mise en production
INSERT INTO users (username, email, password_hash, role) VALUES
  ('admin', 'admin@iranwar-news.local',
   '$2y$12$exampleHashToReplaceAtFirstLogin000000000000000000000u',
   'admin');

-- Paramètres du site
INSERT INTO parametres_site (cle, valeur) VALUES
  ('site_nom',             'Iran War News'),
  ('site_slogan',          'L''information en temps réel sur le conflit en Iran'),
  ('site_email',           'contact@iranwar-news.local'),
  ('articles_par_page',    '10'),
  ('commentaires_actifs',  '1'),
  ('twitter',              ''),
  ('facebook',             '');