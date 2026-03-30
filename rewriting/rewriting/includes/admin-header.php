<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $pageTitle ?? 'Admin - Iran War News'; ?></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        :root {
            --bg-soft: #f5f7fb;
            --bg-panel: #ffffff;
            --text-main: #111827;
            --text-muted: #64748b;
            --accent: #2563eb;
            --accent-soft: #eff6ff;
            --border-soft: #e2e8f0;
            --shadow-soft: 0 14px 35px rgba(15, 23, 42, 0.06);
        }

        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            color: var(--text-main);
            background:
                radial-gradient(circle at 10% 10%, rgba(37, 99, 235, 0.10), transparent 35%),
                radial-gradient(circle at 90% 0%, rgba(15, 23, 42, 0.08), transparent 30%),
                var(--bg-soft);
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            width: 18rem;
            z-index: 30;
            border-right: 1px solid var(--border-soft);
            background: var(--bg-panel);
            overflow-y: auto;
        }

        .main-content {
            margin-left: 0;
        }

        @media (min-width: 1024px) {
            .main-content {
                margin-left: 18rem;
            }
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.72rem 0.9rem;
            border-radius: 0.85rem;
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .nav-link:hover {
            background: #f1f5f9;
            color: #0f172a;
            transform: translateX(2px);
        }

        .nav-active {
            background: var(--accent-soft);
            color: var(--accent);
            font-weight: 700;
            box-shadow: inset 0 0 0 1px rgba(37, 99, 235, 0.14);
        }

        .panel {
            background: var(--bg-panel);
            border: 1px solid var(--border-soft);
            box-shadow: var(--shadow-soft);
        }
    </style>
</head>
<body>

<?php
$requestUri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
?>

<aside class="sidebar">
    <div class="sticky top-0 bg-white p-6 border-b border-slate-200">
        <a href="/admin" class="flex items-center gap-3">
            <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-slate-900 text-white font-semibold">IW</div>
            <div>
                <p class="text-[11px] uppercase tracking-[0.2em] text-slate-500">Editorial CMS</p>
                <p class="font-bold text-slate-900">Iran War News</p>
            </div>
        </a>
    </div>

    <nav class="p-6 space-y-1">
        <a href="/admin" class="nav-link <?php echo ($requestUri === '/admin' || $requestUri === '/admin/') ? 'nav-active' : ''; ?>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 13h8V3H3v10zm10 8h8V11h-8v10zM3 21h8v-6H3v6zm10-10h8V3h-8v8z"/>
            </svg>
            Dashboard
        </a>

        <a href="/admin/articles" class="nav-link <?php echo strpos($requestUri, '/admin/article') === 0 || strpos($requestUri, '/admin/articles') === 0 ? 'nav-active' : ''; ?>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21H7a2 2 0 01-2-2V5a2 2 0 012-2h12m0 18a2 2 0 002-2V5a2 2 0 00-2-2m0 18h-7m-3-8h6m-6-4h8m-8 8h8"/>
            </svg>
            Articles
        </a>

        <a href="/admin/categories" class="nav-link <?php echo strpos($requestUri, '/admin/categor') === 0 ? 'nav-active' : ''; ?>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7a2 2 0 012-2h4l2 2h8a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V7z"/>
            </svg>
            Catégories
        </a>

        <a href="#" class="nav-link">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5V4H2v16h5m10 0v-2a4 4 0 00-4-4H11a4 4 0 00-4 4v2m10 0H7m10-10a4 4 0 11-8 0 4 4 0 018 0z"/>
            </svg>
            Utilisateurs
        </a>

        <a href="#" class="nav-link">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317a1 1 0 011.35-.936l1.612.658a1 1 0 00.948-.086l1.427-.96a1 1 0 011.48.617l.36 1.675a1 1 0 00.688.75l1.636.498a1 1 0 01.63 1.472l-.83 1.495a1 1 0 000 .972l.83 1.495a1 1 0 01-.63 1.472l-1.636.498a1 1 0 00-.688.75l-.36 1.675a1 1 0 01-1.48.617l-1.427-.96a1 1 0 00-.948-.086l-1.612.658a1 1 0 01-1.35-.936l-.11-1.71a1 1 0 00-.552-.812l-1.53-.765a1 1 0 010-1.788l1.53-.765a1 1 0 00.553-.812l.109-1.71z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            Paramètres
        </a>
    </nav>

    <div class="p-6 mt-auto border-t border-slate-200">
        <div class="rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm text-slate-600">
            <p class="font-semibold text-slate-800 text-xs uppercase">Espace Editorial</p>
            <p class="mt-2 text-xs">Publiez et gérez vos contenus depuis cette interface.</p>
        </div>
    </div>
</aside>

<div class="main-content">
    <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/88 backdrop-blur">
        <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
            <div class="relative w-full max-w-xl">
                <svg class="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35m1.85-5.15a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
                <input type="search" placeholder="Rechercher un article, une categorie..." class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 pl-10 pr-4 text-sm text-slate-700 outline-none transition focus:border-blue-300 focus:bg-white" />
            </div>
            <div class="flex items-center gap-3">
                <button type="button" class="relative inline-flex h-11 w-11 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 hover:bg-slate-50">
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.4-1.4A2 2 0 0118 14.2V11a6 6 0 00-4-5.7V5a2 2 0 10-4 0v.3A6 6 0 006 11v3.2c0 .5-.2 1-.6 1.4L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                    </svg>
                    <span class="absolute right-3 top-3 h-2 w-2 rounded-full bg-blue-600"></span>
                </button>
                <a href="/" target="_blank" class="hidden md:inline-flex items-center rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">
                    Voir le site
                </a>
                <div class="hidden sm:flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-3 py-2">
                    <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-900 text-xs font-bold text-white">
                        <?php echo strtoupper(substr($_SESSION['username'] ?? 'AD', 0, 2)); ?>
                    </div>
                    <div>
                        <p class="text-sm font-semibold leading-none text-slate-800"><?php echo e($_SESSION['username'] ?? 'Admin'); ?></p>
                        <p class="text-xs text-slate-500">Redaction</p>
                    </div>
                </div>
                <a href="/logout" class="rounded-xl border border-red-200 bg-white px-4 py-2 text-sm font-medium text-red-700 hover:bg-red-50">
                    Deconnexion
                </a>
            </div>
        </div>
    </header>

    <div class="p-6 sm:p-8">
        <?php
        $flash = getFlash();
        if ($flash):
        ?>
        <div class="panel p-4 mb-6 rounded-xl <?php echo $flash['type'] === 'success' ? 'bg-green-50 text-green-800 border-green-200' : 'bg-red-50 text-red-800 border-red-200'; ?>">
            <?php echo e($flash['message']); ?>
        </div>
        <?php endif; ?>
