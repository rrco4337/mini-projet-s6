<?php
/**
 * Formulaire article (create/edit)
 */
$isEdit = ($mode ?? 'create') === 'edit';
$form = $articleForm ?? [];
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><?= $isEdit ? 'Modifier' : 'Creer' ?> un article - BackOffice</title>
  <meta name="description" content="Formulaire backoffice pour creer ou modifier un article Iran War News." />
  <meta name="keywords" content="formulaire article, administration, iran war news" />
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = { theme: { extend: { fontFamily: { sans: ['Plus Jakarta Sans', 'sans-serif'] }, boxShadow: { soft: '0 10px 30px rgba(15, 23, 42, 0.08)' } } } };
  </script>
  <style>body { background: radial-gradient(circle at 12% 14%, rgba(37, 99, 235, 0.08), transparent 30%), #f6f8fb; }</style>
</head>
<body class="min-h-screen font-sans text-slate-800">
<div class="flex min-h-screen">
  <?php include __DIR__ . '/../../includes/admin_sidebar.php'; ?>

  <div class="w-full xl:ml-72">
    <?php
    $adminHeaderMode = 'simple';
    $adminSearchPlaceholder = 'Rechercher...';
    $adminHeaderButtons = [
      ['href' => url('/'), 'label' => 'Voir le site', 'target' => '_blank', 'class' => 'hidden rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50 md:inline-flex'],
      ['href' => url('logout'), 'label' => 'Deconnexion', 'class' => 'rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50'],
    ];
    include __DIR__ . '/../../includes/admin_header.php';
    ?>

    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div class="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold tracking-tight text-slate-900"><?= $isEdit ? 'Modifier' : 'Creer' ?> un article</h1>
          <p class="mt-2 text-sm text-slate-600">Renseignez les informations editoriales, SEO et taxonomie avant publication.</p>
        </div>
        <a href="<?= url('admin/articles') ?>" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Retour a la liste</a>
      </div>

      <div class="grid gap-6 lg:grid-cols-3">
        <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft lg:col-span-2">
          <form action="<?= $isEdit ? url('admin/articles/' . $articleId) : url('admin/articles') ?>" method="post" enctype="multipart/form-data" class="space-y-5">

            <?php if (!empty($errors)): ?>
              <div class="rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800">
                <ul class="list-disc pl-4">
                  <?php foreach ($errors as $error): ?>
                    <li><?= e($error) ?></li>
                  <?php endforeach; ?>
                </ul>
              </div>
            <?php endif; ?>

            <div>
              <label for="titre" class="mb-2 block text-sm font-semibold text-slate-700">Titre *</label>
              <input type="text" name="titre" id="titre" maxlength="255" value="<?= e($form['titre'] ?? '') ?>" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" required />
            </div>

            <div>
              <label for="slug" class="mb-2 block text-sm font-semibold text-slate-700">Slug (URL) *</label>
              <div class="flex rounded-xl border border-slate-200 bg-slate-50 focus-within:border-blue-300 focus-within:bg-white">
                <span class="inline-flex items-center border-r border-slate-200 px-4 text-sm text-slate-500">/article/</span>
                <input type="text" name="slug" id="slug" maxlength="270" value="<?= e($form['slug'] ?? '') ?>" class="h-11 w-full bg-transparent px-3 text-sm outline-none" required />
              </div>
              <p class="mt-1 text-xs text-slate-500">Utiliser des lettres minuscules, chiffres et tirets.</p>
            </div>

            <div>
              <label for="sousTitre" class="mb-2 block text-sm font-semibold text-slate-700">Sous-titre</label>
              <input type="text" name="sousTitre" id="sousTitre" maxlength="255" value="<?= e($form['sousTitre'] ?? '') ?>" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
            </div>

            <div>
              <label for="chapeau" class="mb-2 block text-sm font-semibold text-slate-700">Chapeau</label>
              <textarea name="chapeau" id="chapeau" rows="3" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white"><?= e($form['chapeau'] ?? '') ?></textarea>
              <p class="mt-1 text-xs text-slate-500">Resume affiche en introduction.</p>
            </div>

            <div>
              <label for="contenu" class="mb-2 block text-sm font-semibold text-slate-700">Contenu *</label>
              <textarea name="contenu" id="contenu" rows="12" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white" required><?= e($form['contenu'] ?? '') ?></textarea>
              <p class="mt-1 text-xs text-slate-500">HTML autorise.</p>
            </div>

            <div>
              <label for="images" class="mb-2 block text-sm font-semibold text-slate-700">Images</label>
              <input type="file" id="images" name="images" accept="image/*" multiple class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm file:mr-4 file:rounded-lg file:border-0 file:bg-slate-900 file:px-3 file:py-2 file:text-xs file:font-semibold file:text-white" />
              <p class="mt-1 text-xs text-slate-500">Formats image uniquement, 5 Mo maximum par fichier.</p>
            </div>

            <div>
              <label for="imageAlts" class="mb-2 block text-sm font-semibold text-slate-700">Texte alternatif (alt)</label>
              <textarea id="imageAlts" name="imageAlts" rows="3" placeholder="Un texte alt par ligne, dans le meme ordre que les images" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white"></textarea>
              <p class="mt-1 text-xs text-slate-500">Ligne 1 = alt image 1, ligne 2 = alt image 2.</p>
            </div>

            <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
              <h2 class="text-sm font-semibold uppercase tracking-wide text-slate-600">SEO</h2>

              <div class="mt-4 space-y-4">
                <div>
                  <label for="metaTitle" class="mb-2 block text-sm font-semibold text-slate-700">Meta Title</label>
                  <input type="text" name="metaTitle" id="metaTitle" maxlength="70" value="<?= e($form['metaTitle'] ?? '') ?>" class="h-11 w-full rounded-xl border border-slate-200 bg-white px-4 text-sm outline-none transition focus:border-blue-300" />
                  <p class="mt-1 text-xs text-slate-500"><span id="metaTitleCount">0</span>/70 caracteres</p>
                </div>

                <div>
                  <label for="metaDescription" class="mb-2 block text-sm font-semibold text-slate-700">Meta Description</label>
                  <textarea name="metaDescription" id="metaDescription" rows="2" maxlength="165" class="w-full rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none transition focus:border-blue-300"><?= e($form['metaDescription'] ?? '') ?></textarea>
                  <p class="mt-1 text-xs text-slate-500"><span id="metaDescCount">0</span>/165 caracteres</p>
                </div>

                <div>
                  <label for="metaKeywords" class="mb-2 block text-sm font-semibold text-slate-700">Meta Keywords</label>
                  <input type="text" name="metaKeywords" id="metaKeywords" maxlength="255" value="<?= e($form['metaKeywords'] ?? '') ?>" class="h-11 w-full rounded-xl border border-slate-200 bg-white px-4 text-sm outline-none transition focus:border-blue-300" />
                </div>
              </div>
            </div>

            <div class="grid gap-4 md:grid-cols-2">
              <div>
                <label class="mb-2 block text-sm font-semibold text-slate-700">Categories</label>
                <div class="rounded-2xl border border-slate-200 bg-slate-50 p-3">
                  <div class="flex flex-wrap gap-2">
                    <?php
                    $selectedCatIds = $form['categorieIds'] ?? [];
                    foreach ($categories as $cat):
                      $isSelected = in_array($cat['id'], $selectedCatIds);
                    ?>
                      <label class="cursor-pointer">
                        <input type="checkbox" name="categorieIds[]" value="<?= $cat['id'] ?>" class="peer sr-only" <?= $isSelected ? 'checked' : '' ?> />
                        <span class="inline-flex items-center rounded-full border border-slate-300 bg-white px-3 py-1.5 text-sm font-medium text-slate-700 transition hover:border-blue-200 hover:bg-blue-50 peer-checked:border-blue-600 peer-checked:bg-blue-600 peer-checked:text-white">
                          <?= e($cat['nom']) ?>
                        </span>
                      </label>
                    <?php endforeach; ?>
                  </div>
                </div>
                <p class="mt-1 text-xs text-slate-500">Cliquez sur les tags pour ajouter ou retirer des categories.</p>
              </div>

              <div>
                <label for="statut" class="mb-2 block text-sm font-semibold text-slate-700">Statut</label>
                <select name="statut" id="statut" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white">
                  <?php foreach ($statuts as $s): ?>
                    <option value="<?= $s ?>" <?= ($form['statut'] ?? 'brouillon') === $s ? 'selected' : '' ?>><?= $s ?></option>
                  <?php endforeach; ?>
                </select>
              </div>
            </div>

            <label for="aLaUne" class="flex items-center gap-2 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm font-medium text-slate-700 cursor-pointer">
              <input type="checkbox" name="ALaUne" id="aLaUne" value="1" class="h-4 w-4 rounded border-slate-300 text-blue-600" <?= !empty($form['ALaUne']) ? 'checked' : '' ?> />
              Mettre a la une
            </label>

            <div class="flex flex-wrap gap-3 pt-2">
              <button type="submit" class="rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700"><?= $isEdit ? 'Enregistrer' : 'Creer' ?></button>
              <a href="<?= url('admin/articles') ?>" class="rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">Annuler</a>
            </div>
          </form>
        </section>

        <aside class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
          <h2 class="text-lg font-semibold text-slate-900">Aide de redaction</h2>
          <div class="mt-4 space-y-4 text-sm text-slate-600">
            <p><span class="font-semibold text-slate-800">Titre :</span> titre principal de l'article.</p>
            <p><span class="font-semibold text-slate-800">Slug :</span> URL unique. Exemple: mon-article-2024.</p>
            <p><span class="font-semibold text-slate-800">Chapeau :</span> introduction resumee.</p>
            <p><span class="font-semibold text-slate-800">Contenu :</span> corps de l'article (HTML accepte).</p>
            <hr class="border-slate-200" />
            <p><span class="font-semibold text-slate-800">Meta Title :</span> 70 caracteres max.</p>
            <p><span class="font-semibold text-slate-800">Meta Description :</span> 165 caracteres max.</p>
            <hr class="border-slate-200" />
            <p class="font-semibold text-slate-800">Statuts :</p>
            <ul class="list-disc space-y-1 pl-5">
              <li><span class="font-semibold">brouillon</span> - Non visible</li>
              <li><span class="font-semibold">publie</span> - Visible sur le site</li>
              <li><span class="font-semibold">archive</span> - Non visible</li>
            </ul>
          </div>
        </aside>
      </div>
    </main>
  </div>
</div>

<script>
  function updateCount(inputId, countId) {
    const input = document.getElementById(inputId);
    const count = document.getElementById(countId);
    if (input && count) {
      count.textContent = input.value.length;
      input.addEventListener('input', () => { count.textContent = input.value.length; });
    }
  }

  updateCount('metaTitle', 'metaTitleCount');
  updateCount('metaDescription', 'metaDescCount');

  const titleInput = document.getElementById('titre');
  const slugInput = document.getElementById('slug');

  if (titleInput && slugInput) {
    titleInput.addEventListener('input', function() {
      if (!slugInput.value || slugInput.dataset.autoGenerated === 'true') {
        const slug = this.value.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
        slugInput.value = slug;
        slugInput.dataset.autoGenerated = 'true';
      }
    });
    slugInput.addEventListener('input', function() { this.dataset.autoGenerated = 'false'; });
  }
</script>
</body>
</html>
