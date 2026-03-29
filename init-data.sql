-- Données d'initialisation pour Iran War News

-- Mise à jour du mot de passe admin avec le hash BCrypt généré
UPDATE users
SET password_hash = '$2a$10$cZjDNEqOn3IO2Ua8edEg9eVYyPf0ZR0nEw1TCYJ0s38C20xftPf0O'
WHERE username = 'admin';

-- Insertion d'un article de test
INSERT INTO articles (
    titre,
    slug,
    chapeau,
    contenu,
    meta_title,
    meta_description,
    statut,
    date_publication,
    categorie_id,
    a_la_une
) VALUES (
    'Tensions géopolitiques en Iran',
    'tensions-geopolitiques-iran-2026',
    'Analyse des derniers développements du conflit en Iran et de ses implications régionales.',
    '<p>La situation en Iran continue d''évoluer avec de nouvelles tensions diplomatiques...</p><h3>Contexte international</h3><p>Les relations avec les pays voisins se complexifient...</p>',
    'Tensions Iran 2026 - Actualités géopolitiques',
    'Dernières actualités sur les tensions géopolitiques en Iran et analyse des enjeux regionaux.',
    'publie',
    NOW(),
    1,
    true
) ON CONFLICT (slug) DO NOTHING;

-- Vérification des données
SELECT 'Articles:' as table_name, count(*) as count FROM articles
UNION ALL
SELECT 'Categories:', count(*) FROM categories
UNION ALL
SELECT 'Users:', count(*) FROM users;