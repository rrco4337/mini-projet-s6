<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><?php echo htmlspecialchars($pageTitle ?? 'Iran War News'); ?> - Iran War News</title>
  <?php if (!empty($metaDescription)): ?>
    <meta name="description" content="<?php echo htmlspecialchars($metaDescription); ?>">
  <?php endif; ?>
  <?php if (!empty($metaKeywords)): ?>
    <meta name="keywords" content="<?php echo htmlspecialchars($metaKeywords); ?>">
  <?php endif; ?>
  <meta name="robots" content="<?php echo htmlspecialchars($metaRobots ?? 'index, follow'); ?>">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700;800&family=Source+Sans+3:wght@400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            ink: '#111111',
            paper: '#fafaf9',
            stone: '#e7e5e4',
            accent: '#4a5568'
          },
          fontFamily: {
            sans: ['Source Sans 3', 'ui-sans-serif', 'sans-serif'],
            serif: ['Playfair Display', 'ui-serif', 'serif']
          },
          boxShadow: {
            editorial: '0 12px 32px rgba(0, 0, 0, 0.08)'
          }
        }
      }
    };
  </script>
  <style>
    .article-content h2,
    .article-content h3,
    .article-content h4 {
      font-family: 'Playfair Display', ui-serif, serif;
      margin-top: 1.6rem;
      margin-bottom: 0.8rem;
      line-height: 1.25;
      color: #111111;
    }

    .article-content p {
      margin-top: 0.9rem;
      margin-bottom: 0.9rem;
    }

    .article-content a {
      text-decoration: underline;
      text-underline-offset: 3px;
      color: #1f2937;
      transition: color 0.2s ease;
    }

    .article-content a:hover {
      color: #111111;
    }
  </style>
</head>
<body class="bg-paper text-ink font-sans antialiased">

<header class="border-b border-stone bg-white/95 backdrop-blur-sm sticky top-0 z-50">
  <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
    <div class="flex flex-col gap-3 lg:gap-4">
      <div class="flex items-end justify-between gap-4">
        <a href="/" class="group inline-flex flex-col leading-none">
          <span class="text-[11px] uppercase tracking-[0.2em] text-gray-500">Edition Internationale</span>
          <span class="font-serif text-3xl sm:text-4xl font-bold tracking-tight group-hover:text-accent transition-colors">Iran War News</span>
        </a>
        <nav class="flex items-center gap-4 text-sm">
          <a href="/" class="font-semibold text-ink hover:text-accent transition-colors">Accueil</a>
          <?php if (isLogged()): ?>
            <a href="/admin/" class="font-semibold text-gray-600 hover:text-ink transition-colors">Admin</a>
            <a href="/logout.php" class="px-3 py-2 rounded-lg bg-red-50 text-red-700 hover:bg-red-100 transition text-xs font-semibold">Déconnexion</a>
          <?php else: ?>
            <a href="/login.php" class="px-3 py-2 rounded-lg bg-blue-50 text-blue-700 hover:bg-blue-100 transition text-xs font-semibold">Connexion</a>
          <?php endif; ?>
        </nav>
      </div>

      <div class="h-px bg-gradient-to-r from-transparent via-stone to-transparent"></div>

      <nav class="flex flex-wrap items-center gap-x-4 gap-y-2 text-[13px] sm:text-sm">
        <a href="/" class="font-semibold text-ink hover:text-accent transition-colors">Accueil</a>
        <?php
        // Charger les catégories si pas déjà défini
        if (empty($navCategories)) {
            $navCategories = [];
            try {
                // Inclure les classes nécessaires si pas déjà chargées
                if (!class_exists('Database')) {
                    require_once __DIR__ . '/../core/Database.php';
                }
                if (!class_exists('Model')) {
                    require_once __DIR__ . '/../core/Model.php';
                }
                if (!class_exists('Category')) {
                    require_once __DIR__ . '/../models/Category.php';
                }
                $navCategories = Category::all();
            } catch (Exception $e) {
                // Silencieusement échouer si les catégories ne peuvent pas être chargées
            }
        }
        if (!empty($navCategories)): ?>
          <span class="text-gray-300">|</span>
          <?php foreach ($navCategories as $index => $cat): ?>
            <a href="/?categorySlugs=<?php echo urlencode($cat['slug']); ?>" class="text-gray-600 hover:text-ink transition-colors"><?php echo htmlspecialchars($cat['nom']); ?></a>
            <?php if ($index < count($navCategories) - 1): ?>
              <span class="text-gray-300">|</span>
            <?php endif; ?>
          <?php endforeach; ?>
        <?php endif; ?>
      </nav>
    </div>
  </div>
</header>

<div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
  <?php
  $flash = getFlash();
  if ($flash):
  ?>
  <div class="p-4 mb-6 rounded-lg <?php echo $flash['type'] === 'success' ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'; ?>">
    <?php echo htmlspecialchars($flash['message']); ?>
  </div>
  <?php endif; ?>
