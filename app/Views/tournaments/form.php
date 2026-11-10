<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<style>
    /* MEMATIKAN SEMUA LENGKUNGAN BOOTSTRAP */
    .t-form-card, .form-control, .form-select, .btn, .input-group-text {
        border-radius: 0 !important; 
    }
    
    .t-form-card {
        background: var(--app-surface);
        border: 1px solid var(--app-border-strong);
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        box-shadow: none;
    }
    
    .t-form-card-title {
        font-size: 1rem;
        font-weight: 800;
        color: var(--app-text);
        text-transform: uppercase;
        letter-spacing: 0.05em;
        margin-bottom: 1.25rem;
        padding-bottom: 0.75rem;
        border-bottom: 1px solid var(--app-border);
    }

    .t-input {
        border: 1px solid var(--app-border-strong);
        background: var(--app-surface-2);
        color: var(--app-text);
        min-height: 42px;
    }

    .t-input:focus {
        border-color: var(--app-primary);
        box-shadow: none;
        background: var(--app-surface-3);
    }

    .btn-sharp {
        font-weight: 700;
        letter-spacing: 0.02em;
        padding: 0.6rem 1.5rem;
    }
</style>

<div class="page-header d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 mb-1 text-white"><?= esc($formTitle) ?></h1>
        <p class="text-muted mb-0" style="font-size: 0.9rem;">Pusat kendali informasi dan aturan main turnamen.</p>
    </div>
    <a href="<?= site_url('dashboard') ?>" class="btn btn-outline-secondary btn-sharp">Kembali</a>
</div>

<div class="row">
    <div class="col-lg-8">
        <form action="<?= esc($action) ?>" method="post">
            <?= csrf_field() ?>
            
            <!-- BLOK 1: INFORMASI DASAR -->
            <div class="t-form-card">
                <h2 class="t-form-card-title">Informasi Dasar</h2>
                <div class="mb-4">
                    <label class="form-label text-muted fw-semibold">Nama Tournament</label>
                    <input type="text" class="form-control t-input" name="name" value="<?= esc(old('name', $tournament['name'] ?? '')) ?>" required>
                </div>
                <div class="mb-2">
                    <label class="form-label text-muted fw-semibold">Status Saat Ini</label>
                    <select class="form-select t-input" name="status" required>
                        <?php foreach ($statusOptions as $value => $label): ?>
                            <option value="<?= esc($value) ?>" <?= old('status', $tournament['status'] ?? 'belum_mulai') === $value ? 'selected' : '' ?>><?= esc($label) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
            </div>

            <!-- BLOK 2: FORMAT & PERHITUNGAN POIN -->
<div class="t-form-card">
                <h2 class="t-form-card-title">Format Poin & Aturan</h2>
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label text-muted fw-semibold">Sistem Distribusi Poin</label>
                        <select class="form-select t-input" name="point_system" id="pointSystemSelect">
                            <option value="ffws" <?= old('point_system', $tournament['point_system'] ?? 'ffws') === 'ffws' ? 'selected' : '' ?>>Standar FFWS (12,9,8...)</option>
                            <option value="custom" <?= old('point_system', $tournament['point_system'] ?? '') === 'custom' ? 'selected' : '' ?>>Custom / Manual</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted fw-semibold">Poin Per Kill</label>
                        <input type="number" class="form-control t-input" name="kill_points" value="<?= esc(old('kill_points', $tournament['kill_points'] ?? 1)) ?>" min="1" required>
                    </div>
                    
                    <!-- INPUT CUSTOM POINTS (Disembunyikan jika FFWS) -->
                    <div class="col-12" id="customPointsDiv" <?= old('point_system', $tournament['point_system'] ?? 'ffws') === 'ffws' ? 'style="display: none;"' : '' ?>>
                        <label class="form-label text-muted fw-semibold">Urutan Poin Placement Custom</label>
                        <input type="text" class="form-control t-input" name="custom_placement_points" value="<?= esc(old('custom_placement_points', $tournament['custom_placement_points'] ?? '')) ?>" placeholder="Contoh: 25, 20, 15, 10, 8, 6, 4, 3, 2, 1, 0, 0">
                        <div class="form-text text-muted" style="font-size: 0.8rem;">Pisahkan setiap poin menggunakan koma (,). Tulis urut dari juara 1 sampai selesai.</div>
                    </div>
                </div>
            </div>

            <!-- BLOK 3: STRUKTUR POT -->
            <div class="t-form-card">
                <h2 class="t-form-card-title">Struktur Default Pot</h2>
                <div class="row g-3 mb-2">
                    <div class="col-md-6">
                        <label class="form-label text-muted fw-semibold">Default Jumlah Game/Match</label>
                        <input type="number" class="form-control t-input" name="default_game_count" value="<?= esc(old('default_game_count', $tournament['default_game_count'] ?? 5)) ?>" min="1" max="20" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted fw-semibold">Batas Tim Per Pot</label>
                        <input type="number" class="form-control t-input" name="max_teams_per_pot" value="<?= esc(old('max_teams_per_pot', $tournament['max_teams_per_pot'] ?? 12)) ?>" min="2" max="50" required>
                    </div>
                </div>
                <div class="form-text text-muted mt-3" style="font-size: 0.8rem;">Pengaturan ini akan digunakan sebagai cetakan awal setiap kali Anda membuat Pot baru di dalam turnamen ini.</div>
            </div>

            <div class="d-flex gap-2 mt-2 mb-5">
                <button type="submit" class="btn btn-primary btn-sharp px-4"><?= esc($submitLabel) ?></button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('pointSystemSelect').addEventListener('change', function() {
        if(this.value === 'custom') {
            document.getElementById('customPointsDiv').style.display = 'block';
        } else {
            document.getElementById('customPointsDiv').style.display = 'none';
        }
    });
</script>

<?= $this->endSection() ?>