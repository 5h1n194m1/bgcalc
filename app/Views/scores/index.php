<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<?php
$status = $tournament['status'] ?? 'belum_mulai';
$statusLabel = $statusOptions[$status] ?? ucwords(str_replace('_', ' ', $status));
$statusClass = match ($status) {
    'start' => 'status-chip-live',
    'selesai' => 'status-chip-finished',
    default => 'status-chip-standby',
};
$isAdmin = auth()->user()?->inGroup('admin') ?? false;
$currentStatusValue = (string) ($tournament['status'] ?? 'belum_mulai');

// Pengelompokan Pot berdasarkan Stage
$groupedPotModules = [];
foreach ($potModules as $module) {
    $stage = strtolower(trim((string) ($module['pot']['stage'] ?? 'kualifikasi')));
    $groupedPotModules[$stage][] = $module;
}

$stageTitles = [
    'kualifikasi' => 'Kualifikasi',
    'semifinal' => 'Semifinal',
    'grandfinal' => 'Grand Final',
];
?>

<style <?= function_exists('csp_style_nonce') ? csp_style_nonce() : '' ?>>
/* ==========================================================================
   PRO SPREADSHEET / EXCEL WORKSPACE ENGINE
   ========================================================================== */
#scorePageHost {
    --excel-bg: #070d14;
    --excel-panel: #0b1320;
    --excel-header: #111c2d;
    --excel-subheader: #0e1726;
    --excel-border: #1e324a;
    --excel-border-strong: #2c4769;
    --excel-cell-bg: #09101a;
    --excel-cell-zebra: #0c1522;
    --excel-cell-hover: #132238;
    --excel-focus: #3b82f6;
    --excel-text: #f1f5f9;
    --excel-muted: #64748b;
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
}

/* -- Compact Top Command Bar -- */
.excel-command-bar {
    background: var(--excel-panel);
    border: 1px solid var(--excel-border-strong);
    border-left: 4px solid var(--excel-focus);
    padding: 10px 14px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
    margin-bottom: 12px;
}

.excel-title-form {
    display: flex;
    align-items: center;
    gap: 8px;
    flex: 1 1 320px;
    min-width: 0;
}

.excel-tourney-input {
    background: #070d14 !important;
    border: 1px solid var(--excel-border) !important;
    color: #f8fafc !important;
    font-size: 1rem !important;
    font-weight: 800 !important;
    padding: 5px 10px !important;
    height: 34px !important;
    letter-spacing: 0.03em;
    text-transform: uppercase;
    flex: 1;
    min-width: 180px;
}

.excel-tourney-input:focus {
    border-color: var(--excel-focus) !important;
    outline: none !important;
}

.excel-command-actions {
    display: flex;
    align-items: center;
    gap: 6px;
    flex-wrap: wrap;
}

/* -- Stage Navigation Tabs & Quick Pot Jump -- */
.excel-stage-nav {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    flex-wrap: wrap;
    background: #09101a;
    border: 1px solid var(--excel-border);
    padding: 6px 10px;
    margin-bottom: 14px;
}

.excel-stage-tabs {
    display: flex;
    align-items: center;
    gap: 4px;
    flex-wrap: wrap;
}

.excel-stage-tab {
    background: transparent;
    border: 1px solid transparent;
    color: #94a3b8;
    font-size: 0.75rem;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    padding: 5px 12px;
    cursor: pointer;
}

.excel-stage-tab:hover {
    color: #f8fafc;
    background: #142233;
}

.excel-stage-tab.is-active {
    background: #1d4ed8;
    border-color: #3b82f6;
    color: #ffffff;
}

.excel-pot-jumps {
    display: flex;
    align-items: center;
    gap: 4px;
    flex-wrap: wrap;
}

.excel-pot-jump-link {
    font-size: 0.72rem;
    font-weight: 700;
    padding: 3px 8px;
    background: #111c2d;
    border: 1px solid var(--excel-border);
    color: #cbd5e1;
    text-decoration: none;
}

.excel-pot-jump-link:hover,
.excel-pot-jump-link.is-current {
    border-color: #38bdf8;
    color: #38bdf8;
    background: rgba(56, 189, 248, 0.1);
}

/* -- Stage Divider Header -- */
.excel-stage-section {
    display: flex;
    flex-direction: column;
    gap: 16px;
    margin-bottom: 24px;
}

.excel-stage-banner {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 12px;
    background: linear-gradient(90deg, rgba(37, 99, 235, 0.18), transparent);
    border-left: 3px solid #38bdf8;
    border-bottom: 1px solid var(--excel-border);
}

.excel-stage-banner h4 {
    margin: 0;
    font-size: 0.8rem;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: #38bdf8;
}

/* -- Pot Ribbon Header -- */
.excel-pot-card {
    background: var(--excel-panel) !important;
    border: 1px solid var(--excel-border-strong) !important;
    margin-bottom: 0 !important;
}

.excel-pot-card.pot-module-current {
    border-color: #3b82f6 !important;
}

.excel-pot-ribbon {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    flex-wrap: wrap;
    padding: 8px 12px;
    background: var(--excel-header);
    border-bottom: 1px solid var(--excel-border);
}

.excel-pot-identity {
    display: flex;
    align-items: center;
    gap: 6px;
}

.excel-pot-order-badge {
    display: inline-flex;
    align-items: center;
    background: #070d14;
    border: 1px solid var(--excel-border-strong);
    height: 30px;
    padding: 0 6px;
    gap: 4px;
}

.excel-pot-order-badge span {
    font-size: 0.65rem;
    font-weight: 800;
    color: #64748b;
    text-transform: uppercase;
}

.excel-pot-order-badge input {
    width: 36px !important;
    height: 24px !important;
    min-height: 24px !important;
    padding: 0 !important;
    border: none !important;
    background: transparent !important;
    color: #38bdf8 !important;
    font-weight: 800 !important;
    font-size: 0.85rem !important;
    text-align: center !important;
}

.excel-pot-title-input {
    height: 30px !important;
    min-height: 30px !important;
    width: 210px !important;
    background: #070d14 !important;
    border: 1px solid var(--excel-border-strong) !important;
    color: #f8fafc !important;
    font-size: 0.88rem !important;
    font-weight: 800 !important;
    padding: 0 10px !important;
    text-transform: uppercase;
    letter-spacing: 0.04em;
}

.excel-pot-toolbar {
    display: flex;
    align-items: center;
    gap: 4px;
    flex-wrap: wrap;
    flex: 1;
    justify-content: flex-end;
}

.excel-btn-divider {
    width: 1px;
    height: 20px;
    background: var(--excel-border-strong);
    margin: 0 3px;
}

/* -- SPREADSHEET GRID TABLE -- */
.excel-table-container {
    width: 100%;
    overflow-x: auto;
    background: var(--excel-cell-bg);
}

table.excel-spreadsheet {
    width: 100%;
    border-collapse: collapse !important;
    table-layout: fixed;
    margin: 0 !important;
    font-variant-numeric: tabular-nums;
}

table.excel-spreadsheet th,
table.excel-spreadsheet td {
    border: 1px solid var(--excel-border) !important;
    padding: 0 !important;
    height: 30px !important;
    vertical-align: middle !important;
    position: relative;
}

/* Header Cells */
table.excel-spreadsheet thead th {
    background: var(--excel-header) !important;
    color: #cbd5e1 !important;
    font-size: 0.72rem !important;
    font-weight: 800 !important;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    text-align: center;
    user-select: none;
    height: 26px !important;
}

table.excel-spreadsheet thead th.game-group-head {
    background: #16243a !important;
    color: #38bdf8 !important;
    border-bottom: 1px solid var(--excel-border-strong) !important;
    font-size: 0.74rem !important;
}

table.excel-spreadsheet thead th.game-subhead {
    background: var(--excel-subheader) !important;
    color: #94a3b8 !important;
    font-size: 0.65rem !important;
    height: 22px !important;
}

/* Zebra Striping & Active Row Highlight */
table.excel-spreadsheet tbody tr:nth-child(odd) td {
    background-color: var(--excel-cell-bg);
}
table.excel-spreadsheet tbody tr:nth-child(even) td {
    background-color: var(--excel-cell-zebra);
}
table.excel-spreadsheet tbody tr:hover td,
table.excel-spreadsheet tbody tr.is-active-row td {
    background-color: var(--excel-cell-hover) !important;
}

/* Row Number Cell (Excel Row Header Style) */
table.excel-spreadsheet td.score-no-col {
    background: var(--excel-header) !important;
    color: #64748b !important;
    font-family: ui-monospace, SFMono-Regular, Consolas, monospace;
    font-size: 0.75rem !important;
    font-weight: 700 !important;
    text-align: center;
    user-select: none;
    width: 38px !important;
    min-width: 38px !important;
}

table.excel-spreadsheet tbody tr.is-active-row td.score-no-col {
    background: #1d4ed8 !important;
    color: #ffffff !important;
}

/* Seamless Cell Inputs (Rank, Kill, Team Name) */
table.excel-spreadsheet input.score-input,
table.excel-spreadsheet input.team-name-input {
    width: 100% !important;
    height: 29px !important;
    min-height: 29px !important;
    border: none !important;
    background: transparent !important;
    color: var(--excel-text) !important;
    padding: 0 6px !important;
    margin: 0 !important;
    box-shadow: none !important;
    outline: none !important;
    font-size: 0.82rem !important;
}

table.excel-spreadsheet input.score-input {
    text-align: center !important;
    font-family: ui-monospace, SFMono-Regular, Consolas, monospace;
    font-weight: 700 !important;
    padding: 0 2px !important;
}

table.excel-spreadsheet input.team-name-input {
    font-weight: 600 !important;
    text-align: left !important;
}

/* Excel Active Cell Outline on Focus */
table.excel-spreadsheet input.score-input:focus,
table.excel-spreadsheet input.team-name-input:focus {
    background: #050a11 !important;
    outline: 2px solid var(--excel-focus) !important;
    outline-offset: -2px !important;
    color: #ffffff !important;
    z-index: 5;
    position: relative;
}

/* Calculated Placement & Total Cells */
table.excel-spreadsheet td.score-placement-cell {
    background: rgba(15, 23, 42, 0.75) !important;
    color: #64748b !important;
    font-family: ui-monospace, SFMono-Regular, Consolas, monospace;
    font-size: 0.76rem !important;
    font-weight: 700 !important;
    text-align: center;
    user-select: none;
}

table.excel-spreadsheet td.score-total-cell {
    background: rgba(14, 116, 144, 0.14) !important;
    color: #38bdf8 !important;
    font-family: ui-monospace, SFMono-Regular, Consolas, monospace;
    font-size: 0.86rem !important;
    font-weight: 800 !important;
    text-align: center;
    user-select: none;
}

/* Top 3 Standings Highlight on Total Cell */
table.excel-spreadsheet tbody tr:nth-child(1) td.score-no-col { border-left: 3px solid #facc15 !important; }
table.excel-spreadsheet tbody tr:nth-child(2) td.score-no-col { border-left: 3px solid #cbd5e1 !important; }
table.excel-spreadsheet tbody tr:nth-child(3) td.score-no-col { border-left: 3px solid #d97706 !important; }

/* Shortcut Hint Footer */
.excel-statusbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 5px 10px;
    background: #080e17;
    border-top: 1px solid var(--excel-border);
    font-size: 0.7rem;
    color: #64748b;
}

.excel-kbd {
    background: #142233;
    border: 1px solid #2c4769;
    color: #cbd5e1;
    padding: 1px 5px;
    font-family: monospace;
    font-size: 0.66rem;
}
</style>

<div class="score-page-shell" id="scorePageHost" data-current-tournament-id="<?= esc((string) $tournament['id']) ?>">
    
    <!-- ================= TOP COMPACT COMMAND BAR ================= -->
    <div class="excel-command-bar">
        <form action="<?= site_url('tournaments/update/' . $tournament['id']) ?>" method="post" class="excel-title-form">
            <?= csrf_field() ?>
            <input type="hidden" name="status" value="<?= esc($currentStatusValue) ?>">
            <input type="hidden" name="redirect_to" value="<?= esc(current_url()) ?>">
            
            <span class="status-chip <?= esc($statusClass) ?>" style="min-height: 32px; padding: 0 10px;">
                <span class="status-chip-dot" aria-hidden="true"></span>
                <?= esc($statusLabel) ?>
            </span>

            <input
                type="text"
                name="name"
                class="form-control excel-tourney-input"
                value="<?= esc($tournament['name']) ?>"
                title="Klik untuk ubah nama turnamen"
                <?= $canManage ? '' : 'readonly' ?>
            >
            <?php if ($canManage): ?>
                    <button type="submit" class="btn btn-outline-primary btn-sm app-btn controller-only" title="Simpan Nama Turnamen">
                        Simpan Judul
                    </button>
            <?php endif; ?>
        </form>

        <div class="excel-command-actions">
            <?php if ($isAdmin): ?>
                    <button type="button" class="btn btn-outline-primary btn-sm app-btn controller-only" data-bs-toggle="modal" data-bs-target="#statusTournamentModal">
                        Status
                    </button>
            <?php endif; ?>

            <a href="<?= site_url('leaderboard/pot/' . $currentPotId) ?>" class="btn btn-outline-info btn-sm app-btn controller-only">
                Leaderboard
            </a>

            <a href="<?= site_url('teams/export-template?tournament_id=' . (int) $tournament['id']) ?>" class="btn btn-outline-primary btn-sm app-btn controller-only">
                Export CSV
            </a>

            <?php if ($canManage): ?>
                    <button type="button" class="btn btn-primary btn-sm app-btn controller-only" data-bs-toggle="modal" data-bs-target="#addPotModal">
                        + Buat Pot
                    </button>
            <?php endif; ?>

            <div class="score-text-zoom controller-only" aria-label="Kontrol ukuran teks">
                <button type="button" class="btn btn-outline-secondary btn-sm app-btn js-score-text-zoom" data-zoom-action="decrease" title="Perkecil Tabel">A-</button>
                <button type="button" class="btn btn-outline-secondary btn-sm app-btn js-score-text-zoom" data-zoom-action="reset" title="Ukuran Normal">100%</button>
                <button type="button" class="btn btn-outline-secondary btn-sm app-btn js-score-text-zoom" data-zoom-action="increase" title="Perbesar Tabel">A+</button>
            </div>

            <button type="button" class="btn btn-outline-secondary btn-sm app-btn js-team-manager-toggle controller-only" data-team-manager-toggle="scoreTeamManagerPanel" aria-controls="scoreTeamManagerPanel" aria-expanded="false" <?= $canManage ? '' : 'disabled' ?>>
                Team Manager
            </button>

            <button type="button" class="btn btn-outline-secondary btn-sm app-btn js-hide-controller controller-only" title="Mode Presentasi / Screenshot Bersih">
                Mode Bersih
            </button>
            <button type="button" class="btn btn-primary btn-sm app-btn js-show-controller" hidden>
                Tampilkan Kontrol
            </button>
        </div>
    </div>

    <!-- ================= STAGE SWITCHER & QUICK POT JUMP ================= -->
    <div class="excel-stage-nav controller-only">
        <div class="excel-stage-tabs" id="excelStageTabs">
            <button type="button" class="excel-stage-tab is-active" data-stage-filter="all">
                Semua Tahapan (<?= count($potModules) ?> Pot)
            </button>
            <?php foreach ($groupedPotModules as $sKey => $mods): ?>
                    <button type="button" class="excel-stage-tab" data-stage-filter="<?= esc($sKey) ?>">
                        <?= esc($stageTitles[$sKey] ?? ucfirst($sKey)) ?> (<?= count($mods) ?>)
                    </button>
            <?php endforeach; ?>
        </div>

        <div class="excel-pot-jumps">
            <span style="font-size: 0.7rem; color: #64748b; font-weight: 700; text-transform: uppercase; margin-right: 4px;">Lompat ke:</span>
            <?php foreach ($potModules as $m): ?>
                    <a href="#pot-card-<?= esc((string) $m['pot']['id']) ?>" class="excel-pot-jump-link<?= !empty($m['isCurrent']) ? ' is-current' : '' ?>">
                        <?= esc($m['pot']['name']) ?>
                    </a>
            <?php endforeach; ?>
        </div>
    </div>

    <?php if (!$canManage): ?>
            <div class="score-lock-banner mb-3">
                <strong>Mode Baca (Read-Only).</strong> Turnamen telah selesai dan seluruh perhitungan skor dikunci.
            </div>
    <?php endif; ?>

    <!-- ================= MAIN WORKSPACE ================= -->
    <div class="score-page-workspace" id="scorePageWorkspace">
        <div class="score-page-main">
            <div class="pot-module-stack">
                <?php foreach ($groupedPotModules as $stageName => $modulesInStage): ?>
                        <div class="excel-stage-section js-stage-section" data-stage-key="<?= esc($stageName) ?>">
                            <div class="excel-stage-banner">
                                <h4>Tahapan: <?= esc($stageTitles[$stageName] ?? ucfirst($stageName)) ?></h4>
                                <span style="font-size: 0.72rem; color: #94a3b8; font-weight: 700;"><?= count($modulesInStage) ?> Pot Aktif</span>
                            </div>

                            <?php foreach ($modulesInStage as $module): ?>
                                    <?= view('scores/_calculator', [
                                        'pot' => $module['pot'],
                                        'teams' => $module['teams'],
                                        'membersByTeam' => $module['membersByTeam'],
                                        'memberTextByTeam' => $module['memberTextByTeam'],
                                        'scoresByTeam' => $module['scoresByTeam'],
                                        'totalsByTeam' => $module['totalsByTeam'],
                                        'gameNos' => $module['gameNos'],
                                        'placementMap' => $placementMap,
                                        'canManage' => $canManage,
                                        'isCurrent' => $module['isCurrent'],
                                        'showCardWrapper' => true,
                                        'cardBodyClass' => 'card-body pot-module-body p-2',
                                        'tournamentId' => $tournament['id'],
                                        'tournamentName' => $tournament['name'],
                                        'pointSystem' => $tournament['point_system'],
                                        'killPoints' => $tournament['kill_points'],
                                        'customPoints' => $tournament['custom_placement_points'],
                                    ]) ?>
                            <?php endforeach; ?>
                        </div>
                <?php endforeach; ?>
            </div>
        </div>

        <div class="score-side-panel">
            <aside id="scoreTeamManagerPanel" class="score-team-manager-panel" data-open="0" hidden>
                <?= view('teams/_manager_workspace', [
                    'managerId' => 'score-cms-manager',
                    'managerContext' => 'score',
                    'managerTitle' => 'Mini Team Manager',
                    'managerDescription' => 'Kelola team dan pindahkan ke pot tanpa pindah halaman.',
                    'tournaments' => $tournaments,
                    'pots' => $managerPots,
                    'selectedTournamentId' => (int) $tournament['id'],
                    'selectedPotId' => (int) $currentPotId,
                    'currentTournamentId' => (int) $tournament['id'],
                    'currentPotId' => (int) $currentPotId,
                    'canManage' => $canManage,
                    'allowUnassigned' => false,
                    'showTournamentFilter' => false,
                    'fixedTournamentId' => (int) $tournament['id'],
                ]) ?>
            </aside>
        </div>
    </div>
</div>

<!-- SCRIPT NAVIGASI KEYBOARD SPREADSHEET (PANAH, ENTER, AUTO-SELECT, STAGE FILTER) -->
<script <?= function_exists('csp_script_nonce') ? csp_script_nonce() : '' ?>>
(function () {
    'use strict';

    // 1. Filter Tab Tahapan (Kualifikasi / Semifinal / Grand Final)
    var stageTabs = document.querySelectorAll('#excelStageTabs .excel-stage-tab');
    stageTabs.forEach(function (tab) {
        tab.addEventListener('click', function () {
            stageTabs.forEach(function (t) { t.classList.remove('is-active'); });
            tab.classList.add('is-active');

            var filter = tab.getAttribute('data-stage-filter') || 'all';
            document.querySelectorAll('.js-stage-section').forEach(function (sec) {
                var key = sec.getAttribute('data-stage-key');
                sec.style.display = (filter === 'all' || filter === key) ? 'flex' : 'none';
            });
        });
    });

    // 2. Highlight Baris Aktif & Auto-Select Angka Saat Fokus (Gaya Excel)
    document.addEventListener('focusin', function (e) {
        var input = e.target;
        if (!input || input.tagName !== 'INPUT') return;

        var row = input.closest('tr[data-team-row]');
        if (row) {
            var table = row.closest('table');
            if (table) {
                table.querySelectorAll('tr.is-active-row').forEach(function (r) {
                    r.classList.remove('is-active-row');
                });
            }
            row.classList.add('is-active-row');
        }

        // Auto-select isi sel saat diklik/difokuskan agar langsung ketik timpa
        if (input.classList.contains('js-score-input')) {
            setTimeout(function () { input.select(); }, 10);
        }
    });

    // 3. Navigasi Keyboard Spreadsheet (Enter = Turun Baris, Panah = Pindah Sel)
    document.addEventListener('keydown', function (e) {
        var input = e.target;
        if (!input || !input.classList.contains('js-score-input')) return;

        var td = input.closest('td');
        var tr = input.closest('tr[data-team-row]');
        var tbody = tr ? tr.closest('tbody') : null;
        if (!td || !tr || !tbody) return;

        var key = e.key;
        if (!['Enter', 'ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(key)) {
            return;
        }

        var allRows = Array.from(tbody.querySelectorAll('tr[data-team-row]'));
        var rowIndex = allRows.indexOf(tr);
        var rowInputs = Array.from(tr.querySelectorAll('input.js-score-input'));
        var colIndex = rowInputs.indexOf(input);

        // Tekan Enter atau ArrowDown -> Pindah ke baris di bawahnya pada kolom yang sama
        if (key === 'Enter' || key === 'ArrowDown') {
            e.preventDefault();
            var nextRow = allRows[rowIndex + 1];
            if (nextRow) {
                var nextInputs = nextRow.querySelectorAll('input.js-score-input');
                if (nextInputs[colIndex]) nextInputs[colIndex].focus();
            } else if (key === 'Enter' && allRows[0]) {
                // Jika sudah di baris paling bawah dan tekan Enter, pindah ke kolom berikutnya di baris pertama
                var firstRowInputs = allRows[0].querySelectorAll('input.js-score-input');
                if (firstRowInputs[colIndex + 1]) firstRowInputs[colIndex + 1].focus();
            }
            return;
        }

        // Tekan ArrowUp -> Pindah ke baris di atasnya pada kolom yang sama
        if (key === 'ArrowUp') {
            e.preventDefault();
            var prevRow = allRows[rowIndex - 1];
            if (prevRow) {
                var prevInputs = prevRow.querySelectorAll('input.js-score-input');
                if (prevInputs[colIndex]) prevInputs[colIndex].focus();
            }
            return;
        }

        // Tekan ArrowRight -> Pindah ke input skor sebelah kanan
        if (key === 'ArrowRight') {
            e.preventDefault();
            if (rowInputs[colIndex + 1]) {
                rowInputs[colIndex + 1].focus();
            }
            return;
        }

        // Tekan ArrowLeft -> Pindah ke input skor sebelah kiri
        if (key === 'ArrowLeft') {
            e.preventDefault();
            if (rowInputs[colIndex - 1]) {
                rowInputs[colIndex - 1].focus();
            }
            return;
        }
    });
})();
</script>
<?= $this->endSection() ?>

<?= $this->section('modals') ?>
    <?php if ($canManage): ?>
            <div class="modal fade" id="addPotModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-sm">
                    <div class="modal-content" style="border-radius: 0; background: var(--app-surface); border: 1px solid var(--app-border-strong);">
                        <form action="<?= site_url('pots/store') ?>" method="post">
                            <?= csrf_field() ?>
                            <input type="hidden" name="tournament_id" value="<?= esc((string) $tournament['id']) ?>">
                            <input type="hidden" name="redirect_to" value="__new_pot_scores__">

                            <div class="modal-header" style="border-bottom: 1px solid var(--app-border);">
                                <h2 class="modal-title fs-6" style="color: var(--app-text); font-weight: 800;">Buat Pot Baru</h2>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label" style="font-size: 0.8rem; font-weight: 700; color: var(--app-text-muted);">TAHAPAN (STAGE)</label>
                                    <select name="stage" class="form-select" required>
                                        <option value="kualifikasi" selected>Kualifikasi</option>
                                        <option value="semifinal">Semifinal</option>
                                        <option value="grandfinal">Grand Final</option>
                                    </select>
                                </div>
                            
                                <div class="mb-2">
                                    <label class="form-label" style="font-size: 0.8rem; font-weight: 700; color: var(--app-text-muted);">NAMA POT (Opsional)</label>
                                    <input type="text" name="name" class="form-control" placeholder="Otomatis (Misal: POT 3)">
                                </div>
                            </div>

                            <div class="modal-footer" style="border-top: 1px solid var(--app-border);">
                                <button type="button" class="btn btn-outline-secondary btn-sm app-btn" data-bs-dismiss="modal">Batal</button>
                                <button type="submit" class="btn btn-primary btn-sm app-btn">Buat Pot</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
    <?php endif; ?>

    <?php if ($isAdmin): ?>
            <div class="modal fade" id="statusTournamentModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-sm">
                    <div class="modal-content">
                        <form action="<?= site_url('tournaments/update-status/' . $tournament['id']) ?>" method="post">
                            <?= csrf_field() ?>
                            <input type="hidden" name="redirect_to" value="<?= current_url() ?>">

                            <div class="modal-header">
                                <h2 class="modal-title fs-6">Status Turnamen</h2>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                            <div class="modal-body">
                                <label class="form-label">Status</label>
                                <select name="status" class="form-select" required>
                                    <?php foreach ($statusOptions as $statusKey => $label): ?>
                                            <option value="<?= esc($statusKey) ?>" <?= $status === $statusKey ? 'selected' : '' ?>>
                                                <?= esc($label) ?>
                                            </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary btn-sm app-btn" data-bs-dismiss="modal">Batal</button>
                                <button type="submit" class="btn btn-primary btn-sm app-btn">Simpan Status</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
    <?php endif; ?>
<?= $this->endSection() ?>