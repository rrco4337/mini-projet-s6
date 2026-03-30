<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $pageTitle ?? 'Admin - Iran War News'; ?></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { @apply bg-slate-50 text-gray-900 font-sans antialiased; }
        .sidebar { @apply fixed inset-y-0 left-0 z-30 w-72 border-r border-slate-200 bg-white h-screen overflow-y-auto; }
        .main-content { @apply lg:ml-72; }
        .nav-active { @apply bg-blue-50 text-blue-700 font-semibold; }
        .nav-link { @apply px-4 py-3 rounded-lg flex items-center gap-3 text-slate-600 hover:bg-slate-100 transition; }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sticky top-0 bg-white p-6 border-b border-slate-200">
        <a href="/admin/" class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white font-bold">I</div>
            <div>
                <p class="text-xs uppercase tracking-widest text-slate-500">Backoffice</p>
                <p class="font-bold text-slate-900">Iran War News</p>
            </div>
        </a>
    </div>

    <nav class="p-6 space-y-1">
        <a href="/admin/" class="nav-link <?php echo basename($_SERVER['PHP_SELF']) === 'index.php' && strpos($_SERVER['REQUEST_URI'], '/admin/article') === false ? 'nav-active' : ''; ?>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 13h8V3H3v10zm10 8h8V11h-8v10zM3 21h8v-6H3v6zm10-10h8V3h-8v8z"/>
            </svg>
            Dashboard
        </a>

        <a href="/admin/articles.php" class="nav-link <?php echo strpos($_SERVER['PHP_SELF'], 'articles') !== false ? 'nav-active' : ''; ?>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21H7a2 2 0 01-2-2V5a2 2 0 012-2h12m0 18a2 2 0 002-2V5a2 2 0 00-2-2m0 18h-7m-3-8h6m-6-4h8m-8 8h8"/>
            </svg>
            Articles
        </a>

        <a href="/admin/categories.php" class="nav-link <?php echo strpos($_SERVER['PHP_SELF'], 'categor') !== false ? 'nav-active' : ''; ?>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7a2 2 0 012-2h4l2 2h8a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V7z"/>
            </svg>
            Catégories
        </a>
    </nav>

    <div class="p-6 mt-auto border-t border-slate-200">
        <div class="rounded-lg border border-slate-200 bg-slate-50 p-4 text-sm text-slate-600">
            <p class="font-semibold text-slate-800 text-xs uppercase">Espace Editorial</p>
            <p class="mt-2 text-xs">Publiez et gérez vos contenus depuis cette interface.</p>
        </div>
    </div>
</aside>

<div class="main-content">
    <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/85 backdrop-blur">
        <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
            <h2 class="text-lg font-semibold text-slate-900"><?php echo $pageTitle ?? 'Admin'; ?></h2>
            <div class="flex items-center gap-4">
                <a href="/" target="_blank" class="hidden md:inline-block px-4 py-2 text-sm font-medium text-slate-700 border border-slate-200 rounded-lg hover:bg-slate-50 transition">
                    👁️ Voir le site
                </a>
                <a href="/logout.php" class="px-4 py-2 text-sm font-medium text-red-700 border border-red-200 rounded-lg hover:bg-red-50 transition">
                    Déconnexion
                </a>
            </div>
        </div>
    </header>

    <div class="p-8">
        <?php
        $flash = getFlash();
        if ($flash):
        ?>
        <div class="p-4 mb-6 rounded-lg <?php echo $flash['type'] === 'success' ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'; ?>">
            <?php echo e($flash['message']); ?>
        </div>
        <?php endif; ?>
