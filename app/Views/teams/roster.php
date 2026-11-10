<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<div class="dashboard-page roster-page-shell roster-hub-page">
    
    <!-- PAGE HEADER -->
    <div class="page-header dashboard-page-header d-flex justify-content-between align-items-center flex-wrap gap-2 mb-2">
        <div class="page-title-block">
            <h1 class="h4 mb-0 text-white fw-bold">Team Management Hub</h1>
            <p class="text-muted mb-0" style="font-size: 0.82rem;">Kelola seluruh roster tim ala Spreadsheet (Navigasi Panah/Enter, Auto-Overflow, Sandbox &amp; Smart Import).</p>
        </div>

        <div class="d-flex gap-2 align-items-end flex-wrap">
            <div class="roster-header-filter">
                <select class="form-select form-select-sm js-roster-tournament-filter rounded-0" style="min-width: 220px; height: 28px; font-size: 0.82rem;">
                    <option value="all" <?= (string) ($selectedTournamentKey ?? 'all') === 'all' ? 'selected' : '' ?>>Semua Tournament</option>
                    <option value="unassigned" <?= (string) ($selectedTournamentKey ?? 'all') === 'unassigned' ? 'selected' : '' ?>>Tim Tanpa Pot (Unassigned)</option>
                    <option value="sandbox" <?= (string) ($selectedTournamentKey ?? 'all') === 'sandbox' ? 'selected' : '' ?>>🗑️ Recycle Bin / Sandbox</option>
                    <option value="none" <?= (string) ($selectedTournamentKey ?? 'all') === 'none' ? 'selected' : '' ?>>Belum Ada Tournament</option>
                    <?php foreach ($tournaments as $tournament): ?>
                            <option value="<?= esc((string) $tournament['id']) ?>" <?= (string) ($selectedTournamentKey ?? 'all') === (string) $tournament['id'] ? 'selected' : '' ?>>
                                <?= esc($tournament['name']) ?>
                            </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <a href="<?= site_url('teams/drag-manager') ?>" class="btn btn-outline-light btn-sm app-btn rounded-0 d-inline-flex align-items-center">
                Drag &amp; Drop Manager
            </a>

            <?php if ((int) ($selectedTournamentId ?? 0) > 0): ?>
                    <a href="<?= site_url('teams/export-template?tournament_id=' . (int) $selectedTournamentId) ?>" class="btn btn-outline-info btn-sm app-btn rounded-0 d-inline-flex align-items-center">
                        Export CSV
                    </a>
            <?php endif; ?>
        </div>
    </div>

    <!-- FLASH MESSAGES -->
    <div id="rosterAjaxToast" class="alert alert-success py-1 px-3 small d-none align-items-center mb-2 rounded-0"></div>

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

    <!-- NAVIGATION TABS -->
    <ul class="nav nav-pills hub-nav-tabs mb-2 gap-1" id="hubTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-0 <?= ($activeTab ?? 'roster') !== 'import' ? 'active' : '' ?>" id="roster-tab" data-bs-toggle="pill" data-bs-target="#tab-roster" type="button" role="tab">
                <span>👥</span> Mass Roster Spreadsheet
                <span class="badge bg-secondary-subtle text-light ms-1 rounded-0"><?= esc((string) count($rows)) ?> Tim</span>
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-0 <?= ($activeTab ?? 'roster') === 'import' ? 'active' : '' ?>" id="import-tab" data-bs-toggle="pill" data-bs-target="#tab-import" type="button" role="tab">
                <span>📥</span> Smart Import Engine (Excel / CSV / Paste)
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
                'name' => $pName,
                'stage' => strtolower(trim((string) ($opt['stage'] ?? ''))),
                'tournament_id' => (int) ($opt['tournament_id'] ?? 0),
            ];
        }
    }
    ?>

    <div class="tab-content" id="hubTabsContent">
        
        <!-- ======================================================= -->
        <!-- TAB 1: MASS ROSTER EDITOR + TAMBAH TIM MANUAL -->
        <!-- ======================================================= -->
        <div class="tab-pane fade <?= ($activeTab ?? 'roster') !== 'import' ? 'show active' : '' ?>" id="tab-roster" role="tabpanel">
            
            <!-- PANEL TAMBAH TIM MANUAL CEPAT -->
            <div class="card quick-add-card mb-2 p-2 rounded-0">
                <form action="<?= site_url('teams') ?>" method="post" class="row g-2 align-items-end m-0">
                    <?= csrf_field() ?>
                    <input type="hidden" name="redirect_to" value="<?= esc($currentHubUrl) ?>">

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
                        <label class="quick-add-label">Stage / Lokasi</label>
                        <select name="stage" class="form-select form-select-sm roster-stage-select rounded-0">
                            <option value="kualifikasi" selected>Kualifikasi (Auto-Pot)</option>
                            <option value="semifinal">Semifinal</option>
                            <option value="grandfinal">Grand Final</option>
                            <option value="sandbox">🗑️ Sandbox / Cadangan</option>
                        </select>
                    </div>

                    <div class="col-lg-2 col-md-3">
                        <label class="quick-add-label">Nama Pot (Opsional)</label>
                        <div class="custom-dropdown-wrapper">
                            <input type="text" name="pot_name" class="form-control form-control-sm roster-input roster-pot-name-input rounded-0" placeholder="Kosong = Smart Auto-Pot" autocomplete="off">
                            <div class="custom-dropdown-menu js-custom-dropdown js-pot-dropdown"></div>
                        </div>
                    </div>

                    <div class="col-lg-1 col-md-2">
                        <button type="submit" class="btn btn-primary btn-sm w-100 fw-bold rounded-0">+ Tambah</button>
                    </div>
                </form>
            </div>

            <?php if ($rows !== []): ?>
                    <form id="team-roster-bulk-form" action="<?= site_url('teams/bulk-update') ?>" method="post" class="roster-bulk-form">
                        <?= csrf_field() ?>
                        <input type="hidden" name="redirect_to" value="<?= esc($currentHubUrl) ?>">
                    </form>
            <?php endif; ?>

            <div class="dashboard-card card rounded-0">
                <div class="dashboard-card-header card-header roster-card-header d-flex justify-content-between align-items-center flex-wrap gap-2 py-1 px-2 rounded-0">
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <span class="text-white fw-bold small">Daftar Tim Terdaftar</span>
                        <span class="badge bg-secondary-subtle text-light small rounded-0 js-roster-search-meta"><?= esc((string) count($rows)) ?> team</span>

                        <?php if ($rows !== []): ?>
                                <div class="d-flex align-items-center gap-1 ms-2">
                                    <select id="bulkCheckedActionSelect" class="form-select form-select-sm roster-stage-select" style="width: auto; min-width: 195px;">
                                        <option value="">-- Aksi Centang Massal --</option>
                                        <option value="auto_overflow">⚡ Smart Auto-Overflow ke Pot</option>
                                        <option value="to_unassigned">📤 Lepas ke Unassigned</option>
                                        <option value="to_sandbox">🗑️ Parkir ke Sandbox / Recycle Bin</option>
                                        <option value="delete_safe">❌ Hapus Permanen (Aman DB)</option>
                                    </select>
                                    <button type="button" id="btnRunCheckedBulk" class="btn btn-outline-info btn-sm">Jalankan</button>
                                </div>
                        <?php endif; ?>
                    </div>

                    <?php if ($rows !== []): ?>
                            <div class="roster-toolbar js-roster-search-shell d-flex align-items-center gap-2 flex-wrap">
                                <div class="roster-search-field" style="min-width: 220px;">
                                    <input type="search" class="form-control form-control-sm js-roster-search-input rounded-0" placeholder="Cari nama team, player, stage, pot..." autocomplete="off">
                                </div>
                                <button type="submit" form="team-roster-bulk-form" class="btn btn-primary btn-sm app-btn fw-bold rounded-0">
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
                                <p class="mb-2">Belum ada tim dalam filter ini. Silakan tambah manual di atas atau gunakan Smart Import Engine.</p>
                                <button type="button" class="btn btn-sm btn-outline-primary rounded-0 js-go-import-tab">
                                    + Buka Smart Import Engine
                                </button>
                            </div>
                    <?php else: ?>
                            <div class="table-responsive roster-table-wrap">
                                <table class="table table-hover align-middle dashboard-table roster-table mb-0" id="proRosterGridTable">
                                    <thead>
                                        <tr>
                                            <th style="width: 32px;" class="text-center">
                                                <input type="checkbox" id="checkAllRosterRows" title="Pilih semua yang tampil">
                                            </th>
                                            <th style="width: 38px;" class="text-center">No</th>
                                            <th style="width: 19%;">Nama Team</th>
                                            <th>Anggota / Roster (Pisah Koma)</th>
                                            <th style="width: 17%;">Tournament</th>
                                            <th style="width: 14%;">Stage / Sandbox</th>
                                            <th style="width: 15%;">Nama Pot</th>
                                            <th style="width: 125px;" class="text-end">Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($rows as $index => $row): ?>
                                                <?php
                                                $deleteFormId = 'team-roster-delete-' . $row['id'];
                                                $stageKey = strtolower(trim((string) ($row['pot_stage'] ?? '')));
                                                $rawPotName = trim((string) ($row['raw_pot_name'] ?? ''));
                                                $isSandbox = !empty($row['is_sandbox']);

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
                                                    data-row-idx="<?= $index ?>"
                                                    data-team-id="<?= esc((string) $row['id']) ?>"
                                                    data-search-text="<?= esc($searchText) ?>"
                                                    data-original-name="<?= esc($row['name']) ?>"
                                                    data-original-members="<?= esc($row['member_text'] === '-' ? '' : implode(', ', $row['members'] ?? [])) ?>"
                                                    data-original-tournament-id="<?= esc((string) ($row['tournament_id'] ?? '')) ?>"
                                                    data-original-stage="<?= esc($stageKey) ?>"
                                                    data-original-pot-name="<?= esc($rawPotName) ?>"
                                                    class="<?= $isSandbox ? 'roster-row-sandbox' : '' ?>"
                                                >
                                                    <td class="text-center">
                                                        <input type="checkbox" class="js-roster-row-check" value="<?= esc((string) $row['id']) ?>">
                                                    </td>
                                                    <td class="text-center fw-semibold text-muted"><?= esc((string) ($index + 1)) ?></td>
                                            
                                                    <!-- NAMA TEAM -->
                                                    <td>
                                                        <input type="hidden" name="teams[<?= esc((string) $row['id']) ?>][__changed]" form="team-roster-bulk-form" value="0" class="js-roster-row-changed">
                                                        <input
                                                            type="text"
                                                            name="teams[<?= esc((string) $row['id']) ?>][name]"
                                                            form="team-roster-bulk-form"
                                                            data-grid-col="0"
                                                            class="form-control form-control-sm roster-input js-grid-nav fw-semibold rounded-0"
                                                            value="<?= esc($row['name']) ?>"
                                                            placeholder="Nama Tim"
                                                            <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                        >
                                                    </td>

                                                    <!-- ANGGOTA (ROSTER) -->
                                                    <td>
                                                        <input
                                                            type="text"
                                                            name="teams[<?= esc((string) $row['id']) ?>][member_text]"
                                                            form="team-roster-bulk-form"
                                                            data-grid-col="1"
                                                            class="form-control form-control-sm roster-input js-grid-nav rounded-0"
                                                            placeholder="Pemain 1, Pemain 2, ..."
                                                            value="<?= esc($row['member_text'] === '-' ? '' : $row['member_text']) ?>"
                                                            <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                        >
                                                    </td>

                                                    <!-- TOURNAMENT -->
                                                    <td>
                                                        <select
                                                            name="teams[<?= esc((string) $row['id']) ?>][tournament_id]"
                                                            form="team-roster-bulk-form"
                                                            data-grid-col="2"
                                                            class="form-select form-select-sm roster-tournament-select js-grid-nav rounded-0"
                                                            <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                        >
                                                            <option value="">Belum Ada Tournament</option>
                                                            <?php foreach ($tournaments as $tournament): ?>
                                                                    <option value="<?= esc((string) $tournament['id']) ?>" <?= (int) ($row['tournament_id'] ?? 0) === (int) $tournament['id'] ? 'selected' : '' ?>>
                                                                        <?= esc($tournament['name']) ?>
                                                                    </option>
                                                            <?php endforeach; ?>
                                                        </select>
                                                    </td>

                                                    <!-- STAGE / SANDBOX INPUT -->
                                                    <td>
                                                        <select
                                                            name="teams[<?= esc((string) $row['id']) ?>][stage]"
                                                            form="team-roster-bulk-form"
                                                            data-grid-col="3"
                                                            class="form-select form-select-sm roster-stage-select js-grid-nav rounded-0"
                                                            <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                        >
                                                            <option value="" <?= $stageKey === '' ? 'selected' : '' ?>>-- Tanpa Pot --</option>
                                                            <option value="kualifikasi" <?= $stageKey === 'kualifikasi' ? 'selected' : '' ?>>Kualifikasi</option>
                                                            <option value="semifinal" <?= $stageKey === 'semifinal' ? 'selected' : '' ?>>Semifinal</option>
                                                            <option value="grandfinal" <?= $stageKey === 'grandfinal' ? 'selected' : '' ?>>Grand Final</option>
                                                            <option value="sandbox" <?= $stageKey === 'sandbox' ? 'selected' : '' ?>>🗑️ Sandbox / Cadangan</option>
                                                        </select>
                                                    </td>

                                                    <!-- POT NAME INPUT -->
                                                    <td>
                                                        <div class="custom-dropdown-wrapper">
                                                            <input
                                                                type="text"
                                                                name="teams[<?= esc((string) $row['id']) ?>][pot_name]"
                                                                form="team-roster-bulk-form"
                                                                data-grid-col="4"
                                                                class="form-control form-control-sm roster-input roster-pot-name-input js-grid-nav rounded-0"
                                                                value="<?= esc($rawPotName) ?>"
                                                                placeholder="e.g. POT 1"
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
                                                                <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                            >
                                                                Simpan
                                                            </button>
                                                            <button
                                                                type="submit"
                                                                form="<?= esc($deleteFormId) ?>"
                                                                class="btn btn-sm btn-outline-danger app-btn rounded-0"
                                                                data-confirm-click="Hapus team ini langsung dari sistem?"
                                                                <?= $row['is_locked'] ? 'disabled' : '' ?>
                                                            >
                                                                Hapus
                                                            </button>
                                                        </div>
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
        <!-- TAB 2: SMART IMPORT ENGINE (PREVIEW & DYNAMIC MAPPING) -->
        <!-- ======================================================= -->
        <div class="tab-pane fade <?= ($activeTab ?? 'roster') === 'import' ? 'show active' : '' ?>" id="tab-import" role="tabpanel">
            <div class="card dashboard-card mb-3">
                <div class="card-header dashboard-card-header py-2 px-3 d-flex justify-content-between align-items-center">
                    <h2 class="h6 mb-0 text-white fw-bold">Langkah 1: Upload File (.CSV / .TSV / .TXT) atau Copy-Paste dari Excel / Google Sheets</h2>
                    <span class="badge bg-info text-dark">Smart Column Mapping</span>
                </div>
                <div class="card-body p-3">
                    <form id="hubFormParsePreview" enctype="multipart/form-data">
                        <div class="row g-3">
                            <div class="col-md-5">
                                <label class="form-label text-light small fw-bold">Opsi A: Pilih File (.csv / .tsv / .txt)</label>
                                <input type="file" name="team_file" class="form-control form-control-sm roster-input" accept=".csv,.tsv,.txt">
                                <div class="form-text text-muted" style="font-size: 0.72rem;">Header bebas! Anda bisa mencocokkan nama kolom di Langkah 2.</div>
                            </div>
                            <div class="col-md-7">
                                <label class="form-label text-light small fw-bold">Opsi B: Atau Paste Langsung Tabel dari Excel / Google Sheets</label>
                                <textarea name="raw_paste" rows="3" class="form-control form-control-sm roster-textarea" style="height: 68px !important;" placeholder="Nama Tim&#9;Kapten&#9;Member 2&#9;Member 3&#9;Pot&#10;RRQ Hoshi&#9;Skylar&#9;Sutsujin&#9;Idok&#9;POT 1"></textarea>
                            </div>
                            <div class="col-12 d-flex justify-content-end">
                                <button type="submit" id="btnHubParsePreview" class="btn btn-primary btn-sm px-4">
                                    Baca Header &amp; Tampilkan Preview
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- LANGKAH 2: MAPPING & PREVIEW TABLE -->
            <div class="card dashboard-card d-none" id="hubStepMappingCard">
                <div class="card-header dashboard-card-header py-2 px-3 d-flex justify-content-between align-items-center">
                    <h2 class="h6 mb-0 text-info fw-bold">Langkah 2: Cocokkan Kolom &amp; Alokasi Smart Pot</h2>
                    <span class="badge bg-primary" id="hubTotalRowsBadge">0 Baris</span>
                </div>
                <div class="card-body p-3">
                    <form id="hubFormCommitImport">
                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label class="quick-add-label">Pilih Tournament Tujuan *</label>
                                <select id="hubImportTournamentId" class="form-select form-select-sm roster-tournament-select" required>
                                    <option value="">-- Pilih Tournament --</option>
                                    <?php foreach ($tournaments as $tournament): ?>
                                            <option value="<?= esc((string) $tournament['id']) ?>" <?= (int) ($selectedTournamentId ?? 0) === (int) $tournament['id'] ? 'selected' : '' ?>>
                                                <?= esc($tournament['name']) ?>
                                            </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="quick-add-label">Mode Penempatan Pot</label>
                                <select id="hubImportMode" class="form-select form-select-sm roster-stage-select">
                                    <option value="smart_overflow" selected>⚡ Smart Auto-Overflow (Isi POT 1, lanjut POT 2 jika penuh)</option>
                                    <option value="unassigned">📤 Masukkan ke Unassigned (Tanpa Pot)</option>
                                    <option value="sandbox">🗑️ Masukkan ke Sandbox / Recycle Bin</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="quick-add-label">Stage Default</label>
                                <select id="hubImportStage" class="form-select form-select-sm roster-stage-select">
                                    <option value="kualifikasi" selected>Kualifikasi</option>
                                    <option value="semifinal">Semifinal</option>
                                    <option value="grandfinal">Grand Final</option>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label class="quick-add-label">Kolom Nama Tim (Wajib) *</label>
                                <select id="hubMapTeamName" class="form-select form-select-sm roster-stage-select" required></select>
                            </div>
                            <div class="col-md-4">
                                <label class="quick-add-label">Kolom Nama Pot (Opsional)</label>
                                <select id="hubMapPotName" class="form-select form-select-sm roster-stage-select"></select>
                            </div>
                            <div class="col-md-4">
                                <label class="quick-add-label">Kolom Stage (Opsional)</label>
                                <select id="hubMapStage" class="form-select form-select-sm roster-stage-select"></select>
                            </div>
                            <div class="col-12">
                                <label class="quick-add-label">Kolom Anggota / Roster Pemain (Centang Semua Kolom Pemain)</label>
                                <div id="hubMapMembersBox" class="p-2 border border-secondary d-flex flex-wrap gap-3" style="background:#0b1320;"></div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="quick-add-label">Preview 10 Baris Pertama</label>
                            <div class="preview-sheet-wrap">
                                <table class="preview-sheet-table" id="hubPreviewTable">
                                    <thead></thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center">
                            <span id="hubImportFeedback" class="small fw-bold text-info"></span>
                            <button type="submit" id="btnHubCommitImport" class="btn btn-success btn-sm px-4">
                                Mulai Import &amp; Alokasi Pot
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div>
</div>

<script <?= function_exists('csp_script_nonce') ? csp_script_nonce() : '' ?>>
document.addEventListener('DOMContentLoaded', () => {
    // 0. INJEKSI CSS KE <HEAD> AGAR TIDAK PERNAH BOCOR MENJADI TEKS MENTAH
    const rosterStyle = document.createElement('style');
    rosterStyle.textContent = [
        '.roster-hub-page, .roster-hub-page * { border-radius: 0 !important; }',
        '.roster-hub-page .hub-nav-tabs { border-bottom: 1px solid #26415f; padding-bottom: 0.35rem; }',
        '.roster-hub-page .hub-nav-tabs .nav-link { background: #142133; border: 1px solid #26415f; color: #94a3b8; padding: 0.35rem 0.9rem; font-weight: 600; font-size: 0.84rem; display: inline-flex; align-items: center; gap: 0.35rem; }',
        '.roster-hub-page .hub-nav-tabs .nav-link:hover { background: #1a2c42; color: #f1f5f9; border-color: #3b82f6; }',
        '.roster-hub-page .hub-nav-tabs .nav-link.active { background: #2563eb; color: #ffffff; border-color: #3b82f6; }',
        '.roster-hub-page .quick-add-card { background: #0d1726; border: 1px solid #26415f; border-left: 4px solid #2563eb; }',
        '.roster-hub-page .quick-add-label { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; color: #94a3b8; margin-bottom: 3px; display: block; }',
        '.roster-hub-page .roster-table { border-collapse: collapse !important; width: 100% !important; }',
        '.roster-hub-page .roster-table th, .roster-hub-page .roster-table td { padding: 0.25rem 0.45rem !important; vertical-align: middle !important; font-size: 0.82rem !important; line-height: 1.25 !important; border: 1px solid #1e3a5f !important; }',
        '.roster-hub-page .roster-table th { font-size: 0.74rem !important; text-transform: uppercase !important; letter-spacing: 0.04em !important; color: #94a3b8 !important; background: #0d1726 !important; font-weight: 700 !important; white-space: nowrap !important; }',
        '.roster-hub-page .roster-table tr:hover td { background-color: rgba(30, 41, 59, 0.45) !important; }',
        '.roster-hub-page .roster-row-modified td { background-color: rgba(59, 130, 246, 0.12) !important; border-left: 3px solid #3b82f6 !important; }',
        '.roster-hub-page .roster-row-sandbox td { background-color: rgba(180, 83, 9, 0.14) !important; }',
        '.roster-hub-page .roster-input, .roster-hub-page .roster-stage-select, .roster-hub-page .roster-tournament-select { background-color: #0b1320; border: 1px solid #26415f; color: #f8fafc; font-size: 0.82rem; height: 28px !important; min-height: 28px !important; padding: 0.15rem 0.4rem !important; }',
        '.roster-hub-page .roster-input:focus, .roster-hub-page .roster-stage-select:focus, .roster-hub-page .roster-tournament-select:focus { background-color: #0d1726; border-color: #3b82f6; color: #ffffff; box-shadow: none; outline: 1px solid #3b82f6; }',
        '.roster-hub-page textarea.roster-textarea { background-color: #0b1320; border: 1px solid #26415f; color: #f8fafc; font-size: 0.78rem; line-height: 1.2; padding: 0.25rem 0.4rem !important; }',
        '.roster-hub-page .roster-help { font-size: 0.68rem !important; color: #64748b; margin-top: 1px; line-height: 1.1; }',
        '.roster-hub-page .btn-sm { height: 28px !important; padding: 0.15rem 0.6rem !important; font-size: 0.76rem !important; line-height: 1.2 !important; font-weight: 600 !important; }',
        '.roster-hub-page .preview-sheet-wrap { max-height: 280px; overflow: auto; border: 1px solid #26415f; background: #09101d; }',
        '.roster-hub-page .preview-sheet-table { width: 100%; border-collapse: collapse; font-family: monospace; font-size: 0.76rem; }',
        '.roster-hub-page .preview-sheet-table th { background: #142133; color: #38bdf8; padding: 5px 8px; border: 1px solid #26415f; position: sticky; top: 0; white-space: nowrap; }',
        '.roster-hub-page .preview-sheet-table td { padding: 4px 8px; border: 1px solid #16263d; color: #cbd5e1; white-space: nowrap; }'
    ].join('\n');
    document.head.appendChild(rosterStyle);

    const toastEl = document.getElementById('rosterAjaxToast');
    function showToast(msg, isError = false) {
        if (!toastEl) return;
        toastEl.textContent = msg;
        toastEl.className = `alert ${isError ? 'alert-danger' : 'alert-success'} py-1 px-3 small d-flex align-items-center mb-2 rounded-0`;
        setTimeout(() => toastEl.classList.add('d-none'), 3500);
    }

    function getCsrfPair() {
        const input = document.querySelector('input[name="<?= csrf_token() ?>"]');
        return {
            name: '<?= csrf_token() ?>',
            hash: input ? input.value : (document.body.dataset.bgCsrfHash || '<?= csrf_hash() ?>')
        };
    }

    function syncCsrfHash(newHash) {
        if (!newHash) return;
        document.querySelectorAll('input[name="<?= csrf_token() ?>"]').forEach(el => { el.value = newHash; });
        document.body.dataset.bgCsrfHash = newHash;
    }

    /* 1. TOURNAMENT FILTER SYNC */
    const tournamentFilter = document.querySelector('.js-roster-tournament-filter');
    const url = new URL(window.location.href);
    tournamentFilter?.addEventListener('change', () => {
        const value = String(tournamentFilter.value || '').trim();
        url.searchParams.set('tournament_id', value === '' ? 'all' : value);
        window.location.href = url.toString();
    });

    /* 2. TAB SWITCHING */
    document.querySelectorAll('.js-go-import-tab').forEach((btn) => {
        btn.addEventListener('click', () => {
            const importTabBtn = document.getElementById('import-tab');
            if (importTabBtn) importTabBtn.click();
        });
    });

    /* 3. EXCEL KEYBOARD NAVIGATION (ArrowUp / ArrowDown / Enter) */
    const gridTable = document.getElementById('proRosterGridTable');
    if (gridTable) {
        gridTable.addEventListener('keydown', (e) => {
            const target = e.target;
            if (!target.classList.contains('js-grid-nav')) return;

            const currentRow = target.closest('tr[data-roster-row]');
            if (!currentRow) return;
            const col = target.getAttribute('data-grid-col');

            if (e.key === 'ArrowDown' || (e.key === 'Enter' && target.tagName !== 'SELECT')) {
                const openDd = currentRow.querySelector('.js-pot-dropdown.is-active');
                if (openDd && e.key === 'Enter') return;

                e.preventDefault();
                let nextTr = currentRow.nextElementSibling;
                while (nextTr && nextTr.hidden) {
                    nextTr = nextTr.nextElementSibling;
                }
                if (nextTr) {
                    const nextInput = nextTr.querySelector(`.js-grid-nav[data-grid-col="${col}"]`);
                    if (nextInput) {
                        nextInput.focus();
                        if (nextInput.select) nextInput.select();
                    }
                }
            } else if (e.key === 'ArrowUp' && target.tagName !== 'SELECT') {
                e.preventDefault();
                let prevTr = currentRow.previousElementSibling;
                while (prevTr && prevTr.hidden) {
                    prevTr = prevTr.previousElementSibling;
                }
                if (prevTr) {
                    const prevInput = prevTr.querySelector(`.js-grid-nav[data-grid-col="${col}"]`);
                    if (prevInput) {
                        prevInput.focus();
                        if (prevInput.select) prevInput.select();
                    }
                }
            }
        });
    }

    /* 4. CHANGE TRACKING & AJAX ZERO-RELOAD SAVE (BULK & SINGLE) */
    const bulkForm = document.getElementById('team-roster-bulk-form');
    const rows     = Array.from(document.querySelectorAll('[data-roster-row]'));
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
        const teamName   = row.querySelector('input[name$="[name]"]');
        const memberText = row.querySelector('input[name$="[member_text]"]');
        const tournament = row.querySelector('select[name$="[tournament_id]"]');
        const stage      = row.querySelector('select[name$="[stage]"]');
        const potName    = row.querySelector('input[name$="[pot_name]"]');

        return (
            String(teamName?.value || '').trim() !== String(row.dataset.originalName || '').trim() ||
            normalizeMemberText(memberText?.value || '') !== normalizeMemberText(row.dataset.originalMembers || '') ||
            String(tournament?.value || '').trim() !== String(row.dataset.originalTournamentId || '').trim() ||
            String(stage?.value || '').trim().toLowerCase() !== String(row.dataset.originalStage || '').trim().toLowerCase() ||
            String(potName?.value || '').trim() !== String(row.dataset.originalPotName || '').trim()
        );
    };

    const updateRowState = (row) => {
        const changed      = rowHasChanges(row);
        const changedField = row.querySelector('.js-roster-row-changed');
        if (changedField) changedField.value = changed ? '1' : '0';
        row.classList.toggle('roster-row-modified', changed);

        if (saveMeta) {
            const count = rows.filter(r => rowHasChanges(r)).length;
            saveMeta.textContent = `${count} perubahan siap disimpan`;
            saveMeta.classList.toggle('d-none', count === 0);
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

    bulkForm?.addEventListener('submit', async (e) => {
        e.preventDefault();
        const fd   = new FormData();
        const csrf = getCsrfPair();
        fd.append(csrf.name, csrf.hash);

        let targetRows = [];
        if (submitMode === 'single' && singleTargetTeamId) {
            fd.append('save_single_team_id', singleTargetTeamId);
            targetRows = rows.filter(r => String(r.dataset.teamId) === String(singleTargetTeamId));
        } else {
            targetRows = rows.filter(r => rowHasChanges(r));
        }

        if (targetRows.length === 0) {
            showToast('Belum ada perubahan data tim untuk disimpan.', true);
            return;
        }

        targetRows.forEach((row) => {
            const id = row.dataset.teamId;
            fd.append(`teams[${id}][__changed]`, '1');
            fd.append(`teams[${id}][name]`, row.querySelector('input[name$="[name]"]')?.value || '');
            fd.append(`teams[${id}][member_text]`, row.querySelector('input[name$="[member_text]"]')?.value || '');
            fd.append(`teams[${id}][tournament_id]`, row.querySelector('select[name$="[tournament_id]"]')?.value || '');
            fd.append(`teams[${id}][stage]`, row.querySelector('select[name$="[stage]"]')?.value || '');
            fd.append(`teams[${id}][pot_name]`, row.querySelector('input[name$="[pot_name]"]')?.value || '');
        });

        try {
            const res = await fetch(bulkForm.action, {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                body: fd
            });
            const data = await res.json();
            syncCsrfHash(data.csrfHash);

            if (!res.ok || data.status === 'error') {
                showToast(data.message || 'Gagal menyimpan perubahan.', true);
                return;
            }

            targetRows.forEach((row) => {
                row.dataset.originalName         = row.querySelector('input[name$="[name]"]')?.value || '';
                row.dataset.originalMembers      = row.querySelector('input[name$="[member_text]"]')?.value || '';
                row.dataset.originalTournamentId = row.querySelector('select[name$="[tournament_id]"]')?.value || '';
                row.dataset.originalStage        = row.querySelector('select[name$="[stage]"]')?.value || '';
                row.dataset.originalPotName      = row.querySelector('input[name$="[pot_name]"]')?.value || '';
                row.classList.toggle('roster-row-sandbox', row.dataset.originalStage === 'sandbox');
                updateRowState(row);
            });

            showToast(data.message || 'Perubahan berhasil disimpan!');
        } catch (err) {
            showToast('Kesalahan jaringan saat menyimpan.', true);
        }
    });

    /* 5. CHECKBOX BULK ACTIONS (SANDBOX / AUTO-OVERFLOW / DELETE SAFE) */
    const checkAllBox = document.getElementById('checkAllRosterRows');
    checkAllBox?.addEventListener('change', () => {
        rows.forEach((row) => {
            if (!row.hidden) {
                const cb = row.querySelector('.js-roster-row-check');
                if (cb) cb.checked = checkAllBox.checked;
            }
        });
    });

    document.getElementById('btnRunCheckedBulk')?.addEventListener('click', async () => {
        const action = document.getElementById('bulkCheckedActionSelect')?.value || '';
        const checkedIds = Array.from(document.querySelectorAll('.js-roster-row-check:checked')).map(cb => parseInt(cb.value, 10));

        if (!action || checkedIds.length === 0) {
            alert('Centang minimal 1 tim dan pilih aksi massal yang ingin dijalankan.');
            return;
        }
        if (action === 'delete_safe' && !confirm(`Hapus permanen ${checkedIds.length} tim beserta skor dan anggotanya?`)) {
            return;
        }

        const csrf = getCsrfPair();
        try {
            const res = await fetch('<?= site_url('teams/bulk-action') ?>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRF-TOKEN': csrf.hash
                },
                body: JSON.stringify({
                    action: action,
                    team_ids: checkedIds,
                    tournament_id: <?= (int) ($selectedTournamentId ?? 0) ?>,
                    [csrf.name]: csrf.hash
                })
            });
            const data = await res.json();
            syncCsrfHash(data.csrfHash);

            if (res.ok && data.status === 'success') {
                window.location.reload();
            } else {
                alert(data.message || 'Gagal memproses aksi massal.');
            }
        } catch (err) {
            alert('Kesalahan jaringan.');
        }
    });

    /* 6. REAL-TIME TOKENIZED SEARCH */
    const searchShell = document.querySelector('.js-roster-search-shell');
    if (searchShell) {
        const searchInput = searchShell.querySelector('.js-roster-search-input');
        const clearBtn    = searchShell.querySelector('.js-roster-search-clear');
        const searchMeta  = document.querySelector('.js-roster-search-meta');
        const emptyState  = document.querySelector('.js-roster-search-empty');
        const totalRows   = rows.length;

        const normalize = (val) => String(val || '').toLowerCase().replace(/[^\w\s]/g, ' ').replace(/\s+/g, ' ').trim();
        const indexedRows = rows.map((row) => {
            const raw = normalize(String(row.getAttribute('data-search-text') || ''));
            return { row, raw, tokens: raw.split(' ').filter(Boolean) };
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
                const matched = terms.every((term) => item.raw.includes(term) || item.tokens.some((t) => t.startsWith(term)));
                item.row.hidden = !matched;
                if (matched) visibleCount++;
            });
            if (searchMeta) searchMeta.textContent = `${visibleCount} hasil`;
            if (emptyState) emptyState.classList.toggle('d-none', visibleCount > 0);
        };

        searchInput?.addEventListener('input', executeSearch);
        clearBtn?.addEventListener('click', () => {
            if (!searchInput) return;
            searchInput.value = '';
            executeSearch();
        });
    }

    /* 7. SMART IMPORT ENGINE DI TAB 2 */
    let hubParsedRows = [];
    const hubFormParse  = document.getElementById('hubFormParsePreview');
    const hubFormCommit = document.getElementById('hubFormCommitImport');
    const hubStepCard   = document.getElementById('hubStepMappingCard');

    function populateHubColSelect(sel, headers, guessedIdx, allowIgnore = true) {
        sel.innerHTML = '';
        if (allowIgnore) {
            const opt0 = document.createElement('option');
            opt0.value = '-1';
            opt0.textContent = '-- Abaikan --';
            sel.appendChild(opt0);
        }
        headers.forEach((h, i) => {
            const opt = document.createElement('option');
            opt.value = String(i);
            opt.textContent = `[Kolom ${i + 1}] ${h}`;
            if (i === guessedIdx) opt.selected = true;
            sel.appendChild(opt);
        });
    }

    hubFormParse?.addEventListener('submit', async (e) => {
        e.preventDefault();
        const csrf = getCsrfPair();
        const fd   = new FormData(hubFormParse);
        fd.append(csrf.name, csrf.hash);

        try {
            const res  = await fetch('<?= site_url('imports/raw-csv/preview') ?>', {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                body: fd
            });
            const data = await res.json();
            syncCsrfHash(data.csrfHash);

            if (!res.ok || data.status !== 'success') {
                alert(data.message || 'Gagal membaca preview file.');
                return;
            }

            hubParsedRows = data.all_rows || [];
            document.getElementById('hubTotalRowsBadge').textContent = `${data.total_rows} Baris`;
            const guess = data.auto_map || {};

            populateHubColSelect(document.getElementById('hubMapTeamName'), data.headers, guess.team_name >= 0 ? guess.team_name : 0, false);
            populateHubColSelect(document.getElementById('hubMapPotName'), data.headers, guess.pot_name ?? -1, true);
            populateHubColSelect(document.getElementById('hubMapStage'), data.headers, guess.stage ?? -1, true);

            const memBox = document.getElementById('hubMapMembersBox');
            memBox.innerHTML = '';
            data.headers.forEach((h, i) => {
                const lbl = document.createElement('label');
                lbl.className = 'small text-light d-flex align-items-center gap-1';
                const cb = document.createElement('input');
                cb.type = 'checkbox';
                cb.value = String(i);
                cb.className = 'js-hub-member-col';
                if (Array.isArray(guess.members) && guess.members.includes(i)) cb.checked = true;
                lbl.appendChild(cb);
                lbl.appendChild(document.createTextNode(`[${i + 1}] ${h}`));
                memBox.appendChild(lbl);
            });

            const tbl   = document.getElementById('hubPreviewTable');
            const thead = tbl.querySelector('thead');
            const tbody = tbl.querySelector('tbody');
            thead.innerHTML = '';
            tbody.innerHTML = '';

            const trH = document.createElement('tr');
            data.headers.forEach((h, i) => {
                const th = document.createElement('th');
                th.textContent = `[${i + 1}] ${h}`;
                trH.appendChild(th);
            });
            thead.appendChild(trH);

            (data.preview_rows || []).forEach(r => {
                const tr = document.createElement('tr');
                data.headers.forEach((_, idx) => {
                    const td = document.createElement('td');
                    td.textContent = r[idx] ?? '';
                    tr.appendChild(td);
                });
                tbody.appendChild(tr);
            });

            hubStepCard.classList.remove('d-none');
        } catch (err) {
            alert('Gagal memproses preview.');
        }
    });

    hubFormCommit?.addEventListener('submit', async (e) => {
        e.preventDefault();
        const csrf       = getCsrfPair();
        const fb         = document.getElementById('hubImportFeedback');
        const memberCols = Array.from(document.querySelectorAll('.js-hub-member-col:checked')).map(cb => parseInt(cb.value, 10));

        fb.textContent = 'Sedang mengimpor dan mengalokasikan tim...';
        try {
            const res = await fetch('<?= site_url('imports/raw-csv/process') ?>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRF-TOKEN': csrf.hash
                },
                body: JSON.stringify({
                    tournament_id: document.getElementById('hubImportTournamentId').value,
                    import_mode:   document.getElementById('hubImportMode').value,
                    stage:         document.getElementById('hubImportStage').value,
                    mapping: {
                        team_name: parseInt(document.getElementById('hubMapTeamName').value, 10),
                        pot_name:  parseInt(document.getElementById('hubMapPotName').value, 10),
                        stage:     parseInt(document.getElementById('hubMapStage').value, 10),
                        members:   memberCols
                    },
                    rows: hubParsedRows,
                    [csrf.name]: csrf.hash
                })
            });
            const data = await res.json();
            syncCsrfHash(data.csrfHash);

            if (res.ok && data.status === 'success') {
                fb.textContent = data.message;
                setTimeout(() => { window.location.href = data.redirectUrl; }, 900);
            } else {
                fb.textContent = data.message || 'Gagal mengimpor.';
            }
        } catch (err) {
            fb.textContent = 'Kesalahan jaringan.';
        }
    });
});
</script>

<?= $this->endSection() ?>