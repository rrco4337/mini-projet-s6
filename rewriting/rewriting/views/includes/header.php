<?php
/**
 * Header du site (front-office)
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><?= e($pageTitle ?? 'Iran War News') ?> - Iran War News</title>
  <?php if (!empty($metaDescription)): ?>
    <meta name="description" content="<?= e($metaDescription) ?>" />
  <?php endif; ?>
  <?php if (!empty($metaKeywords)): ?>
    <meta name="keywords" content="<?= e($metaKeywords) ?>" />
  <?php endif; ?>
  <meta name="robots" content="<?= e($metaRobots ?? 'index, follow') ?>" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700;800&family=Source+Sans+3:wght@400;500;600;700&display=swap" rel="stylesheet" />
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
        <a href="<?= url('/') ?>" class="group inline-flex flex-col leading-none">
          <span class="text-[11px] uppercase tracking-[0.2em] text-gray-500">Edition Internationale</span>
          <span class="font-serif text-3xl sm:text-4xl font-bold tracking-tight group-hover:text-accent transition-colors">Iran War News</span>
        </a>
        <a href="<?= url('admin') ?>" class="text-sm font-semibold uppercase tracking-widest text-gray-600 hover:text-ink transition-colors">Administration</a>
      </div>

      <div class="h-px bg-gradient-to-r from-transparent via-stone to-transparent"></div>

      <nav class="flex flex-wrap items-center gap-x-4 gap-y-2 text-[13px] sm:text-sm">
        <a href="<?= url('/') ?>" class="font-semibold text-ink hover:text-accent transition-colors">Accueil</a>
        <span class="text-gray-300">|</span>
        <?php if (!empty($navCategories)): ?>
          <?php foreach ($navCategories as $index => $cat): ?>
            <a href="<?= url('/?categorySlugs[]=' . e($cat['slug'])) ?>" class="text-gray-600 hover:text-ink transition-colors"><?= e($cat['nom']) ?></a>
            <?php if ($index < count($navCategories) - 1): ?>
              <span class="text-gray-300">|</span>
            <?php endif; ?>
          <?php endforeach; ?>
        <?php else: ?>
          <span class="text-gray-500">Aucune categorie disponible</span>
        <?php endif; ?>
      </nav>
    </div>
  </div>
</header>
