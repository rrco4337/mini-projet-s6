<?php
/**
 * Header admin
 */
$user = Auth::user();
?>
<header class="sticky top-0 z-20 border-b border-slate-200/70 bg-white/85 backdrop-blur">
  <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
    <div class="relative w-full max-w-xl">
      <svg class="pointer-events-none absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M21 21l-4.35-4.35m1.85-5.15a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
      <input type="search" placeholder="Rechercher un article, une categorie..." class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 pl-12 pr-4 text-sm outline-none ring-0 transition placeholder:text-slate-400 focus:border-blue-300 focus:bg-white focus:shadow-soft" />
    </div>
    <div class="flex items-center gap-3">
      <a href="<?= url('/') ?>" target="_blank" class="hidden rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:border-slate-300 hover:bg-slate-50 md:inline-flex">Voir le site</a>
      <button type="button" class="relative inline-flex h-11 w-11 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-500 transition hover:bg-slate-50">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/></svg>
        <span class="absolute right-3 top-3 h-2 w-2 rounded-full bg-blue-600"></span>
      </button>
      <div class="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-3 py-2">
        <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-900 text-xs font-bold text-white">
          <?= strtoupper(substr($user['username'] ?? 'AD', 0, 2)) ?>
        </div>
        <div class="hidden sm:block">
          <p class="text-sm font-semibold leading-none text-slate-800"><?= e($user['username'] ?? 'Admin') ?></p>
          <p class="text-xs text-slate-500"><?= e($user['role'] ?? 'Editeur') ?></p>
        </div>
      </div>
      <a href="<?= url('logout') ?>" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
    </div>
  </div>
</header>
