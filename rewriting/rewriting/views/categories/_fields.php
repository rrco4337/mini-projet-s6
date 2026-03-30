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
  <label class="mb-2 block text-sm font-semibold text-slate-700" for="nom">Nom</label>
  <input type="text" name="nom" id="nom" maxlength="100" value="<?= e($form['nom'] ?? '') ?>" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" required />
</div>

<div>
  <label class="mb-2 block text-sm font-semibold text-slate-700" for="slug">Slug</label>
  <input type="text" name="slug" id="slug" maxlength="110" value="<?= e($form['slug'] ?? '') ?>" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" required />
  <p class="mt-1 text-xs text-slate-500">Exemple: diplomatie</p>
</div>

<div>
  <label class="mb-2 block text-sm font-semibold text-slate-700" for="description">Description</label>
  <textarea name="description" id="description" rows="4" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white"><?= e($form['description'] ?? '') ?></textarea>
</div>

<div class="flex flex-wrap gap-3 pt-2">
  <button type="submit" class="rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Enregistrer</button>
  <a href="<?= url('categories') ?>" class="rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">Annuler</a>
</div>
