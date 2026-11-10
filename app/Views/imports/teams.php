<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<!-- FIX BUG SCROLL TRAP: Menghancurkan semua batasan tinggi dan scroll internal -->
<style>
    .import-manager-panel .team-manager-workspace,
    .import-manager-panel .team-manager-card,
    .import-manager-panel .team-manager-cms-card,
    .import-manager-panel .team-manager-body,
    .import-manager-panel .team-manager-cms-body,
    .import-manager-panel .team-manager-form-shell,
    .import-manager-panel .team-manager-list-shell,
    .import-manager-panel .team-manager-list {
        position: static !important;
        display: block !important;
        height: auto !important;
        min-height: 0 !important;
        max-height: none !important;
        overflow: visible !important;
        overscroll-behavior: auto !important;
    }

    .import-format-guide {
        background: var(--app-surface, #0f1a29);
        border: 1px solid var(--app-border, #26415f);
        border-radius: 8px;
    }
    .import-format-box {
        background: var(--app-surface-2, #142133);
        border: 1px solid var(--app-border, #26415f);
        border-radius: 6px;
        padding: 0.85rem;
        height: 100%;
    }
    .import-badge-code {
        font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
        font-size: 0.76rem;
        padding: 0.2rem 0.4rem;
        background: rgba(59, 130, 246, 0.15);
        color: #93c5fd;
        border: 1px solid rgba(59, 130, 246, 0.3);
        border-radius: 4px;
        display: inline-block;
        margin: 2px 2px 2px 0;
    }
</style>

<div class="import-page import-page-stacked import-page-ergonomic import-page-compact">
    <div class="page-header import-page-header">
        <div class="page-title-block">
            <h1 class="h3 mb-1">Import Teams</h1>
            <p class="text-muted small mb-0">Upload file Excel atau CSV untuk memasukkan tim ke turnamen secara massal.</p>
        </div>
        <a href="<?= site_url('dashboard') ?>" class="btn btn-outline-secondary btn-sm app-btn">Kembali</a>
    </div>

    <!-- PANDUAN FORMAT EXCEL / CSV -->
    <div class="card import-format-guide mb-3">
        <div class="card-header bg-transparent border-bottom d-flex justify-content-between align-items-center py-2 px-3">
            <div class="d-flex align-items-center gap-2">
                <span class="badge text-bg-primary">Panduan Format</span>
                <span class="fw-semibold text-light small">Struktur Header Kolom yang Diterima (.xlsx, .csv, .txt)</span>
            </div>
            <span class="text-muted small">Maksimal 6 pemain per tim</span>
        </div>
        <div class="card-body p-3">
            <div class="row g-3">
                <div class="col-lg-6">
                    <div class="import-format-box">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="fw-bold text-info small">1. FORMAT STANDAR SISTEM</span>
                            <span class="badge bg-secondary-subtle text-secondary border small">Default</span>
                        </div>
                        <p class="text-muted small mb-2">Gunakan susunan header baku berikut pada baris pertama spreadsheet Anda:</p>
                        <div class="mb-2">
                            <div class="text-secondary small fw-semibold mb-1">Info Tim & Kontak:</div>
                            <span class="import-badge-code">team_name</span>
                            <span class="import-badge-code">leader_name</span>
                            <span class="import-badge-code">whatsapp</span>
                            <span class="import-badge-code">email</span>
                            <span class="import-badge-code">notes</span>
                        </div>
                        <div>
                            <div class="text-secondary small fw-semibold mb-1">Pemain (Roster):</div>
                            <span class="import-badge-code">player_1_name</span>
                            <span class="import-badge-code">player_2_name</span>
                            <span class="import-badge-code">player_3_name</span>
                            <span class="import-badge-code">player_4_name</span>
                            <span class="import-badge-code">player_5_name</span>
                            <span class="import-badge-code">player_6_name</span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="import-format-box">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="fw-bold text-success small">2. FORMAT RESPONS GOOGLE FORM</span>
                            <span class="badge bg-success-subtle text-success border small">Auto-Detect</span>
                        </div>
                        <p class="text-muted small mb-2">Langsung upload file hasil ekspor Google Form formulir pendaftaran:</p>
                        <div class="mb-2">
                            <div class="text-secondary small fw-semibold mb-1">Header Form yang Dikenali:</div>
                            <span class="import-badge-code">nama_team</span>
                            <span class="import-badge-code">nick_captain</span>
                            <span class="import-badge-code">no_wa</span>
                            <span class="import-badge-code">email</span>
                            <span class="import-badge-code">bukti_pembayaran</span>
                        </div>
                        <div>
                            <div class="text-secondary small fw-semibold mb-1">Header Nick Player Form:</div>
                            <span class="import-badge-code">nick_player_1</span>
                            <span class="import-badge-code">nick_player_2</span>
                            <span class="import-badge-code">nick_player_3</span>
                            <span class="import-badge-code">nick_player_4</span>
                            <span class="import-badge-code">nick_player_5</span>
                            <span class="import-badge-code">nick_player_6</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mt-2 text-muted small">
                <i class="small">Catatan: Jika nama tim sudah ada di database, data anggota akan disinkronkan secara otomatis tanpa duplikasi.</i>
            </div>
        </div>
    </div>

    <div class="import-workspace-grid">
        <div class="card import-card import-control-card">
            <div class="card-header import-card-header">
                <h2 class="h5 mb-0">Upload</h2>
            </div>
            <div class="card-body import-card-body">
                <form action="<?= site_url('imports/teams') ?>" method="post" enctype="multipart/form-data" class="import-upload-form js-import-upload-form" data-default-mode="global">
                    <?= csrf_field() ?>

                    <div class="row g-2 align-items-start import-upload-grid import-upload-grid-compact">
                        <div class="col-12">
                            <label class="form-label">Tournament</label>
                            <select name="tournament_id" class="form-select form-select-sm js-import-page-tournament-select">
                                <option value="">Pilih tournament</option>
                                <?php foreach ($tournaments as $tournament): ?>
                                    <option value="<?= esc((string) $tournament['id']) ?>" <?= (int) old('tournament_id', $selectedTournamentId) === (int) $tournament['id'] ? 'selected' : '' ?>>
                                        <?= esc($tournament['name']) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                            <div class="form-text">Pilih tournament dulu, lalu pengaturan sisanya cukup lewat team manager.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Penempatan Awal</label>
                            <select name="import_mode" class="form-select form-select-sm js-import-mode-select">
                                <option value="global" <?= old('import_mode', 'global') === 'global' ? 'selected' : '' ?>>Belum Masuk Pot</option>
                                <option value="with_pot" <?= old('import_mode') === 'with_pot' ? 'selected' : '' ?>>Langsung ke Pot</option>
                            </select>
                        </div>

                        <div class="col-md-6 js-import-pot-group" hidden>
                            <label class="form-label">Pot (Berdasarkan Stage)</label>
                            <select name="pot_id" class="form-select form-select-sm js-import-pot-select">
                                <option value="">Pilih pot</option>
                                <?php
                                $stageLabels = [
                                    'kualifikasi' => 'Kualifikasi',
                                    'semifinal'   => 'Semifinal',
                                    'grandfinal'  => 'Grand Final',
                                ];

                                // Kelompokkan pots berdasarkan Stage
                                $groupedPots = [];
                                foreach ($pots as $pot) {
                                    $stageKey = strtolower(trim((string) ($pot['stage'] ?? 'kualifikasi')));
                                    $stageTitle = $stageLabels[$stageKey] ?? ucfirst($stageKey !== '' ? $stageKey : 'Kualifikasi');
                                    $groupedPots[$stageTitle][] = $pot;
                                }
                                ?>
                                <?php if ($groupedPots !== []): ?>
                                    <?php foreach ($groupedPots as $stageTitle => $potsInStage): ?>
                                        <optgroup label="<?= esc($stageTitle) ?>">
                                            <?php foreach ($potsInStage as $pot): ?>
                                                <?php
                                                $potLabel = '[' . $stageTitle . '] - ' . $pot['name'];
                                                ?>
                                                <option value="<?= esc((string) $pot['id']) ?>" <?= (int) old('pot_id', $selectedPotId) === (int) $pot['id'] ? 'selected' : '' ?>>
                                                    <?= esc($potLabel) ?>
                                                </option>
                                            <?php endforeach; ?>
                                        </optgroup>
                                    <?php endforeach; ?>
                                <?php else: ?>
                                    <?php foreach ($pots as $pot): ?>
                                        <?php
                                        $stageKey = strtolower(trim((string) ($pot['stage'] ?? 'kualifikasi')));
                                        $stageTitle = $stageLabels[$stageKey] ?? ucfirst($stageKey !== '' ? $stageKey : 'Kualifikasi');
                                        $potLabel = '[' . $stageTitle . '] - ' . $pot['name'];
                                        ?>
                                        <option value="<?= esc((string) $pot['id']) ?>" <?= (int) old('pot_id', $selectedPotId) === (int) $pot['id'] ? 'selected' : '' ?>>
                                            <?= esc($potLabel) ?>
                                        </option>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label">File</label>
                            <input type="file" class="form-control" name="team_file" accept=".csv,.txt,.xlsx" required>
                        </div>
                    </div>

                    <div class="d-grid mt-2">
                        <button type="submit" class="btn btn-primary btn-sm app-btn">Import</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="import-manager-panel">
            <?= view('teams/_manager_workspace', [
                'managerId'            => 'import-manual-manager',
                'managerContext'       => 'import',
                'managerTitle'         => 'Teams',
                'managerDescription'   => '',
                'tournaments'          => $tournaments,
                'pots'                 => $pots,
                'selectedTournamentId' => $selectedTournamentId,
                'selectedPotId'        => $selectedPotId,
                'currentTournamentId'  => $selectedTournamentId,
                'currentPotId'         => $selectedPotId,
                'canManage'            => true,
                'allowUnassigned'      => true,
                'showTournamentFilter' => false,
                'fixedTournamentId'    => $selectedTournamentId,
            ]) ?>
        </div>
    </div>
</div>

<script {csp-script-nonce}>
document.addEventListener('DOMContentLoaded', () => {
    const form = document.querySelector('.js-import-upload-form');
    if (!form) {
        return;
    }

    const modeSelect = form.querySelector('.js-import-mode-select');
    const tournamentSelect = form.querySelector('.js-import-page-tournament-select');
    const potGroups = Array.from(form.querySelectorAll('.js-import-pot-group'));

    const syncMode = () => {
        const needsPot = String(modeSelect?.value || 'global') === 'with_pot';
        potGroups.forEach((group) => {
            group.hidden = !needsPot;
        });
    };

    tournamentSelect?.addEventListener('change', () => {
        const value = String(tournamentSelect.value || '').trim();
        const url = new URL(window.location.href);

        if (value === '') {
            url.searchParams.delete('tournament_id');
            url.searchParams.delete('pot_id');
        } else {
            url.searchParams.set('tournament_id', value);
            url.searchParams.delete('pot_id');
        }

        window.location.href = url.toString();
    });

    modeSelect?.addEventListener('change', syncMode);
    syncMode();
});
</script>
<?= $this->endSection() ?>