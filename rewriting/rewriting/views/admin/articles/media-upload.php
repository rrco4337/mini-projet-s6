<?php
/**
 * Composant de upload multi-fichiers avec prévisualisation
 */
$uploadedMedias = [];
if ($isEdit && isset($articleId)) {
    require_once __DIR__ . '/../../services/ArticleMediaService.php';
    $uploadedMedias = ArticleMediaService::getArticleMedias((int) $articleId);
}
?>

<div class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
  <h2 class="text-lg font-semibold text-slate-900 mb-4">📸 Galerie Photos</h2>

  <!-- Zone de drop et input -->
  <div id="uploadDropZone" class="rounded-xl border-2 border-dashed border-slate-300 bg-slate-50 p-8 text-center transition hover:border-blue-400 hover:bg-blue-50 cursor-pointer">
    <svg class="mx-auto h-12 w-12 text-slate-400 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v16m8-8H4"></path>
    </svg>
    <p class="text-sm font-semibold text-slate-700">Cliquez ou glissez des images</p>
    <p class="text-xs text-slate-500 mt-1">Formats: JPG, PNG, GIF, WebP • Max 5 Mo par image</p>
    <input 
      type="file" 
      id="images" 
      name="images" 
      accept="image/jpeg,image/png,image/gif,image/webp"
      multiple
      class="sr-only"
    />
  </div>

  <div class="mt-4" id="previewContainer">
    <!-- Les aperçus vont s'afficher ici -->
  </div>

  <!-- Images déjà uploadées -->
  <?php if (!empty($uploadedMedias)): ?>
    <div class="mt-6 border-t border-slate-200 pt-6">
      <h3 class="text-sm font-semibold text-slate-700 mb-3">Images actuelles</h3>
      <div class="grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4">
        <?php foreach ($uploadedMedias as $media): ?>
          <div class="group relative rounded-lg border border-slate-200 overflow-hidden bg-slate-50 hover:shadow-md transition">
            <img 
              src="<?= e($media['url']) ?>" 
              alt="<?= e($media['alt']) ?>"
              class="w-full h-24 object-cover"
            />
            <div class="absolute inset-0 bg-black/0 group-hover:bg-black/40 transition flex items-center justify-center opacity-0 group-hover:opacity-100">
              <button 
                type="button"
                data-media-id="<?= $media['id'] ?>"
                class="delete-media-btn rounded-full bg-red-600 p-2 text-white hover:bg-red-700 transition"
                title="Supprimer cette image"
              >
                <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 112 0V8a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                </svg>
              </button>
            </div>
            <p class="text-xs text-slate-500 p-2 truncate"><?= e($media['alt']) ?></p>
          </div>
        <?php endforeach; ?>
      </div>
    </div>
  <?php endif; ?>

  <!-- Textes alternatifs -->
  <div class="mt-4">
    <label for="imageAlts" class="mb-2 block text-sm font-semibold text-slate-700">Textes alternatifs (alt) et titres</label>
    <textarea 
      id="imageAlts" 
      name="imageAlts" 
      rows="4" 
      placeholder="Une ligne par image: alt1&#10;alt2&#10;alt3"
      class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition placeholder:text-slate-400 focus:border-blue-300 focus:bg-white"
    ></textarea>
    <p class="mt-1 text-xs text-slate-500">📝 Saisissez un texte alternatif par ligne (ordre identique aux uploads).</p>
  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const dropZone = document.getElementById('uploadDropZone');
  const fileInput = document.getElementById('images');
  const previewContainer = document.getElementById('previewContainer');

  // Ouvrir le dialogue de sélection
  dropZone.addEventListener('click', () => fileInput.click());

  // Drag and drop
  dropZone.addEventListener('dragover', (e) => {
    e.preventDefault();
    dropZone.classList.add('border-blue-400', 'bg-blue-50');
  });

  dropZone.addEventListener('dragleave', () => {
    dropZone.classList.remove('border-blue-400', 'bg-blue-50');
  });

  dropZone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropZone.classList.remove('border-blue-400', 'bg-blue-50');
    fileInput.files = e.dataTransfer.files;
    updatePreview();
  });

  // Prévisualisation en temps réel
  fileInput.addEventListener('change', updatePreview);

  function updatePreview() {
    previewContainer.innerHTML = '';

    if (fileInput.files.length === 0) {
      return;
    }

    const previewGrid = document.createElement('div');
    previewGrid.className = 'mt-4 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4';

    Array.from(fileInput.files).forEach((file, index) => {
      const reader = new FileReader();
      
      reader.onload = (e) => {
        const preview = document.createElement('div');
        preview.className = 'relative rounded-lg border border-slate-200 overflow-hidden bg-slate-50';
        
        const img = document.createElement('img');
        img.src = e.target.result;
        img.alt = file.name;
        img.className = 'w-full h-24 object-cover';

        const fileInfo = document.createElement('div');
        fileInfo.className = 'absolute bottom-0 left-0 right-0 bg-image black/80 text-white text-xs p-2 truncate';
        fileInfo.textContent = file.name + ' (' + formatBytes(file.size) + ')';

        preview.appendChild(img);
        preview.appendChild(fileInfo);
        previewGrid.appendChild(preview);
      };
      
      reader.readAsDataURL(file);
    });

    previewContainer.appendChild(previewGrid);
  }

  function formatBytes(bytes, decimals = 2) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
  }

  // Supprimer une image existante (AJAX)
  document.querySelectorAll('.delete-media-btn').forEach(btn => {
    btn.addEventListener('click', async (e) => {
      e.preventDefault();
      if (!confirm('Êtes-vous sûr de vouloir supprimer cette image ?')) return;

      const mediaId = btn.dataset.mediaId;
      const articleId = new URLSearchParams(window.location.search).get('id') || '<?= $articleId ?? '' ?>';

      try {
        const response = await fetch(`<?= url('admin/articles/media') ?>/${mediaId}`, {
          method: 'DELETE',
          headers: { 'Content-Type': 'application/json' }
        });

        if (response.ok) {
          btn.closest('[role="img"]').parentElement.remove();
          alert('Image supprimée');
        }
      } catch (err) {
        alert('Erreur lors de la suppression');
        console.error(err);
      }
    });
  });
});
</script>
