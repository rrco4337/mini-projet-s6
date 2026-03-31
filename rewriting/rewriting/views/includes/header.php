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
  <meta name="theme-color" content="#fafaf9" />
  
  <!-- Titres & Descriptions -->
  <title><?= e($pageTitle ?? 'Iran War News') ?> - Iran War News</title>
  <?php if (!empty($metaDescription)): ?>
    <meta name="description" content="<?= e($metaDescription) ?>" />
  <?php else: ?>
    <meta name="description" content="Iran War News - Informations et analyses sur le conflit en Iran, dans une mise en perspective éditoriale sobre et exigeante." />
  <?php endif; ?>
  <?php if (!empty($metaKeywords)): ?>
    <meta name="keywords" content="<?= e($metaKeywords) ?>" />
  <?php else: ?>
    <meta name="keywords" content="Iran, actualités, analyses, conflit, Moyen-Orient" />
  <?php endif; ?>
  
  <!-- Meta de base -->
  <meta name="robots" content="<?= e($metaRobots ?? 'index, follow') ?>" />
  <meta name="language" content="fr" />
  <meta name="author" content="Iran War News" />
  
  <!-- Open Graph (réseaux sociaux) -->
  <meta property="og:type" content="<?= ($pageType ?? 'website') ?>" />
  <meta property="og:title" content="<?= e($pageTitle ?? 'Iran War News') ?>" />
  <meta property="og:description" content="<?= e($metaDescription ?? 'Informations et analyses sur le conflit en Iran') ?>" />
  <meta property="og:url" content="<?= e($currentUrl ?? '') ?>" />
  <meta property="og:site_name" content="Iran War News" />
  <?php if (!empty($ogImage)): ?>
    <meta property="og:image" content="<?= e($ogImage) ?>" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
  <?php endif; ?>
  
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="<?= e($pageTitle ?? 'Iran War News') ?>" />
  <meta name="twitter:description" content="<?= e($metaDescription ?? 'Informations et analyses') ?>" />
  <?php if (!empty($ogImage)): ?>
    <meta name="twitter:image" content="<?= e($ogImage) ?>" />
  <?php endif; ?>
  
  <!-- Canonical Link -->
  <link rel="canonical" href="<?= e($canonicalUrl ?? '') ?>" />
  
  <!-- Favicons -->
  <link rel="icon" type="image/x-icon" href="/favicon.ico" />
  <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
  
  <!-- Fonts (avec display: swap pour LCP) -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700;800&family=Source+Sans+3:wght@400;500;600;700&display=swap" rel="stylesheet" />
  
  <!-- Tailwind CSS - ASYNC pour ne pas bloquer le rendu -->
  <script async src="https://cdn.tailwindcss.com"></script>
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
  
  <!-- Styles critiques inline (pour FCP) -->
  <style>
    body { background: #fafaf9; font-family: 'Source Sans 3', sans-serif; color: #111; line-height: 1.5; }
    header { border-bottom: 1px solid #e7e5e4; background: rgba(255,255,255,0.95); backdrop-filter: blur(1px); position: sticky; top: 0; z-index: 50; }
    img { max-width: 100%; height: auto; display: block; }
    a { text-decoration: none; }
    
    .article-content h2,
    .article-content h3,
    .article-content h4 {
      font-family: 'Playfair Display', serif;
      margin-top: 1.6rem;
      margin-bottom: 0.8rem;
      line-height: 1.25;
      color: #111111;
    }
    .article-content p {
      margin-top: 0.9rem;
      margin-bottom: 0.9rem;
      line-height: 1.6;
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
          <h1 class="font-serif text-3xl sm:text-4xl font-bold tracking-tight group-hover:text-accent transition-colors">Iran War News</h1>
        </a>
        <a href="<?= url('admin') ?>" class="text-sm font-semibold uppercase tracking-widest text-gray-600 hover:text-ink transition-colors">Administration</a>
      </div>

      <div class="h-px bg-gradient-to-r from-transparent via-stone to-transparent"></div>

      <nav class="flex flex-wrap items-center gap-x-4 gap-y-2 text-[13px] sm:text-sm">
        <a href="<?= url('/') ?>" class="font-semibold text-ink hover:text-accent transition-colors">Accueil</a>
        <span class="text-gray-300">|</span>
        <?php if (!empty($navCategories)): ?>
          <?php foreach ($navCategories as $index => $cat): ?>
            <a href="<?= url('/?categorySlugs=' . e($cat['slug'])) ?>" class="text-gray-600 hover:text-ink transition-colors"><?= e($cat['nom']) ?></a>
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
