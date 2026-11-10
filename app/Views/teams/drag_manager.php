<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<div id="ddmApp"
    style="color: #e2e8f0; width: 100%; padding-bottom: 48px; font-family: system-ui, -apple-system, sans-serif;">

    <!-- ================= TOP TOOLBAR ================= -->
    <div
        style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 20px; padding: 16px 20px; background: #0f172a; border: 1px solid #334155; border-left: 4px solid #3b82f6;">
        <div>
            <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                <h1
                    style="margin: 0; font-size: 1.15rem; font-weight: 800; color: #f8fafc; text-transform: uppercase; letter-spacing: 0.05em;">
                    Drag &amp; Drop Team Manager
                </h1>
                <span id="ddmEngineBadge"
                    style="font-size: 0.7rem; font-weight: 800; padding: 3px 10px; text-transform: uppercase; letter-spacing: 0.05em; background: rgba(22, 163, 74, 0.15); color: #4ade80; border: 1px solid #16a34a;">
                    READY
                </span>
            </div>
            <p style="margin: 6px 0 0 0; font-size: 0.78rem; color: #94a3b8;">
                Gunakan <strong>Sandbox / Recycle Bin</strong> untuk menyingkirkan sementara tim cadangan tanpa menghapusnya dari database, atau aktifkan <strong>Mode Promosi</strong> untuk lolos babak.
            </p>
        </div>

        <!-- CONTROLS & SAVE BUTTON -->
        <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
            
            <!-- Saklar Mode Drag: Pindah vs Promosi Multi-Pot -->
            <div style="display: flex; align-items: center; gap: 6px; background: #0b1120; padding: 6px 10px; border: 1px solid #334155;">
                <label for="ddmDragMode" style="font-size: 0.72rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; white-space: nowrap;">
                    Mode Tarik:
                </label>
                <select id="ddmDragMode" style="background: #1e293b; color: #38bdf8; border: 1px solid #475569; padding: 5px 10px; font-size: 0.8rem; font-weight: 800; outline: none; cursor: pointer;">
                    <option value="move">Pindah Pot Biasa (Move)</option>
                    <option value="promote">Promosi / Lolos Babak (Multi-Pot Copy)</option>
                </select>
            </div>

            <!-- Filter Fokus Turnamen -->
            <div style="display: flex; align-items: center; gap: 6px; background: #0b1120; padding: 6px 10px; border: 1px solid #334155;">
                <label for="ddmTourneyFilter" style="font-size: 0.72rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; white-space: nowrap;">
                    Turnamen:
                </label>
                <select id="ddmTourneyFilter" style="background: #1e293b; color: #f8fafc; border: 1px solid #475569; padding: 5px 10px; font-size: 0.8rem; font-weight: 700; outline: none; cursor: pointer;">
                    <option value="all">-- Semua Turnamen --</option>
                    <?php foreach (($tournaments ?? []) as $idx => $t): ?>
                            <?php if (empty($t['pots']))
                                continue; ?>
                            <option value="<?= esc($t['id']) ?>" <?= $idx === 0 ? 'selected' : '' ?>>
                                <?= esc($t['name']) ?> (<?= count($t['pots']) ?> Pot)
                            </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <!-- Indikator Perubahan -->
            <span id="ddmDirtyCounter" style="font-size: 0.76rem; font-weight: 800; padding: 8px 12px; background: #1e293b; border: 1px solid #334155; color: #cbd5e1;">
                Siap Simpan
            </span>

            <!-- Tombol Reset -->
            <button type="button" id="ddmResetBtn" style="display: none; background: transparent; color: #f87171; border: 1px solid #ef4444; padding: 9px 14px; font-weight: 700; font-size: 0.78rem; cursor: pointer; text-transform: uppercase;">
                Reset
            </button>

            <!-- Tombol Save Changes -->
            <button type="button" id="ddmSaveBtn" style="background: #2563eb; color: #ffffff; border: 1px solid #3b82f6; padding: 9px 24px; font-weight: 800; font-size: 0.82rem; cursor: pointer; text-transform: uppercase; letter-spacing: 0.04em; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35);">
                Save Changes
            </button>
        </div>
    </div>

    <div id="ddmCsrfContainer" style="display: none;">
        <?= csrf_field() ?>
    </div>

    <!-- ================= MAIN 2-COLUMN GRID ================= -->
    <div id="ddmMainGrid" style="display: grid; grid-template-columns: 350px minmax(0, 1fr); gap: 24px; align-items: start; width: 100%;">

        <!-- ========== KOLOM KIRI: UNASSIGNED + SANDBOX / RECYCLE BIN (STICKY) ========== -->
        <div style="position: sticky; top: 76px; width: 100%; z-index: 10; display: flex; flex-direction: column; gap: 16px;">
            
            <!-- BOX 1: UNASSIGNED TEAMS -->
            <div class="ddm-panel-box" style="background: #0f172a; border: 1px solid #334155; display: flex; flex-direction: column; max-height: 44vh;">
                <div style="background: #1e293b; padding: 10px 14px; border-bottom: 1px solid #334155; display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <span style="font-weight: 800; font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.05em; color: #f8fafc; display: block;">
                            Unassigned Teams
                        </span>
                        <span style="font-size: 0.7rem; color: #94a3b8;">Gudang Tim Aktif (Belum Masuk Pot)</span>
                    </div>
                    <span class="js-count" style="background: #0b1120; color: #38bdf8; border: 1px solid #334155; padding: 3px 10px; font-size: 0.78rem; font-weight: 800;">
                        <?= count($unassignedTeams ?? []) ?>
                    </span>
                </div>

                <div style="padding: 8px 10px; background: #0b1120; border-bottom: 1px solid #334155;">
                    <input type="text" id="ddmSearchInput" placeholder="Cari tim di Unassigned..." 
                           style="width: 100%; background: #1e293b; border: 1px solid #475569; color: #f8fafc; padding: 6px 10px; font-size: 0.8rem; outline: none; box-sizing: border-box;">
                </div>

                <div id="ddmUnassignedZone" class="js-drop" data-pot-id="0" data-tournament-id="0" data-pot-label="Unassigned"
                     style="min-height: 140px; padding: 10px; display: flex; flex-direction: column; gap: 6px; overflow-y: auto; flex: 1;">
                    <?php foreach (($unassignedTeams ?? []) as $idx => $team): ?>
                            <div class="ddm-team" 
                                 data-team-id="<?= esc($team['id']) ?>" 
                                 data-source-team-id="<?= esc($team['id']) ?>"
                                 data-team-name="<?= esc(strtolower($team['name'])) ?>"
                                 data-orig-pot="0"
                                 data-orig-order="<?= $idx + 1 ?>"
                                 style="background: #1e293b; border: 1px solid #334155; display: flex; flex-direction: row; align-items: stretch; width: 100%; min-height: 38px; color: #f8fafc; cursor: grab; user-select: none; box-sizing: border-box;">
                                <div class="ddm-handle" style="width: 30px; min-width: 30px; display: flex; align-items: center; justify-content: center; background: #0b1120; border-right: 1px solid #334155; color: #64748b; font-size: 0.85rem; font-weight: 900; letter-spacing: 2px; cursor: grab; flex-shrink: 0;">
                                    ::
                                </div>
                                <div style="padding: 6px 10px; font-weight: 600; font-size: 0.82rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; flex: 1; display: flex; align-items: center; justify-content: space-between; gap: 6px; min-width: 0;">
                                    <span class="js-team-title" style="overflow: hidden; text-overflow: ellipsis;"><?= esc($team['name']) ?></span>
                                    <div style="display: flex; align-items: center; gap: 4px; flex-shrink: 0;">
                                        <span class="js-dirty-tag" style="display: none; font-size: 0.62rem; padding: 2px 5px; background: #ca8a04; color: #fff; font-weight: 800; text-transform: uppercase;">UBAH</span>
                                        <button type="button" class="js-sandbox-btn" title="Singkirkan Sementara ke Sandbox / Recycle Bin" style="display: inline-flex; background: #1e293b; color: #fbbf24; border: 1px solid #b45309; width: 22px; height: 22px; font-size: 0.7rem; cursor: pointer; align-items: center; justify-content: center;">🗑️</button>
                                        <button type="button" class="js-detach-btn" title="Kembalikan ke Unassigned" style="display: none; background: #1e293b; color: #38bdf8; border: 1px solid #0284c7; width: 22px; height: 22px; font-size: 0.75rem; font-weight: 900; cursor: pointer; align-items: center; justify-content: center;">↩️</button>
                                    </div>
                                </div>
                            </div>
                    <?php endforeach; ?>
                </div>
            </div>

            <!-- BOX 2 (BARU): RECYCLE BIN / SANDBOX / "MAIN-MAIN BOX" -->
            <div class="ddm-panel-box" style="background: #14110b; border: 1px solid #b45309; display: flex; flex-direction: column; max-height: 42vh;">
                <div style="background: rgba(180, 83, 9, 0.28); padding: 10px 14px; border-bottom: 1px solid #b45309; display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <span style="font-weight: 800; font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.05em; color: #fde68a; display: block;">
                            🗑️ Sandbox / Recycle Bin
                        </span>
                        <span style="font-size: 0.68rem; color: #fcd34d;">Parkir Tim Cadangan (Aman di DB)</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 6px;">
                        <button type="button" id="ddmRestoreAllSandboxBtn" title="Pulihkan Semua ke Unassigned" style="background: #0b1120; color: #fde68a; border: 1px solid #b45309; padding: 3px 8px; font-size: 0.68rem; font-weight: 700; cursor: pointer;">
                            Restore All ↩️
                        </button>
                        <span class="js-count" style="background: #0b1120; color: #fbbf24; border: 1px solid #b45309; padding: 3px 10px; font-size: 0.78rem; font-weight: 800;">
                            <?= count($sandboxTeams ?? []) ?>
                        </span>
                    </div>
                </div>

                <div style="padding: 8px 10px; background: #0b1120; border-bottom: 1px solid rgba(180, 83, 9, 0.4);">
                    <input type="text" id="ddmSearchSandboxInput" placeholder="Cari tim di Sandbox..." 
                           style="width: 100%; background: #1e293b; border: 1px solid #78350f; color: #fde68a; padding: 6px 10px; font-size: 0.8rem; outline: none; box-sizing: border-box;">
                </div>

                <div id="ddmSandboxZone" class="js-drop" data-pot-id="-1" data-tournament-id="0" data-pot-label="Sandbox"
                     style="min-height: 130px; padding: 10px; display: flex; flex-direction: column; gap: 6px; overflow-y: auto; flex: 1;">
                    <?php foreach (($sandboxTeams ?? []) as $idx => $team): ?>
                            <div class="ddm-team" 
                                 data-team-id="<?= esc($team['id']) ?>" 
                                 data-source-team-id="<?= esc($team['id']) ?>"
                                 data-team-name="<?= esc(strtolower($team['name'])) ?>"
                                 data-orig-pot="-1"
                                 data-orig-order="<?= $idx + 1 ?>"
                                 style="background: #1e293b; border: 1px solid #78350f; display: flex; flex-direction: row; align-items: stretch; width: 100%; min-height: 38px; color: #fde68a; cursor: grab; user-select: none; box-sizing: border-box;">
                                <div class="ddm-handle" style="width: 30px; min-width: 30px; display: flex; align-items: center; justify-content: center; background: #0b1120; border-right: 1px solid #78350f; color: #d97706; font-size: 0.85rem; font-weight: 900; letter-spacing: 2px; cursor: grab; flex-shrink: 0;">
                                    ::
                                </div>
                                <div style="padding: 6px 10px; font-weight: 600; font-size: 0.82rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; flex: 1; display: flex; align-items: center; justify-content: space-between; gap: 6px; min-width: 0;">
                                    <span class="js-team-title" style="overflow: hidden; text-overflow: ellipsis;"><?= esc($team['name']) ?></span>
                                    <div style="display: flex; align-items: center; gap: 4px; flex-shrink: 0;">
                                        <span class="js-dirty-tag" style="display: none; font-size: 0.62rem; padding: 2px 5px; background: #ca8a04; color: #fff; font-weight: 800; text-transform: uppercase;">UBAH</span>
                                        <button type="button" class="js-sandbox-btn" title="Singkirkan ke Sandbox" style="display: none; background: #1e293b; color: #fbbf24; border: 1px solid #b45309; width: 22px; height: 22px; font-size: 0.7rem; cursor: pointer; align-items: center; justify-content: center;">🗑️</button>
                                        <button type="button" class="js-detach-btn" title="Pulihkan ke Unassigned" style="display: inline-flex; background: #1e293b; color: #38bdf8; border: 1px solid #0284c7; width: 22px; height: 22px; font-size: 0.75rem; font-weight: 900; cursor: pointer; align-items: center; justify-content: center;">↩️</button>
                                    </div>
                                </div>
                            </div>
                    <?php endforeach; ?>
                </div>
            </div>

        </div>

        <!-- ========== KOLOM KANAN: DAFTAR TURNAMEN & POT ========== -->
        <div id="ddmRightColumn" style="display: flex; flex-direction: column; gap: 28px; min-width: 0; width: 100%;">
            <?php
            $hasPots = false;
            foreach (($tournaments ?? []) as $tournament):
                if (empty($tournament['pots']))
                    continue;
                $hasPots = true;
                $isLocked = (($tournament['status'] ?? '') === 'selesai');
                ?>
                    <div class="ddm-tournament-section" 
                         data-tournament-id="<?= esc($tournament['id']) ?>"
                         style="background: #0b1120; border: 1px solid #334155; padding: 20px; display: flex; flex-direction: column; gap: 18px; width: 100%; box-sizing: border-box;">
                
                        <!-- Header Turnamen -->
                        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; padding-bottom: 12px; border-bottom: 1px solid #334155;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span style="background: #2563eb; color: #fff; font-size: 0.7rem; font-weight: 800; padding: 3px 8px; text-transform: uppercase;">
                                    TOURNAMENT
                                </span>
                                <h2 style="margin: 0; font-size: 1.05rem; font-weight: 800; color: #38bdf8; text-transform: uppercase; letter-spacing: 0.04em;">
                                    <?= esc($tournament['name']) ?>
                                </h2>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span style="font-size: 0.78rem; color: #94a3b8; font-weight: 600;">
                                    Total Pot: <strong style="color: #f8fafc;"><?= count($tournament['pots']) ?></strong>
                                </span>
                                <?php if ($isLocked): ?>
                                        <span style="background: rgba(220, 38, 38, 0.2); border: 1px solid #ef4444; color: #fca5a5; font-size: 0.7rem; font-weight: 800; padding: 3px 8px; text-transform: uppercase;">
                                            Selesai (Terkunci)
                                        </span>
                                <?php endif; ?>
                            </div>
                        </div>

                        <!-- Grid Pot di dalam Turnamen -->
                        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px; width: 100%;">
                            <?php foreach ($tournament['pots'] as $pot): ?>
                                    <?php
                                    $potTeams = $pot['teams'] ?? [];
                                    $maxTeams = (int) ($pot['max_teams'] ?? 12);
                                    $stageLabel = $pot['stage_label'] ?? ucfirst((string) ($pot['stage'] ?? 'Kualifikasi'));
                                    $stageColor = '#38bdf8';
                                    if (strtolower((string) ($pot['stage'] ?? '')) === 'semifinal')
                                        $stageColor = '#facc15';
                                    if (strtolower((string) ($pot['stage'] ?? '')) === 'grandfinal')
                                        $stageColor = '#4ade80';
                                    ?>
                                    <div class="ddm-pot-card" style="background: #0f172a; border: 1px solid #334155; display: flex; flex-direction: column; width: 100%; box-sizing: border-box;">
                        
                                        <div style="background: #1e293b; padding: 10px 14px; border-bottom: 1px solid #334155; display: flex; justify-content: space-between; align-items: center; gap: 8px;">
                                            <div style="display: flex; align-items: center; gap: 8px; min-width: 0;">
                                                <span style="font-size: 0.65rem; font-weight: 800; padding: 2px 6px; background: #0b1120; border: 1px solid <?= $stageColor ?>; color: <?= $stageColor ?>; text-transform: uppercase; flex-shrink: 0;">
                                                    <?= esc($stageLabel) ?>
                                                </span>
                                                <span style="font-weight: 800; font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.04em; color: #f1f5f9; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                    <?= esc($pot['name']) ?>
                                                </span>
                                            </div>
                                            <div style="display: flex; align-items: center; gap: 4px; background: #0b1120; border: 1px solid #334155; padding: 2px 8px; flex-shrink: 0;">
                                                <span class="js-count" style="color: #38bdf8; font-size: 0.75rem; font-weight: 800;"><?= count($potTeams) ?></span>
                                                <span style="color: #64748b; font-size: 0.7rem;">/ <?= $maxTeams ?></span>
                                            </div>
                                        </div>

                                        <div class="js-drop"
                                             data-pot-id="<?= esc($pot['id']) ?>"
                                             data-tournament-id="<?= esc($tournament['id']) ?>"
                                             data-pot-label="<?= esc($pot['name']) ?>"
                                             style="min-height: 220px; padding: 10px; display: flex; flex-direction: column; gap: 8px; flex: 1;">
                                            <?php foreach ($potTeams as $idx => $team): ?>
                                                    <div class="ddm-team" 
                                                         data-team-id="<?= esc($team['id']) ?>" 
                                                         data-source-team-id="<?= esc($team['id']) ?>"
                                                         data-team-name="<?= esc(strtolower($team['name'])) ?>"
                                                         data-orig-pot="<?= esc($pot['id']) ?>"
                                                         data-orig-order="<?= $idx + 1 ?>"
                                                         style="background: #1e293b; border: 1px solid #334155; display: flex; flex-direction: row; align-items: stretch; width: 100%; min-height: 38px; color: #f8fafc; cursor: grab; user-select: none; box-sizing: border-box;">
                                                        <div class="ddm-handle" style="width: 30px; min-width: 30px; display: flex; align-items: center; justify-content: center; background: #0b1120; border-right: 1px solid #334155; color: #64748b; font-size: 0.85rem; font-weight: 900; letter-spacing: 2px; cursor: grab; flex-shrink: 0;">
                                                            ::
                                                        </div>
                                                        <div style="padding: 6px 10px; font-weight: 600; font-size: 0.82rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; flex: 1; display: flex; align-items: center; justify-content: space-between; gap: 6px; min-width: 0;">
                                                            <span class="js-team-title" style="overflow: hidden; text-overflow: ellipsis;"><?= esc($team['name']) ?></span>
                                                            <div style="display: flex; align-items: center; gap: 4px; flex-shrink: 0;">
                                                                <span class="js-dirty-tag" style="display: none; font-size: 0.62rem; padding: 2px 5px; background: #ca8a04; color: #fff; font-weight: 800; text-transform: uppercase;">UBAH</span>
                                                                <button type="button" class="js-sandbox-btn" title="Singkirkan ke Sandbox / Recycle Bin" style="display: inline-flex; background: #1e293b; color: #fbbf24; border: 1px solid #b45309; width: 22px; height: 22px; font-size: 0.7rem; cursor: pointer; align-items: center; justify-content: center;">🗑️</button>
                                                                <button type="button" class="js-detach-btn" title="Kembalikan ke Unassigned" style="display: inline-flex; background: #1e293b; color: #94a3b8; border: 1px solid #475569; width: 22px; height: 22px; font-size: 0.8rem; font-weight: 900; line-height: 1; cursor: pointer; align-items: center; justify-content: center;">&times;</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                            <?php endforeach; ?>
                                        </div>
                                    </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
            <?php endforeach; ?>

            <?php if (!$hasPots): ?>
                    <div style="color: #64748b; text-align: center; padding: 48px 20px; font-size: 0.95rem; border: 1px dashed #334155; background: #0b1120;">
                        Belum ada Pot yang dibuat. Silakan buat Pot terlebih dahulu di halaman Turnamen.
                    </div>
            <?php endif; ?>
        </div>

    </div>
</div>

<!-- Load SortableJS -->
<script <?= function_exists('csp_script_nonce') ? csp_script_nonce() : '' ?> src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.6/Sortable.min.js"></script>

<script <?= function_exists('csp_script_nonce') ? csp_script_nonce() : '' ?>>
(function() {
    'use strict';

    var dynamicStyle = document.createElement('style');
    dynamicStyle.textContent = [
        '#ddmApp .ddm-team:hover { border-color: #3b82f6 !important; background: #253347 !important; }',
        '#ddmApp .ddm-team.is-dirty { border-color: #eab308 !important; background: rgba(234, 179, 8, 0.14) !important; }',
        '#ddmApp .ddm-team.is-cloned { border-color: #22c55e !important; background: rgba(34, 197, 94, 0.14) !important; }',
        '#ddmApp .js-detach-btn:hover { background: #dc2626 !important; color: #fff !important; border-color: #ef4444 !important; }',
        '#ddmApp .js-sandbox-btn:hover { background: #b45309 !important; color: #fff !important; }',
        '.sortable-ghost { opacity: 0.3 !important; background: #1d4ed8 !important; border: 1px dashed #60a5fa !important; }',
        '.sortable-drag { background: #0f172a !important; border: 2px solid #38bdf8 !important; box-shadow: 0 14px 28px rgba(0,0,0,0.65) !important; opacity: 0.96 !important; z-index: 99999 !important; }',
        '@media (max-width: 991.98px) { #ddmMainGrid { grid-template-columns: 1fr !important; } }'
    ].join('\n');
    document.head.appendChild(dynamicStyle);

    var badgeEl        = document.getElementById('ddmEngineBadge');
    var dirtyCounter   = document.getElementById('ddmDirtyCounter');
    var saveBtn        = document.getElementById('ddmSaveBtn');
    var resetBtn       = document.getElementById('ddmResetBtn');
    var filterSelect   = document.getElementById('ddmTourneyFilter');
    var dragModeSelect = document.getElementById('ddmDragMode');
    var unassignedZone = document.getElementById('ddmUnassignedZone');
    var sandboxZone    = document.getElementById('ddmSandboxZone');
    var sortableInstances = [];

    function applyTournamentFilter() {
        if (!filterSelect) return;
        var val = filterSelect.value;
        document.querySelectorAll('#ddmApp .ddm-tournament-section').forEach(function(sec) {
            var tId = sec.getAttribute('data-tournament-id');
            sec.style.display = (val === 'all' || val === tId) ? 'flex' : 'none';
        });
    }

    if (filterSelect) {
        filterSelect.addEventListener('change', applyTournamentFilter);
        applyTournamentFilter();
    }

    function evaluateWorkspaceState() {
        var changedCount = 0;

        document.querySelectorAll('#ddmApp .js-drop').forEach(function(zone) {
            var currentPotId = zone.getAttribute('data-pot-id') || '0';
            var cards = zone.querySelectorAll('.ddm-team');

            var parentCard = zone.closest('.ddm-panel-box') || zone.closest('.ddm-pot-card');
            if (parentCard) {
                var countEl = parentCard.querySelector('.js-count');
                if (countEl) countEl.textContent = cards.length;
            }

            cards.forEach(function(card, index) {
                var origPot   = card.getAttribute('data-orig-pot') || '0';
                var origOrder = parseInt(card.getAttribute('data-orig-order') || '0', 10);
                var isClone   = card.getAttribute('data-is-clone') === '1';
                var newOrder  = index + 1;

                var detachBtn  = card.querySelector('.js-detach-btn');
                var sandboxBtn = card.querySelector('.js-sandbox-btn');

                if (currentPotId === '-1') {
                    // Di dalam Sandbox: tampilkan tombol Restore (↩️), sembunyikan tombol Sandbox (🗑️)
                    if (detachBtn) {
                        detachBtn.style.display = 'inline-flex';
                        detachBtn.textContent = '↩️';
                        detachBtn.title = 'Pulihkan ke Unassigned';
                    }
                    if (sandboxBtn) sandboxBtn.style.display = 'none';
                } else if (currentPotId === '0') {
                    // Di dalam Unassigned: tampilkan tombol Sandbox (🗑️), sembunyikan tombol Detach
                    if (detachBtn) detachBtn.style.display = 'none';
                    if (sandboxBtn) sandboxBtn.style.display = 'inline-flex';
                } else {
                    // Di dalam Pot Aktif: tampilkan keduanya
                    if (detachBtn) {
                        detachBtn.style.display = 'inline-flex';
                        detachBtn.innerHTML = '&times;';
                        detachBtn.title = 'Keluarkan ke Unassigned';
                    }
                    if (sandboxBtn) sandboxBtn.style.display = 'inline-flex';
                }

                var isMovedPot   = (currentPotId !== origPot);
                var isMovedOrder = (currentPotId !== '0' && currentPotId !== '-1' && origOrder !== newOrder);
                var isDirty      = isClone || isMovedPot || isMovedOrder;

                var tag = card.querySelector('.js-dirty-tag');
                if (isClone) {
                    changedCount++;
                    card.classList.remove('is-dirty');
                    card.classList.add('is-cloned');
                    if (tag) {
                        tag.style.display = 'inline-block';
                        tag.style.background = '#16a34a';
                        tag.textContent = 'LOLOS / BARU';
                    }
                } else if (isDirty) {
                    changedCount++;
                    card.classList.remove('is-cloned');
                    card.classList.add('is-dirty');
                    if (tag) {
                        tag.style.display = 'inline-block';
                        tag.style.background = currentPotId === '-1' ? '#b45309' : '#ca8a04';
                        tag.textContent = currentPotId === '-1' ? 'SANDBOX' : (isMovedPot ? 'PINDAH' : 'URUTAN');
                    }
                } else {
                    card.classList.remove('is-dirty', 'is-cloned');
                    if (tag) tag.style.display = 'none';
                }
            });
        });

        if (dirtyCounter) {
            dirtyCounter.textContent = changedCount > 0 ? (changedCount + ' Perubahan Belum Disimpan') : 'Siap Simpan';
            dirtyCounter.style.borderColor = changedCount > 0 ? '#eab308' : '#334155';
            dirtyCounter.style.color       = changedCount > 0 ? '#fde047' : '#cbd5e1';
        }

        if (saveBtn) {
            saveBtn.textContent = changedCount > 0 ? 'Save Changes (' + changedCount + ')' : 'Save Changes';
            saveBtn.style.background = changedCount > 0 ? '#16a34a' : '#2563eb';
            saveBtn.style.borderColor = changedCount > 0 ? '#22c55e' : '#3b82f6';
        }

        if (resetBtn) {
            resetBtn.style.display = changedCount > 0 ? 'inline-block' : 'none';
        }

        return changedCount;
    }

    // Klik Tombol 'x'/'↩️' (Kembalikan ke Unassigned) atau '🗑️' (Parkir ke Sandbox)
    document.getElementById('ddmApp').addEventListener('click', function(e) {
        var sandboxBtn = e.target.closest('.js-sandbox-btn');
        if (sandboxBtn && sandboxZone) {
            e.preventDefault();
            e.stopPropagation();
            var cardToPark = sandboxBtn.closest('.ddm-team');
            if (cardToPark) {
                if (cardToPark.getAttribute('data-is-clone') === '1') {
                    cardToPark.remove();
                } else {
                    sandboxZone.insertBefore(cardToPark, sandboxZone.firstChild);
                }
                evaluateWorkspaceState();
            }
            return;
        }

        var detachBtn = e.target.closest('.js-detach-btn');
        if (detachBtn && unassignedZone) {
            e.preventDefault();
            e.stopPropagation();
            var card = detachBtn.closest('.ddm-team');
            if (!card) return;
            if (card.getAttribute('data-is-clone') === '1') {
                card.remove();
            } else {
                unassignedZone.insertBefore(card, unassignedZone.firstChild);
            }
            evaluateWorkspaceState();
        }
    });

    // Tombol Restore All dari Sandbox ke Unassigned
    var restoreAllBtn = document.getElementById('ddmRestoreAllSandboxBtn');
    if (restoreAllBtn && sandboxZone && unassignedZone) {
        restoreAllBtn.addEventListener('click', function() {
            sandboxZone.querySelectorAll('.ddm-team').forEach(function(card) {
                unassignedZone.appendChild(card);
            });
            evaluateWorkspaceState();
        });
    }

    function showToast(msg, ok) {
        var old = document.querySelector('.ddm-toast-popup');
        if (old) old.remove();
        var el = document.createElement('div');
        el.className = 'ddm-toast-popup';
        el.style.cssText = 'position:fixed; bottom:24px; right:24px; padding:14px 24px; font-weight:800; font-size:0.85rem; color:#fff; z-index:100000; border:1px solid; box-shadow:0 10px 25px rgba(0,0,0,0.5); ' +
            (ok ? 'background:#14532d; border-color:#22c55e;' : 'background:#7f1d1d; border-color:#ef4444;');
        el.textContent = msg;
        document.body.appendChild(el);
        setTimeout(function() { el.remove(); }, 3500);
    }

    function initSortable() {
        if (typeof Sortable === 'undefined') return;

        sortableInstances.forEach(function(inst) { inst.destroy(); });
        sortableInstances = [];

        var isPromoteMode = dragModeSelect && dragModeSelect.value === 'promote';

        document.querySelectorAll('#ddmApp .js-drop').forEach(function(zone) {
            var potAttr = zone.getAttribute('data-pot-id') || '0';
            var isNonPot = (potAttr === '0' || potAttr === '-1');

            var inst = Sortable.create(zone, {
                group: {
                    name: 'shared-teams',
                    pull: (isPromoteMode && !isNonPot) ? 'clone' : true,
                    put: true
                },
                animation: 150,
                draggable: '.ddm-team',
                forceFallback: true,
                fallbackOnBody: true,
                fallbackTolerance: 3,
                scroll: true,
                scrollSensitivity: 60,
                scrollSpeed: 14,
                ghostClass: 'sortable-ghost',
                dragClass: 'sortable-drag',
                onAdd: function(evt) {
                    var item      = evt.item;
                    var fromPotId = evt.from.getAttribute('data-pot-id') || '0';
                    var toPotId   = evt.to.getAttribute('data-pot-id') || '0';

                    if (isPromoteMode && fromPotId !== '0' && fromPotId !== '-1' && toPotId !== '0' && toPotId !== '-1') {
                        if (fromPotId === toPotId) {
                            item.remove();
                            return;
                        }
                        item.setAttribute('data-is-clone', '1');
                        item.setAttribute('data-team-id', '0');
                    }
                    evaluateWorkspaceState();
                },
                onUpdate: function() { evaluateWorkspaceState(); },
                onRemove: function() { evaluateWorkspaceState(); },
                onSort:   function() { evaluateWorkspaceState(); },
                onEnd:    function() { evaluateWorkspaceState(); }
            });

            sortableInstances.push(inst);
        });

        if (badgeEl) {
            badgeEl.textContent       = isPromoteMode ? 'MODE PROMOSI (MULTI-POT)' : 'DRAG & DROP READY';
            badgeEl.style.borderColor = isPromoteMode ? '#eab308' : '#16a34a';
            badgeEl.style.color       = isPromoteMode ? '#fde047' : '#4ade80';
        }
    }

    if (dragModeSelect) {
        dragModeSelect.addEventListener('change', function() {
            initSortable();
            showToast(
                this.value === 'promote'
                    ? 'Mode Promosi Aktif: Menarik tim antar Pot akan menyalin tim ke babak baru.'
                    : 'Mode Pindah Biasa Aktif: Menarik tim akan memindahkan posisi tim.',
                true
            );
        });
    }

    function bindSearchFilter(inputId, zoneEl) {
        var inp = document.getElementById(inputId);
        if (!inp || !zoneEl) return;
        inp.addEventListener('input', function() {
            var q = this.value.toLowerCase().trim();
            zoneEl.querySelectorAll('.ddm-team').forEach(function(card) {
                var name = card.getAttribute('data-team-name') || '';
                card.style.display = (q === '' || name.indexOf(q) !== -1) ? 'flex' : 'none';
            });
        });
    }
    bindSearchFilter('ddmSearchInput', unassignedZone);
    bindSearchFilter('ddmSearchSandboxInput', sandboxZone);

    if (resetBtn) {
        resetBtn.addEventListener('click', function() {
            if (confirm('Batalkan perubahan yang belum disimpan dan muat ulang halaman?')) {
                window.location.reload();
            }
        });
    }

    if (saveBtn) {
        saveBtn.addEventListener('click', function() {
            var payload = [];

            document.querySelectorAll('#ddmApp .js-drop').forEach(function(zone) {
                var rawPotId     = zone.getAttribute('data-pot-id') || '0';
                var rawTourneyId = zone.getAttribute('data-tournament-id') || '0';
                var isSandbox    = (rawPotId === '-1');
                var potId        = (rawPotId !== '0' && rawPotId !== '-1') ? parseInt(rawPotId, 10) : (isSandbox ? -1 : null);
                var tournamentId = (potId !== null && potId > 0 && rawTourneyId !== '0') ? parseInt(rawTourneyId, 10) : null;

                zone.querySelectorAll('.ddm-team').forEach(function(card, idx) {
                    var origPot      = card.getAttribute('data-orig-pot') || '0';
                    var origOrder    = parseInt(card.getAttribute('data-orig-order') || '0', 10);
                    var isClone      = card.getAttribute('data-is-clone') === '1';
                    var teamId       = parseInt(card.getAttribute('data-team-id') || '0', 10);
                    var sourceTeamId = parseInt(card.getAttribute('data-source-team-id') || String(teamId), 10);
                    var newOrder     = idx + 1;

                    if (isClone || rawPotId !== origPot || (rawPotId !== '0' && rawPotId !== '-1' && origOrder !== newOrder)) {
                        payload.push({
                            is_clone:       isClone ? 1 : 0,
                            is_sandbox:     isSandbox ? 1 : 0,
                            team_id:        teamId,
                            source_team_id: sourceTeamId,
                            pot_id:         potId,
                            tournament_id:  tournamentId,
                            sort_order:     newOrder
                        });
                    }
                });
            });

            if (payload.length === 0) {
                showToast('Tidak ada perubahan posisi tim yang perlu disimpan.', true);
                return;
            }

            saveBtn.disabled = true;
            saveBtn.textContent = 'Menyimpan...';

            var csrfInput = document.querySelector('#ddmCsrfContainer input[type="hidden"]');
            var bodyEl    = document.body;
            var csrfName  = csrfInput ? csrfInput.getAttribute('name') : (bodyEl.getAttribute('data-bg-csrf-token-name') || '<?= esc(csrf_token()) ?>');
            var csrfHash  = csrfInput ? csrfInput.value : (bodyEl.getAttribute('data-bg-csrf-hash') || '<?= esc(csrf_hash()) ?>');

            var headers = {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'X-CSRF-TOKEN': csrfHash
            };
            headers[csrfName] = csrfHash;

            var bodyData = { teams: payload };
            bodyData[csrfName] = csrfHash;

            fetch('<?= site_url("teams/drag-manager/save") ?>', {
                method: 'POST',
                headers: headers,
                body: JSON.stringify(bodyData)
            })
            .then(function(r) { return r.json(); })
            .then(function(res) {
                if (res.csrfHash) {
                    if (csrfInput) csrfInput.value = res.csrfHash;
                    bodyEl.setAttribute('data-bg-csrf-hash', res.csrfHash);
                }

                if (res.status === 'success') {
                    showToast(res.message || 'Perubahan berhasil disimpan!', true);
                    var hasClones = payload.some(function(item) { return item.is_clone === 1; });
                    if (hasClones) {
                        setTimeout(function() { window.location.reload(); }, 800);
                        return;
                    }

                    document.querySelectorAll('#ddmApp .js-drop').forEach(function(zone) {
                        var currentPotId = zone.getAttribute('data-pot-id') || '0';
                        zone.querySelectorAll('.ddm-team').forEach(function(card, idx) {
                            card.setAttribute('data-orig-pot', currentPotId);
                            card.setAttribute('data-orig-order', String(idx + 1));
                            card.removeAttribute('data-is-clone');
                        });
                    });
                    evaluateWorkspaceState();
                } else {
                    showToast('Gagal: ' + (res.message || 'Terjadi kesalahan'), false);
                }
            })
            .catch(function() {
                showToast('Gagal menghubungi server.', false);
            })
            .finally(function() {
                saveBtn.disabled = false;
                evaluateWorkspaceState();
            });
        });
    }

    initSortable();
    evaluateWorkspaceState();
})();
</script>
<?= $this->endSection() ?>