<?php
/**
 * Sidebar admin
 */
$currentPage = $_SERVER['REQUEST_URI'] ?? '';
?>
<aside>
  <a href="<?= url('admin') ?>" class="flex items-center gap-3">
    <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white">
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 10-8.038 0l-2.387.477a2 2 0 00-1.021.547M6 19h12"/></svg>
    </div>
    <div>
      <p class="text-sm font-medium tracking-wide text-slate-500">Backoffice</p>
      <p class="text-lg font-semibold text-slate-900">Iran War News</p>
    </div>
  </a>

  <nav class="mt-10 space-y-1">
    <a href="<?= url('admin') ?>" class="flex items-center gap-3 rounded-xl <?= strpos($currentPage, '/admin') !== false && strpos($currentPage, '/articles') === false && strpos($currentPage, '/categories') === false ? 'bg-blue-50 font-semibold text-blue-700' : 'px-4 py-3 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900' ?> px-4 py-3">
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M3 13h8V3H3v10zm10 8h8V11h-8v10zM3 21h8v-6H3v6zm10-10h8V3h-8v8z"/></svg>
      Dashboard
    </a>
    <a href="<?= url('admin/articles') ?>" class="flex items-center gap-3 rounded-xl <?= strpos($currentPage, '/admin/articles') !== false ? 'bg-blue-50 font-semibold text-blue-700' : 'text-slate-600 transition hover:bg-slate-100 hover:text-slate-900' ?> px-4 py-3">
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M19 21H7a2 2 0 01-2-2V5a2 2 0 012-2h12m0 18a2 2 0 002-2V5a2 2 0 00-2-2m0 18h-7m-3-8h6m-6-4h8m-8 8h8"/></svg>
      Articles
    </a>
    <a href="<?= url('admin/articles/drafts') ?>" class="flex items-center gap-3 rounded-xl <?= strpos($currentPage, '/admin/articles/drafts') !== false ? 'bg-blue-50 font-semibold text-blue-700' : 'text-slate-600 transition hover:bg-slate-100 hover:text-slate-900' ?> px-4 py-3">
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M12 20h9"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M16.5 3.5a2.1 2.1 0 013 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
      Brouillons
    </a>
    <a href="<?= url('admin/articles/archives') ?>" class="flex items-center gap-3 rounded-xl <?= strpos($currentPage, '/admin/articles/archives') !== false ? 'bg-blue-50 font-semibold text-blue-700' : 'text-slate-600 transition hover:bg-slate-100 hover:text-slate-900' ?> px-4 py-3">
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M20.54 5.23l-1.39-1.68A2 2 0 0017.61 3H6.39a2 2 0 00-1.54.55L3.46 5.23A2 2 0 003 6.52V8a1 1 0 001 1h16a1 1 0 001-1V6.52a2 2 0 00-.46-1.29z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M5 9v9a2 2 0 002 2h10a2 2 0 002-2V9"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M10 13h4"/></svg>
      Archives
    </a>
    <a href="<?= url('categories') ?>" class="flex items-center gap-3 rounded-xl <?= strpos($currentPage, '/categories') !== false ? 'bg-blue-50 font-semibold text-blue-700' : 'text-slate-600 transition hover:bg-slate-100 hover:text-slate-900' ?> px-4 py-3">
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M3 7a2 2 0 012-2h4l2 2h8a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V7z"/></svg>
      Categories
    </a>
    <a href="#" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-400 transition hover:bg-slate-100">
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M17 20h5V4H2v16h5m10 0v-2a4 4 0 00-4-4H11a4 4 0 00-4 4v2m10 0H7m10-10a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
      Utilisateurs
    </a>
    <a href="#" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-400 transition hover:bg-slate-100">
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M10.325 4.317a1 1 0 011.35-.936l1.612.658a1 1 0 00.948-.086l1.427-.96a1 1 0 011.48.617l.36 1.675a1 1 0 00.688.75l1.636.498a1 1 0 01.63 1.472l-.83 1.495a1 1 0 000 .972l.83 1.495a1 1 0 01-.63 1.472l-1.636.498a1 1 0 00-.688.75l-.36 1.675a1 1 0 01-1.48.617l-1.427-.96a1 1 0 00-.948-.086l-1.612.658a1 1 0 01-1.35-.936l-.11-1.71a1 1 0 00-.552-.812l-1.53-.765a1 1 0 010-1.788l1.53-.765a1 1 0 00.553-.812l.109-1.71z"/></svg>
      Parametres
    </a>
  </nav>

  <div class="mt-10 rounded-2xl border border-slate-200 bg-slate-50 p-4 text-sm text-slate-600">
    <p class="font-semibold text-slate-800">Espace editorial</p>
    <p class="mt-1">Publiez, structurez et suivez vos contenus depuis une interface unifiee.</p>
  </div>
</aside>
