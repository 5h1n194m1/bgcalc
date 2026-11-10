<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<style <?= function_exists('csp_style_nonce') ? csp_style_nonce() : '' ?>>
    /* =========================================================
       SHARP & ULTRA-SLIM SPREADSHEET AESTHETIC (ZERO RADIUS)
       ========================================================= */
    .roster-hub-page,
    .roster-hub-page *,
    .roster-hub-page .card,
    .roster-hub-page .card-header,
    .roster-hub-page .card-body,
    .roster-hub-page .card-footer,
    .roster-hub-page .form-control,
    .roster-hub-page .form-select,
    .roster-hub-page .btn,
    .roster-hub-page .nav-pills .nav-link,
    .roster-hub-page .badge,
    .roster-hub-page .alert,
    .roster-hub-page .modal-content,
    .roster-hub-page textarea,
    .roster-hub-page input,
    .roster-hub-page select {
        border-radius: 0 !important;
    }

    .roster-hub-page .hub-nav-tabs {
        border-bottom: 1px solid var(--app-border, #26415f);
        padding-bottom: 0.35rem;
    }
    .roster-hub-page .hub-nav-tabs .nav-link {
        background: var(--app-surface-2, #142133);
        border: 1px solid var(--app-border, #26415f);
        color: #94a3b8;
        padding: 0.35rem 0.9rem;
        font-weight: 600;
        font-size: 0.84rem;
        transition: none;
        display: inline-flex;
        align-items: center;
        gap: 0.35rem;
    }
    .roster-hub-page .hub-nav-tabs .nav-link:hover {
        background: #1a2c42;
        color: #f1f5f9;
        border-color: #3b82f6;
    }
    .roster-hub-page .hub-nav-tabs .nav-link.active {
        background: #2563eb;
        color: #ffffff;
        border-color: #3b82f6;
        box-shadow: none;
    }

    /* QUICK ADD MANUAL BAR */
    .roster-hub-page .quick-add-card {
        background: #0d1726;
        border: 1px solid #26415f;
        border-left: 4px solid #2563eb;
    }
    .roster-hub-page .quick-add-label {
        font-size: 0.7rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        color: #94a3b8;
        margin-bottom: 3px;
        display: block;
    }

    /* ULTRA SLIM TABLE */
    .roster-hub-page .roster-table {
        border-collapse: collapse !important;
        width: 100% !important;
    }
    .roster-hub-page .roster-table th,
    .roster-hub-page .roster-table td {
        padding: 0.25rem 0.45rem !important;
        vertical-align: middle !important;
        font-size: 0.82rem !important;
        line-height: 1.25 !important;
        border: 1px solid #1e3a5f !important;
    }
    .roster-hub-page .roster-table th {
        font-size: 0.74rem !important;
        text-transform: uppercase !important;
        letter-spacing: 0.04em !important;
        color: #94a3b8 !important;
        background: #0d1726 !important;
        font-weight: 700 !important;
        white-space: nowrap !important;
    }
    .roster-hub-page .roster-table tr:hover td {
        background-color: rgba(30, 41, 59, 0.45) !important;
    }
    .roster-hub-page .roster-row-modified td {
        background-color: rgba(59, 130, 246, 0.12) !important;
        border-left: 3px solid #3b82f6 !important;
    }

    /* INPUTS & SELECTS OVERRIDE (EXCEL COMPACT) */
    .roster-hub-page .roster-input,
    .roster-hub-page .roster-stage-select,
    .roster-hub-page .roster-tournament-select {
        background-color: #0b1320;
        border: 1px solid #26415f;
        color: #f8fafc;
        font-size: 0.82rem;
        height: 28px !important;
        min-height: 28px !important;
        padding: 0.15rem 0.4rem !important;
    }
    .roster-hub-page .roster-input:focus,
    .roster-hub-page .roster-stage-select:focus,
    .roster-hub-page .roster-tournament-select:focus {
        background-color: #0d1726;
        border-color: #3b82f6;
        color: #ffffff;
        box-shadow: none;
        outline: 1px solid #3b82f6;
    }
    .roster-hub-page textarea.roster-textarea {
        background-color: #0b1320;
        border: 1px solid #26415f;
        color: #f8fafc;
        font-size: 0.78rem;
        line-height: 1.2;
        resize: vertical;
        height: 36px !important;
        min-height: 36px !important;
        padding: 0.15rem 0.4rem !important;
    }
    .roster-hub-page textarea.roster-textarea:focus {
        background-color: #0d1726;
        border-color: #3b82f6;
        color: #ffffff;
        box-shadow: none;
        outline: 1px solid #3b82f6;
    }
    .roster-hub-page .roster-help {
        font-size: 0.68rem !important;
        color: #64748b;
        margin-top: 1px;
        line-height: 1.1;
    }
    .roster-hub-page .btn-sm {
        height: 28px !important;
        padding: 0.15rem 0.6rem !important;
        font-size: 0.76rem !important;
        line-height: 1.2 !important;
        font-weight: 600 !important;
    }

    /* Format Guide Cards */
    .roster-hub-page .import-format-guide {
        background: var(--app-surface, #0f1a29);
        border: 1px solid var(--app-border, #26415f);
    }
    .roster-hub-page .import-format-box {
        background: var(--app-surface-2, #142133);
        border: 1px solid var(--app-border, #26415f);
        padding: 0.75rem;
        height: 100%;
    }
    .roster-hub-page .import-badge-code {
        font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
        font-size: 0.72rem;
        padding: 0.15rem 0.35rem;
        background: rgba(59, 130, 246, 0.15);
        color: #93c5fd;
        border: 1px solid rgba(59, 130, 246, 0.3);
        display: inline-block;
        margin: 2px 2px 2px 0;
    }
    .roster-hub-page .stage-badge-sm {
        font-size: 0.68rem;
        padding: 0.1rem 0.35rem;
        font-weight: 700;
        display: inline-block;
    }
</style>

<div class="dashboard-page roster-page-shell roster-hub-page">
    
    <!-- PAGE HEADER -->
    <div class="page-header dashboard-page-header d-flex justify-content-between align-items-center flex-wrap gap-2 mb-2">
        <div class="page-title-block">
            <h1 class="h4 mb-0 text-white fw-bold">Team Management Hub</h1>
            <p class="text-muted mb-0" style="font-size: 0.82rem;">Kelola seluruh roster tim, tambah tim manual, penempatan pot pertandingan, dan import data massal.</p>
        </div>

        <div class="d-flex gap-2 align-items-end flex-wrap">
            <div class="roster-header-filter">
                <select class="form-select form-select-sm js-roster-tournament-filter rounded-0" style="min-width: 220px; height: 28px; font-size: 0.82rem;">
                    <option value="all" <?= (string) ($selectedTournamentKey ?? 'all') === 'all' ? 'selected' : '' ?>>Semua Tournament</option>
                    <option value="unassigned" <?= (string) ($selectedTournamentKey ?? 'all') === 'unassigned' ? 'selected' : '' ?>>Tim Tanpa Pot (Unassigned)</option>
                    <option value="none" <?= (string) ($selectedTournamentKey ?? 'all') === 'none' ? 'selected' : '' ?>>Belum Ada Tournament</option>
                    <?php foreach ($tournaments as $tournament): ?>
                        <option value="<?= esc((string) $tournament['id']) ?>" <?= (string) ($selectedTournamentKey ?? 'all') === (string) $tournament['id'] ? 'selected' : '' ?>>
                            <?= esc($tournament['name']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <?php if ((int) ($selectedTournamentId ?? 0) > 0): ?>
                <a href="<?= site_url('teams/export-template?tournament_id=' . (int) $selectedTournamentId) ?>" class="btn btn-outline-info btn-sm app-btn rounded-0 d-inline-flex align-items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" fill="currentColor" class="me-1" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                    Export CSV
                </a>
            <?php endif; ?>
        </div>
    </div>

    <!-- FLASH MESSAGES -->
    <?php if (session()->has('success')): ?>
        <div class="alert alert-success alert-dismissible fade show py-1 px-3 small d-flex align-items-center mb-2 rounded-0" role="alert">
            <span class="me-2">✓</span>
            <div><?= session('success') ?></div>
            <button type="button" class="btn-close btn-close-white ms-auto py-1" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <?php endif; ?>

    <?php if (session()->has('error')): ?>
        <div class="alert alert-danger alert-dismissible fade show py-1 px-3 small d-flex align-items-center mb-2 rounded-0" role="alert">
            <span class="me-2">⚠</span>
            <div><?= session('error') ?></div>
            <button type="button" class="btn-close btn-close-white ms-auto py-1" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <?php endif; ?>

    <?php if (session()->has('info')): ?>
        <div class="alert alert-info alert-dismissible fade show py-1 px-3 small d-flex align-items-center mb-2 rounded-0" role="alert">
            <span class="me-2">ℹ</span>
            <div><?= session('info') ?></div>
            <button type="button" class="btn-close btn-close-white ms-auto py-1" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <?php endif; ?>

    <!-- NAVIGATION TABS -->
    <ul class="nav nav-pills hub-nav-tabs mb-2 gap-1" id="hubTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-0 <?= ($activeTab ?? 'roster') !== 'import' ? 'active' : '' ?>" id="roster-tab" data-bs-toggle="pill" data-bs-target="#tab-roster" type="button" role="tab" aria-controls="tab-roster" aria-selected="<?= ($activeTab ?? 'roster') !== 'import' ? 'true' : 'false' ?>">
                <span>👥</span> Mass Roster Editor
                <span class="badge bg-secondary-subtle text-light ms-1 rounded-0"><?= esc((string) count($rows)) ?> Tim</span>
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-0 <?= ($activeTab ?? 'roster') === 'import' ? 'active' : '' ?>" id="import-tab" data-bs-toggle="pill" data-bs-target="#tab-import" type="button" role="tab" aria-controls="tab-import" aria-selected="<?= ($activeTab ?? 'roster') === 'import' ? 'true' : 'false' ?>">
                <span>📥</span> Import Teams (Excel / CSV)
            </button>
        </li>
    </ul>

    <?php
    $currentHubUrl = site_url('teams/roster?tab=roster' . (!empty($selectedTournamentId) ? '&tournament_id=' . (int) $selectedTournamentId : ''));

    $potSuggestions = [];
    foreach (($potOptions ?? []) as $opt) {
        $pName = trim((string) ($opt['name'] ?? ''));
        if ($pName !== '') {
            $potSuggestions[] = [
                'name'          => $pName,
                'stage'         => strtolower(trim((string) ($opt['stage'] ?? ''))),
                'tournament_id' => (int) ($opt['tournament_id'] ?? 0),
            ];
        }
    }
    ?>

    <!-- TAB CONTENTS -->
    <div class="tab-content" id="hubTabsContent">
        
        <!-- ======================================================= -->
        <!-- TAB 1: MASS ROSTER EDITOR + TAMBAH TIM MANUAL -->
        <!-- ======================================================= -->
        <div class="tab-pane fade <?= ($activeTab ?? 'roster') !== 'import' ? 'show active' : '' ?>" id="tab-roster" role="tabpanel" aria-labelledby="roster-tab">
            
            <!-- PANEL TAMBAH TIM MANUAL CEPAT (SELALU TAMPIL & LANGSUNG JALAN) -->
            <div class="card quick-add-card mb-2 p-2 rounded-0">
                <form action="<?= site_url('teams') ?>" method="post" class="row g-2 align-items-end m-0">
                    <?= csrf_field() ?>
                    <input type="hidden" name="redirect_to" value="<?= esc($currentHubUrl) ?>">
                    <input type="hidden" name="manager_context" value="import">

                    <div class="col-lg-2 col-md-4">
                        <label class="quick-add-label">Nama Team Baru <span class="text-danger">*</span></label>
                        <input type="text" name="name" required class="form-control form-control-sm roster-input fw-semibold rounded-0" placeholder="Ketik nama tim...">
                    </div>

                    <div class="col-lg-3 col-md-8">
                        <label class="quick-add-label">Anggota / Roster (Pisah Koma)</label>
                        <input type="text" name="member_text" class="form-control form-control-sm roster-input rounded-0" placeholder="Player 1, Player 2, Player 3...">
                    </div>

                    <div class="col-lg-2 col-md-4">
                        <label class="quick-add-label">Tournament</label>
                        <select name="tournament_id" class="form-select form-select-sm roster-tournament-select rounded-0">
                            <option value="">-- Tanpa Turnamen --</option>
                            <?php foreach ($tournaments as $tournament): ?>
                                <option value="<?= esc((string) $tournament['id']) ?>" <?= (int) ($selectedTournamentId ?? 0) === (int) $tournament['id'] ? 'selected' : '' ?>>
                                    <?= esc($tournament['name']) ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>

                    <div class="col-lg-2 col-md-3">
                        <label class="quick-add-label">Stage (Tahapan)</label>
                        <select name="stage" class="form-select form-select-sm roster-stage-select rounded-0">
                            <option value="kualifikasi" selected>Kualifikasi</option>
                            <option value="semifinal">Semifinal</option>
                            <option value="grandfinal">Grand Final</option>
                        </select>
                    </div>

                    <div class="col-lg-2 col-md-3">
                        <label class="quick-add-label">Nama Pot (Opsional)</label>
                        <div class="custom-dropdown-wrapper">
                            <input type="text" name="pot_name" class="form-control form-control-sm roster-input roster-pot-name-input rounded-0" placeholder="Kosong = Unassigned" autocomplete="off">
                            <div class="custom-dropdown-menu js-custom-dropdown js-pot-dropdown"></div>
                        </div>
                    </div>

                    <div class="col-lg-1 col-md-2">
                        <button type="submit" class="btn btn-primary btn-sm w-100 fw-bold rounded-0" title="Tambahkan Tim Sekarang">
                            + Tambah
                        </button>
                    </div>
                </form>
            </div>

            <?php if ($rows !== []): ?>
                <form id="team-roster-bulk-form" action="<?= site_url('teams/bulk-update') ?>" method="post" class="roster-bulk-form">
                    <?= csrf_field() ?>
                    <input type="hidden" name="redirect_to" value="<?= esc($currentHubUrl) ?>">
                    <input type="hidden" name="manager_context" value="import">
                </form>
            <?php endif; ?>

            <div class="dashboard-card card rounded-0">
                <div class="dashboard-card-header card-header roster-card-header d-flex justify-content-between align-items-center flex-wrap gap-2 py-1 px-2 rounded-0">
                    <div class="d-flex align-items-center gap-2">
                        <span class="text-white fw-bold small">Daftar Tim Terdaftar</span>
                        <span class="badge bg-secondary-subtle text-light small rounded-0 js-roster-search-meta"><?= esc((string) count($rows)) ?> team</span>
                    </div>

                    <?php if ($rows !== []): ?>
                        <div class="roster-toolbar js-roster-search-shell d-flex align-items-center gap-2 flex-wrap">
                            <div class="roster-search-field" style="min-width: 220px;">
                                <input type="search" class="form-control form-control-sm js-roster-search-input rounded-0" placeholder="Cari nama team, player, stage, pot..." autocomplete="off">
                            </div>
                            <button type="submit" form="team-roster-bulk-form" class="btn btn-primary btn-sm app-btn fw-bold rounded-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" fill="currentColor" class="me-1" viewBox="0 0 16 16"><path d="M12.736 3.97a.733.733 0 0 1 1.047 0c.286.289.29.756.01 1.05L7.88 12.01a.733.733 0 0 1-1.065.02L3.217 8.384a.757.757 0 0 1 0-1.06.733.733 0 0 1 1.047 0l3.052 3.093 5.4-6.425a.247.247 0 0 1 .02-.022Z"/></svg>
                                Simpan Semua Perubahan
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm app-btn js-roster-search-clear rounded-0">Reset</button>
                            <span class="roster-save-meta js-roster-save-meta badge bg-primary-subtle text-primary border border-primary rounded-0 d-none"></span>
                        </div>
                    <?php endif; ?>
                </div>

                <div class="dashboard-card-body card-body p-0">
                    <?php if ($rows === []): ?>
                        <div class="dashboard-empty p-4 text-center text-muted">
                            <p class="mb-2">Belum ada tim atau player yang tersimpan dalam filter ini. Silakan isi form <strong>+ Tambah Team Baru</strong> di atas, atau import dari file Excel/CSV.</p>
                            <button type="button" class="btn btn-sm btn-outline-primary rounded-0 js-go-import-tab">
                                + Import Tim dari Excel / CSV
                            </button>
                        </div>
                    <?php else: ?>
                        <div class="table-responsive roster-table-wrap">
                            <table class="table table-hover align-middle dashboard-table roster-table mb-0">
                                <thead>
                                    <tr>
                                        <th style="width: 42px;" class="text-center">No</th>
                                        <th style="width: 19%;">Nama Team</th>
                                        <th>Anggota / Roster (Maks 6)</th>
                                        <th style="width: 18%;">Tournament</th>
                                        <th style="width: 14%;">Stage (Tahapan)</th>
                                        <th style="width: 16%;">Nama Pot</th>
                                        <th style="width: 130px;" class="text-end">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($rows as $index => $row): ?>
                                        <?php
                                        $deleteFormId = 'team-roster-delete-' . $row['id'];
                                        $stageKey = strtolower(trim((string) ($row['pot_stage'] ?? '')));
                                        $rawPotName = trim((string) ($row['raw_pot_name'] ?? ''));

                                        $searchText = strtolower(trim(implode(' ', [
                                            (string) ($row['name'] ?? ''),
                                            (string) ($row['member_text'] ?? ''),
                                            (string) ($row['scope_label'] ?? ''),
                                            (string) ($row['pot_name'] ?? ''),
                                            (string) ($row['stage_label'] ?? ''),
                                            (string) ($row['tournament_name'] ?? ''),
                                            $stageKey,
                                            $rawPotName,
                                        ])));
                                        ?>
                                        <tr
                                            data-roster-row
                                            data-team-id="<?= esc((string) $row['id']) ?>"
                                            data-search-text="<?= esc($searchText) ?>"
                                            data-original-name="<?= esc($row['name']) ?>"
                                            data-original-members="<?= esc($row['member_text'] === '-' ? '' : implode(', ', $row['members'] ?? [])) ?>"
                                            data-original-tournament-id="<?= esc((string) ($row['tournament_id'] ?? '')) ?>"
                                            data-original-stage="<?= esc($stageKey) ?>"
                                            data-original-pot-name="<?= esc($rawPotName) ?>"
                                            data-original-pot-id="<?= esc((string) ($row['pot_id'] ?? '')) ?>"
                                        >
                                            <td class="text-center fw-semibold text-muted"><?= esc((string) ($index + 1)) ?></td>
                                            
                                            <!-- NAMA TEAM -->
                                            <td>
                                                <input type="hidden" name="teams[<?= esc((string) $row['id']) ?>][__changed]" form="team-roster-bulk-form" value="0" class="js-roster-row-changed">
                                                <input
                                                    type="text"
                                                    name="teams[<?= esc((string) $row['id']) ?>][name]"
                                                    form="team-roster-bulk-form"
                                                    class="form-control form-control-sm roster-input fw-semibold rounded-0"
                                                    value="<?= esc($row['name']) ?>"
                                                    placeholder="Nama Tim"
                                                    <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                >
                                            </td>

                                            <!-- ANGGOTA (ROSTER) -->
                                            <td>
                                                <textarea
                                                    name="teams[<?= esc((string) $row['id']) ?>][member_text]"
                                                    form="team-roster-bulk-form"
                                                    class="form-control form-control-sm roster-textarea rounded-0"
                                                    rows="2"
                                                    placeholder="Pemain 1, Pemain 2, ..."
                                                    <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                ><?= esc($row['member_text'] === '-' ? '' : $row['member_text']) ?></textarea>
                                                <div class="form-text roster-help">Pisahkan dengan koma atau baris baru.</div>
                                            </td>

                                            <!-- TOURNAMENT -->
                                            <td>
                                                <select
                                                    name="teams[<?= esc((string) $row['id']) ?>][tournament_id]"
                                                    form="team-roster-bulk-form"
                                                    class="form-select form-select-sm roster-tournament-select rounded-0"
                                                    <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                >
                                                    <option value="">Belum Ada Tournament</option>
                                                    <?php foreach ($tournaments as $tournament): ?>
                                                        <option value="<?= esc((string) $tournament['id']) ?>" <?= (int) ($row['tournament_id'] ?? 0) === (int) $tournament['id'] ? 'selected' : '' ?>>
                                                            <?= esc($tournament['name']) ?>
                                                        </option>
                                                    <?php endforeach; ?>
                                                </select>
                                                <div class="form-text roster-help text-truncate" title="<?= esc($row['tournament_name']) ?>">
                                                    <?= esc($row['tournament_name'] !== '' ? $row['tournament_name'] : 'Belum Ada Tournament') ?>
                                                </div>
                                            </td>

                                            <!-- STAGE INPUT -->
                                            <td>
                                                <select
                                                    name="teams[<?= esc((string) $row['id']) ?>][stage]"
                                                    form="team-roster-bulk-form"
                                                    class="form-select form-select-sm roster-stage-select rounded-0"
                                                    <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                >
                                                    <option value="" <?= $stageKey === '' ? 'selected' : '' ?>>-- Tanpa Pot --</option>
                                                    <option value="kualifikasi" <?= $stageKey === 'kualifikasi' ? 'selected' : '' ?>>Kualifikasi</option>
                                                    <option value="semifinal" <?= $stageKey === 'semifinal' ? 'selected' : '' ?>>Semifinal</option>
                                                    <option value="grandfinal" <?= $stageKey === 'grandfinal' ? 'selected' : '' ?>>Grand Final</option>
                                                </select>
                                                <div class="form-text roster-help">
                                                    <?php if ($stageKey === 'kualifikasi'): ?>
                                                        <span class="badge bg-primary-subtle text-primary border border-primary stage-badge-sm rounded-0">Kualifikasi</span>
                                                    <?php elseif ($stageKey === 'semifinal'): ?>
                                                        <span class="badge bg-warning-subtle text-warning border border-warning stage-badge-sm rounded-0">Semifinal</span>
                                                    <?php elseif ($stageKey === 'grandfinal'): ?>
                                                        <span class="badge bg-danger-subtle text-danger border border-danger stage-badge-sm rounded-0">Grand Final</span>
                                                    <?php else: ?>
                                                        <span class="text-muted">Tanpa Stage</span>
                                                    <?php endif; ?>
                                                </div>
                                            </td>

                                            <!-- POT NAME INPUT (AUTO-CREATION MAGIC POT) -->
                                            <td>
                                                <div class="custom-dropdown-wrapper">
                                                    <input
                                                        type="text"
                                                        name="teams[<?= esc((string) $row['id']) ?>][pot_name]"
                                                        form="team-roster-bulk-form"
                                                        class="form-control form-control-sm roster-input roster-pot-name-input rounded-0"
                                                        value="<?= esc($rawPotName) ?>"
                                                        placeholder="e.g. POT 1, Group A"
                                                        autocomplete="off"
                                                        <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                    >
                                                    <div class="custom-dropdown-menu js-custom-dropdown js-pot-dropdown"></div>
                                                </div>
                                                <div class="form-text roster-help text-truncate" title="<?= esc($row['pot_name']) ?>">
                                                    <?= esc($row['pot_name'] !== '' ? $row['pot_name'] : 'Belum Masuk Pot') ?>
                                                </div>
                                            </td>

                                            <!-- AKSI -->
                                            <td class="text-end">
                                                <form id="<?= esc($deleteFormId) ?>" action="<?= site_url('teams/delete/' . $row['id']) ?>" method="post" class="d-none">
                                                    <?= csrf_field() ?>
                                                    <input type="hidden" name="redirect_to" value="<?= esc($currentHubUrl) ?>">
                                                </form>

                                                <div class="dashboard-action-group roster-action-group d-flex justify-content-end gap-1">
                                                    <button
                                                        type="submit"
                                                        form="team-roster-bulk-form"
                                                        name="save_single_team_id"
                                                        value="<?= esc((string) $row['id']) ?>"
                                                        class="btn btn-sm btn-outline-primary app-btn js-roster-single-save rounded-0"
                                                        title="Simpan baris tim ini"
                                                        <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                    >
                                                        Simpan
                                                    </button>
                                                    <button
                                                        type="submit"
                                                        form="<?= esc($deleteFormId) ?>"
                                                        class="btn btn-sm btn-outline-danger app-btn rounded-0"
                                                        data-confirm-click="Hapus team ini langsung dari sistem?"
                                                        title="Hapus tim"
                                                        <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                    >
                                                        Hapus
                                                    </button>
                                                </div>
                                                <?php if ($row['is_locked']): ?>
                                                    <div class="form-text roster-help text-end mb-0 text-warning">Terkunci.</div>
                                                <?php endif; ?>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                        <div class="dashboard-empty roster-search-empty d-none js-roster-search-empty p-3 text-center text-muted">
                            Tidak ada team atau player yang cocok dengan kata kunci pencarian.
                        </div>

                        <?php if (isset($pager) && $pager->getPageCount() > 1): ?>
                            <div class="card-footer bg-transparent border-top py-2 px-3 d-flex justify-content-between align-items-center flex-wrap gap-2 rounded-0">
                                <div class="small text-muted">
                                    Halaman <?= esc((string) $pager->getCurrentPage()) ?> dari <?= esc((string) $pager->getPageCount()) ?>
                                </div>
                                <div>
                                    <?= $pager->links() ?>
                                </div>
                            </div>
                        <?php endif; ?>
                    <?php endif; ?>
                </div>
            </div>
        </div>

        <!-- ======================================================= -->
        <!-- TAB 2: IMPORT TEAMS (EXCEL / CSV) -->
        <!-- ======================================================= -->
        <div class="tab-pane fade <?= ($activeTab ?? 'roster') === 'import' ? 'show active' : '' ?>" id="tab-import" role="tabpanel" aria-labelledby="import-tab">
            
            <!-- PANDUAN FORMAT EXCEL / CSV -->
            <div class="card import-format-guide mb-3 rounded-0">
                <div class="card-header bg-transparent border-bottom d-flex justify-content-between align-items-center py-2 px-3 rounded-0">
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge text-bg-primary rounded-0">Panduan Format</span>
                        <span class="fw-semibold text-light small">Struktur Header Kolom yang Diterima (.xlsx, .csv, .txt)</span>
                    </div>
                    <span class="text-muted small">Maksimal 6 pemain per tim</span>
                </div>
                <div class="card-body p-3">
                    <div class="row g-3">
                        <div class="col-lg-6">
                            <div class="import-format-box rounded-0">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="fw-bold text-info small">1. FORMAT STANDAR SISTEM</span>
                                    <span class="badge bg-secondary-subtle text-secondary border small rounded-0">Default</span>
                                </div>
                                <p class="text-muted small mb-2">Gunakan susunan header baku berikut pada baris pertama spreadsheet Anda:</p>
                                <div class="mb-2">
                                    <div class="text-secondary small fw-semibold mb-1">Info Tim & Kontak:</div>
                                    <span class="import-badge-code rounded-0">team_name</span>
                                    <span class="import-badge-code rounded-0">leader_name</span>
                                    <span class="import-badge-code rounded-0">whatsapp</span>
                                    <span class="import-badge-code rounded-0">email</span>
                                    <span class="import-badge-code rounded-0">notes</span>
                                </div>
                                <div>
                                    <div class="text-secondary small fw-semibold mb-1">Pemain (Roster):</div>
                                    <span class="import-badge-code rounded-0">player_1_name</span>
                                    <span class="import-badge-code rounded-0">player_2_name</span>
                                    <span class="import-badge-code rounded-0">player_3_name</span>
                                    <span class="import-badge-code rounded-0">player_4_name</span>
                                    <span class="import-badge-code rounded-0">player_5_name</span>
                                    <span class="import-badge-code rounded-0">player_6_name</span>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-6">
                            <div class="import-format-box rounded-0">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="fw-bold text-success small">2. FORMAT RESPONS GOOGLE FORM</span>
                                    <span class="badge bg-success-subtle text-success border small rounded-0">Auto-Detect</span>
                                </div>
                                <p class="text-muted small mb-2">Langsung upload file hasil ekspor Google Form formulir pendaftaran:</p>
                                <div class="mb-2">
                                    <div class="text-secondary small fw-semibold mb-1">Header Form yang Dikenali:</div>
                                    <span class="import-badge-code rounded-0">nama_team</span>
                                    <span class="import-badge-code rounded-0">nick_captain</span>
                                    <span class="import-badge-code rounded-0">no_wa</span>
                                    <span class="import-badge-code rounded-0">email</span>
                                    <span class="import-badge-code rounded-0">bukti_pembayaran</span>
                                </div>
                                <div>
                                    <div class="text-secondary small fw-semibold mb-1">Header Nick Player Form:</div>
                                    <span class="import-badge-code rounded-0">nick_player_1</span>
                                    <span class="import-badge-code rounded-0">nick_player_2</span>
                                    <span class="import-badge-code rounded-0">nick_player_3</span>
                                    <span class="import-badge-code rounded-0">nick_player_4</span>
                                    <span class="import-badge-code rounded-0">nick_player_5</span>
                                    <span class="import-badge-code rounded-0">nick_player_6</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mt-2 text-muted small">
                        <i class="small">Catatan: Jika nama tim sudah ada di database, data anggota akan disinkronkan secara otomatis tanpa membuat duplikasi tim.</i>
                    </div>
                </div>
            </div>

            <!-- FORM IMPORT UPLOAD -->
            <div class="card dashboard-card rounded-0">
                <div class="card-header dashboard-card-header py-2 px-3 rounded-0">
                    <h2 class="h5 mb-0 text-white">Upload File Roster Tim</h2>
                </div>
                <div class="card-body p-3">
                    <form action="<?= site_url('imports/teams') ?>" method="post" enctype="multipart/form-data" class="import-upload-form js-import-upload-form">
                        <?= csrf_field() ?>
                        <input type="hidden" name="redirect_to" value="<?= esc(site_url('teams/roster?tab=roster')) ?>">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-light small fw-bold">Pilih Tournament <span class="text-danger">*</span></label>
                                <select name="tournament_id" class="form-select form-select-sm js-import-tournament-select rounded-0" required>
                                    <option value="">-- Pilih Tournament Tujuan --</option>
                                    <?php foreach ($tournaments as $tournament): ?>
                                        <option value="<?= esc((string) $tournament['id']) ?>" <?= (int) ($selectedTournamentId ?? 0) === (int) $tournament['id'] ? 'selected' : '' ?>>
                                            <?= esc($tournament['name']) ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                                <div class="form-text text-muted" style="font-size: 0.72rem;">Tim yang di-import akan dimasukkan ke dalam turnamen ini.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-light small fw-bold">Penempatan Awal Pot</label>
                                <select name="import_mode" class="form-select form-select-sm js-import-mode-select rounded-0">
                                    <option value="global" selected>Belum Masuk Pot (Tanpa Pot)</option>
                                    <option value="with_pot">Langsung Masukkan ke Pot</option>
                                </select>
                                <div class="form-text text-muted" style="font-size: 0.72rem;">Bisa diatur belakangan di Mass Roster Editor jika memilih 'Belum Masuk Pot'.</div>
                            </div>

                            <div class="col-md-6 js-import-pot-group" style="display: none;">
                                <label class="form-label text-light small fw-bold">Pilih Pot Tujuan (Berdasarkan Stage) <span class="text-danger">*</span></label>
                                <select name="pot_id" class="form-select form-select-sm js-import-pot-select rounded-0">
                                    <option value="">-- Pilih Pot --</option>
                                    <?php
                                    $stageLabels = [
                                        'kualifikasi' => 'Kualifikasi',
                                        'semifinal'   => 'Semifinal',
                                        'grandfinal'  => 'Grand Final',
                                    ];

                                    $groupedPots = [];
                                    foreach (($pots ?? []) as $pot) {
                                        $stageKey = strtolower(trim((string) ($pot['stage'] ?? 'kualifikasi')));
                                        $stageTitle = $stageLabels[$stageKey] ?? ucfirst($stageKey !== '' ? $stageKey : 'Kualifikasi');
                                        $groupedPots[$stageTitle][] = $pot;
                                    }
                                    ?>
                                    <?php foreach ($groupedPots as $stageTitle => $potsInStage): ?>
                                        <optgroup label="<?= esc($stageTitle) ?>">
                                            <?php foreach ($potsInStage as $pot): ?>
                                                <option value="<?= esc((string) $pot['id']) ?>">
                                                    [<?= esc($stageTitle) ?>] - <?= esc($pot['name']) ?>
                                                </option>
                                            <?php endforeach; ?>
                                        </optgroup>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-light small fw-bold">Pilih File Spreadsheet <span class="text-danger">*</span></label>
                                <input type="file" class="form-control form-control-sm rounded-0" name="team_file" accept=".csv,.txt,.xlsx" required>
                                <div class="form-text text-muted" style="font-size: 0.72rem;">Format: .xlsx, .csv, atau .txt (Maksimal 4 MB).</div>
                            </div>

                            <div class="col-12 mt-3">
                                <button type="submit" class="btn btn-primary btn-sm app-btn px-4 rounded-0">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="me-1" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708l3-3z"/></svg>
                                    Mulai Import Tim
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div>
</div>

<script <?= function_exists('csp_script_nonce') ? csp_script_nonce() : '' ?>>
document.addEventListener('DOMContentLoaded', () => {
    /* ==========================================================================
       1. TOURNAMENT FILTER SYNC
       ========================================================================== */
    const tournamentFilter = document.querySelector('.js-roster-tournament-filter');
    const url = new URL(window.location.href);

    tournamentFilter?.addEventListener('change', () => {
        const value = String(tournamentFilter.value || '').trim();
        if (value === '' || value === 'all') {
            url.searchParams.set('tournament_id', 'all');
        } else {
            url.searchParams.set('tournament_id', value);
        }
        window.location.href = url.toString();
    });

    /* ==========================================================================
       2. TAB SWITCHING WITH URL SYNC & EMPTY STATE BUTTON
       ========================================================================== */
    const hubTabs = document.querySelectorAll('#hubTabs button[data-bs-toggle="pill"]');
    hubTabs.forEach((tabBtn) => {
        tabBtn.addEventListener('shown.bs.tab', (e) => {
            const targetId = e.target.getAttribute('data-bs-target');
            const tabName = targetId === '#tab-import' ? 'import' : 'roster';
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('tab', tabName);
            window.history.replaceState({}, '', currentUrl.toString());
        });
    });

    document.querySelectorAll('.js-go-import-tab').forEach((btn) => {
        btn.addEventListener('click', () => {
            const importTabBtn = document.getElementById('import-tab');
            if (importTabBtn) {
                if (window.bootstrap?.Tab) {
                    new window.bootstrap.Tab(importTabBtn).show();
                } else {
                    importTabBtn.click();
                }
            }
        });
    });

    /* ==========================================================================
       3. IMPORT SECTION LOGIC (Mode toggle & Tournament sync)
       ========================================================================== */
    const importForm = document.querySelector('.js-import-upload-form');
    if (importForm) {
        const modeSelect = importForm.querySelector('.js-import-mode-select');
        const potGroup = importForm.querySelector('.js-import-pot-group');
        const potSelect = importForm.querySelector('.js-import-pot-select');

        const togglePotGroup = () => {
            const isWithPot = String(modeSelect?.value || 'global') === 'with_pot';
            if (potGroup) {
                potGroup.style.display = isWithPot ? 'block' : 'none';
            }
            if (potSelect) {
                potSelect.required = isWithPot;
            }
        };

        modeSelect?.addEventListener('change', togglePotGroup);
        togglePotGroup();
    }

    /* ==========================================================================
       4. CHANGE TRACKING & SUBMISSION ENGINE (BULK & SINGLE)
       ========================================================================== */
    const bulkForm = document.getElementById('team-roster-bulk-form');
    const rows = Array.from(document.querySelectorAll('[data-roster-row]'));
    const saveMeta = document.querySelector('.js-roster-save-meta');
    let submitMode = 'bulk';
    let singleTargetTeamId = null;

    const normalizeMemberText = (value) => String(value || '')
        .replace(/;/g, ',')
        .replace(/\r\n?/g, '\n')
        .split(/\n|,/)
        .map((chunk) => chunk.trim().replace(/\s+/g, ' '))
        .filter(Boolean)
        .slice(0, 6)
        .join(', ');

    const rowHasChanges = (row) => {
        const teamName = row.querySelector('input[name$="[name]"]');
        const memberText = row.querySelector('textarea[name$="[member_text]"]');
        const tournament = row.querySelector('select[name$="[tournament_id]"]');
        const stage = row.querySelector('select[name$="[stage]"]');
        const potName = row.querySelector('input[name$="[pot_name]"]');

        const nameChanged = String(teamName?.value || '').trim() !== String(row.dataset.originalName || '').trim();
        const membersChanged = normalizeMemberText(memberText?.value || '') !== normalizeMemberText(row.dataset.originalMembers || '');
        const tournamentChanged = String(tournament?.value || '').trim() !== String(row.dataset.originalTournamentId || '').trim();
        const stageChanged = String(stage?.value || '').trim().toLowerCase() !== String(row.dataset.originalStage || '').trim().toLowerCase();
        const potNameChanged = String(potName?.value || '').trim() !== String(row.dataset.originalPotName || '').trim();

        return nameChanged || membersChanged || tournamentChanged || stageChanged || potNameChanged;
    };

    const updateRowState = (row) => {
        const changed = rowHasChanges(row);
        const changedField = row.querySelector('.js-roster-row-changed');
        if (changedField) {
            changedField.value = changed ? '1' : '0';
        }
        row.classList.toggle('roster-row-modified', changed);
        refreshSaveMeta();
    };

    const refreshSaveMeta = () => {
        if (!saveMeta) return;
        let count = 0;
        rows.forEach((row) => {
            if (rowHasChanges(row)) count++;
        });
        if (count > 0) {
            saveMeta.textContent = `${count} perubahan siap disimpan`;
            saveMeta.classList.remove('d-none');
        } else {
            saveMeta.classList.add('d-none');
        }
    };

    const tableBody = document.querySelector('.roster-table tbody');
    if (tableBody) {
        tableBody.addEventListener('input', (e) => {
            const row = e.target.closest('tr[data-roster-row]');
            if (row) updateRowState(row);
        });

        tableBody.addEventListener('change', (e) => {
            const row = e.target.closest('tr[data-roster-row]');
            if (row) updateRowState(row);
        });
    }

    document.querySelectorAll('button[type="submit"]').forEach((btn) => {
        btn.addEventListener('click', () => {
            if (btn.name === 'save_single_team_id') {
                submitMode = 'single';
                singleTargetTeamId = btn.value;
            } else if (btn.getAttribute('form') === 'team-roster-bulk-form') {
                submitMode = 'bulk';
                singleTargetTeamId = null;
            }
        });
    });

    bulkForm?.addEventListener('submit', (e) => {
        if (submitMode === 'single' && singleTargetTeamId) {
            rows.forEach((row) => {
                const isTarget = String(row.dataset.teamId || '') === String(singleTargetTeamId);
                const changedField = row.querySelector('.js-roster-row-changed');
                if (changedField) {
                    changedField.value = isTarget ? '1' : '0';
                }
                row.querySelectorAll('input, textarea, select').forEach((field) => {
                    if (field.form !== bulkForm || field.classList.contains('js-roster-row-changed')) return;
                    field.disabled = !isTarget;
                });
            });
        } else {
            let changedCount = 0;
            rows.forEach((row) => {
                const changed = rowHasChanges(row);
                const changedField = row.querySelector('.js-roster-row-changed');
                if (changedField) {
                    changedField.value = changed ? '1' : '0';
                }
                row.querySelectorAll('input, textarea, select').forEach((field) => {
                    if (field.form !== bulkForm || field.classList.contains('js-roster-row-changed')) return;
                    field.disabled = !changed;
                });
                if (changed) changedCount++;
            });

            if (changedCount === 0) {
                e.preventDefault();
                alert('Belum ada perubahan data tim untuk disimpan.');
                rows.forEach((row) => {
                    row.querySelectorAll('input, textarea, select').forEach((field) => {
                        if (field.form === bulkForm) field.disabled = false;
                    });
                });
                return;
            }
        }

        if (window.BGApp?.ensureFormCsrf) {
            window.BGApp.ensureFormCsrf(bulkForm);
        }
    });

    /* ==========================================================================
       5. REAL-TIME SEARCH ENGINE (TOKENIZED & INSTANT)
       ========================================================================== */
    const searchShell = document.querySelector('.js-roster-search-shell');
    if (searchShell) {
        const searchInput = searchShell.querySelector('.js-roster-search-input');
        const clearBtn = searchShell.querySelector('.js-roster-search-clear');
        const searchMeta = document.querySelector('.js-roster-search-meta');
        const emptyState = document.querySelector('.js-roster-search-empty');
        const totalRows = rows.length;
        let debounceTimer = null;

        const normalize = (val) => String(val || '')
            .toLowerCase()
            .replace(/[^\w\s]/g, ' ')
            .replace(/\s+/g, ' ')
            .trim();

        const indexedRows = rows.map((row) => {
            const raw = normalize(String(row.getAttribute('data-search-text') || ''));
            return {
                row,
                raw,
                tokens: raw.split(' ').filter(Boolean),
            };
        });

        const executeSearch = () => {
            const keyword = normalize(searchInput?.value || '');

            if (keyword === '') {
                indexedRows.forEach(({ row }) => { row.hidden = false; });
                if (searchMeta) searchMeta.textContent = `${totalRows} team`;
                if (emptyState) emptyState.classList.add('d-none');
                return;
            }

            const terms = keyword.split(' ').filter(Boolean);
            let visibleCount = 0;

            indexedRows.forEach((item) => {
                const matched = terms.every((term) => {
                    if (item.raw.includes(term)) return true;
                    return item.tokens.some((token) => token.startsWith(term));
                });

                item.row.hidden = !matched;
                if (matched) visibleCount++;
            });

            if (searchMeta) {
                searchMeta.textContent = visibleCount > 0 ? `${visibleCount} hasil ditemukan` : '0 hasil';
            }
            if (emptyState) {
                emptyState.classList.toggle('d-none', visibleCount > 0);
            }
        };

        searchInput?.addEventListener('input', () => {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => {
                requestAnimationFrame(executeSearch);
            }, 80);
        });

        clearBtn?.addEventListener('click', () => {
            if (!searchInput) return;
            searchInput.value = '';
            executeSearch();
            searchInput.focus();
        });
    }

    /* ==========================================================================
       6. CUSTOM COMBOBOX FOR POT SELECTION (QUICK ADD + TABLE ROWS)
       ========================================================================== */
    const potSuggestionsData = <?= json_encode($potSuggestions ?? []) ?>;

    const closeAllPotDropdowns = () => {
        document.querySelectorAll('.js-pot-dropdown.is-active, .js-pot-dropdown.is-open').forEach((dd) => {
            dd.classList.remove('is-active', 'is-open');
            dd.style.display = 'none';
            dd.querySelectorAll('.custom-dropdown-item.is-highlighted, .custom-combobox-item.is-active').forEach((it) => it.classList.remove('is-highlighted', 'is-active'));
        });
    };

    document.addEventListener('click', (e) => {
        if (!e.target.closest('.custom-dropdown-wrapper') && !e.target.closest('.custom-combobox-wrapper')) {
            closeAllPotDropdowns();
        }
    });

    document.querySelectorAll('.roster-pot-name-input').forEach((input) => {
        const wrapper = input.closest('.custom-dropdown-wrapper') || input.closest('.custom-combobox-wrapper');
        const dropdown = wrapper?.querySelector('.js-pot-dropdown');
        if (!wrapper || !dropdown) return;

        const container = input.closest('tr[data-roster-row]') || input.closest('form');
        const stageSelect = container?.querySelector('.roster-stage-select');
        const tournamentSelect = container?.querySelector('.roster-tournament-select');

        const renderDropdown = () => {
            const currentStage = (stageSelect?.value || '').trim().toLowerCase();
            const currentTourneyId = parseInt(tournamentSelect?.value || '0', 10);
            const keyword = (input.value || '').trim().toLowerCase();

            let matches = potSuggestionsData.filter((p) => {
                if (currentTourneyId > 0 && p.tournament_id > 0 && p.tournament_id !== currentTourneyId) {
                    return false;
                }
                if (currentStage && p.stage && p.stage !== currentStage) {
                    return false;
                }
                if (keyword && !p.name.toLowerCase().includes(keyword)) {
                    return false;
                }
                return true;
            });

            if (matches.length === 0 && keyword) {
                matches = potSuggestionsData.filter((p) => p.name.toLowerCase().includes(keyword));
            }

            const uniqueNames = [];
            const seen = new Set();
            matches.forEach((p) => {
                const n = p.name.trim();
                if (!seen.has(n.toLowerCase())) {
                    seen.add(n.toLowerCase());
                    uniqueNames.push(n);
                }
            });

            dropdown.innerHTML = '';
            if (uniqueNames.length === 0) {
                dropdown.innerHTML = '<div class="custom-dropdown-empty">Ketik untuk membuat pot baru</div>';
                dropdown.classList.add('is-active', 'is-open');
                dropdown.style.display = 'block';
                return;
            }

            uniqueNames.slice(0, 15).forEach((name) => {
                const item = document.createElement('div');
                item.className = 'custom-dropdown-item';
                item.textContent = name;
                item.dataset.value = name;
                item.addEventListener('mousedown', (e) => {
                    e.preventDefault();
                    input.value = name;
                    input.dispatchEvent(new Event('input', { bubbles: true }));
                    input.dispatchEvent(new Event('change', { bubbles: true }));
                    closeAllPotDropdowns();
                });
                dropdown.appendChild(item);
            });

            dropdown.classList.add('is-active', 'is-open');
            dropdown.style.display = 'block';
        };

        input.addEventListener('focus', renderDropdown);
        input.addEventListener('input', renderDropdown);
        input.addEventListener('blur', () => {
            setTimeout(closeAllPotDropdowns, 150);
        });

        input.addEventListener('keydown', (e) => {
            if (!dropdown.classList.contains('is-active') && !dropdown.classList.contains('is-open')) return;
            const items = Array.from(dropdown.querySelectorAll('.custom-dropdown-item, .custom-combobox-item'));
            if (!items.length) return;

            let activeIdx = items.findIndex((it) => it.classList.contains('is-highlighted') || it.classList.contains('is-active'));

            if (e.key === 'ArrowDown') {
                e.preventDefault();
                if (activeIdx >= 0 && items[activeIdx]) items[activeIdx].classList.remove('is-highlighted', 'is-active');
                activeIdx = (activeIdx + 1) % items.length;
                items[activeIdx].classList.add('is-highlighted');
                items[activeIdx].scrollIntoView({ block: 'nearest' });
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                if (activeIdx >= 0 && items[activeIdx]) items[activeIdx].classList.remove('is-highlighted', 'is-active');
                activeIdx = (activeIdx - 1 + items.length) % items.length;
                items[activeIdx].classList.add('is-highlighted');
                items[activeIdx].scrollIntoView({ block: 'nearest' });
            } else if (e.key === 'Enter') {
                if (activeIdx >= 0 && items[activeIdx]) {
                    e.preventDefault();
                    input.value = items[activeIdx].dataset.value;
                    input.dispatchEvent(new Event('input', { bubbles: true }));
                    input.dispatchEvent(new Event('change', { bubbles: true }));
                    closeAllPotDropdowns();
                }
            } else if (e.key === 'Escape') {
                e.preventDefault();
                closeAllPotDropdowns();
            }
        });
    });
});
</script>

<?= $this->endSection() ?>