<form action="<?= esc($action) ?>" method="post">
    <?= csrf_field() ?>
    <input type="hidden" name="tournament_id" value="<?= esc((string) $tournament['id']) ?>">

    <!-- TAMBAHAN: DROPDOWN STAGE -->
    <div class="mb-3">
        <label class="form-label text-muted fw-bold" style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">Tahapan (Stage)</label>
        <select class="form-select" name="stage" style="border-radius: 0; border-color: var(--app-border-strong);" required>
            <option value="kualifikasi" <?= old('stage', $pot['stage'] ?? 'kualifikasi') === 'kualifikasi' ? 'selected' : '' ?>>Kualifikasi</option>
            <option value="semifinal" <?= old('stage', $pot['stage'] ?? '') === 'semifinal' ? 'selected' : '' ?>>Semifinal</option>
            <option value="grandfinal" <?= old('stage', $pot['stage'] ?? '') === 'grandfinal' ? 'selected' : '' ?>>Grand Final</option>
        </select>
    </div>

    <div class="mb-3">
        <label class="form-label text-muted fw-bold" style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">Nama Pot</label>
        <input
            type="text"
            class="form-control"
            name="name"
            value="<?= esc(old('name', $pot['name'] ?? '')) ?>"
            placeholder="Contoh: POT 1"
            style="border-radius: 0; border-color: var(--app-border-strong);"
            required
        >
    </div>

    <div class="mb-4">
        <label class="form-label text-muted fw-bold" style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">Urutan (Sort Order)</label>
        <input
            type="number"
            class="form-control"
            name="sort_order"
            min="0"
            value="<?= esc(old('sort_order', $pot['sort_order'] ?? 0)) ?>"
            style="border-radius: 0; border-color: var(--app-border-strong);"
        >
    </div>

    <button type="submit" class="btn btn-primary w-100 fw-bold" style="border-radius: 0;"><?= esc($submitLabel) ?></button>
</form>