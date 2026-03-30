<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $pageTitle ?? 'Iran War News'; ?></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700;800&family=Source+Sans+3:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { @apply bg-yellow-50 text-gray-900 font-sans antialiased; }
        .article-content h2, .article-content h3 { @apply font-serif font-bold mt-6 mb-3; }
        .article-content p { @apply my-3; }
        .article-content a { @apply underline text-gray-700 hover:text-gray-900; }
    </style>
</head>
<body>
<header class="border-b border-gray-200 bg-white/95 backdrop-blur-sm sticky top-0 z-50">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div class="flex items-end justify-between gap-4">
            <a href="/" class="group inline-flex flex-col leading-none">
                <span class="text-xs uppercase tracking-widest text-gray-500">Actualités Internationales</span>
                <span class="font-serif text-4xl font-bold tracking-tight hover:text-gray-600 transition">Iran War News</span>
            </a>
            <nav class="flex items-center gap-4 text-sm">
                <a href="/" class="font-semibold text-gray-900 hover:text-blue-600 transition">Accueil</a>
                <?php if (isLogged()): ?>
                    <a href="/admin/" class="font-semibold text-gray-600 hover:text-gray-900 transition">Admin</a>
                    <a href="/logout.php" class="px-3 py-2 rounded-lg bg-red-50 text-red-700 hover:bg-red-100 transition text-xs font-semibold">Déconnexion</a>
                <?php else: ?>
                    <a href="/login.php" class="px-3 py-2 rounded-lg bg-blue-50 text-blue-700 hover:bg-blue-100 transition text-xs font-semibold">Connexion</a>
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
        <?php echo e($flash['message']); ?>
    </div>
    <?php endif; ?>
