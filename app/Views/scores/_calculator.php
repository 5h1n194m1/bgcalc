<?php
$showCardWrapper   = $showCardWrapper ?? true;
$cardBodyClass     = $cardBodyClass ?? 'card-body';
$tableId           = 'scoreCalculatorTable-' . (int) $pot['id'];
$formId            = 'scoreCalculatorForm-' . (int) $pot['id'];
$metaFormId        = 'potMetaForm-' . (int) $pot['id'];
$gameCountId       = 'gameCountInput-' . (int) $pot['id'];
$subHeaderId       = 'gameCountHeaderRow-' . (int) $pot['id'];
$addButtonId       = 'addGameBtn-' . (int) $pot['id'];
$removeButtonId    = 'removeGameBtn-' . (int) $pot['id'];
$screenshotId      = 'potScreenshotsCollapse-' . (int) $pot['id'];
$memberTextByTeam  = $memberTextByTeam ?? [];
$membersByTeam     = $membersByTeam ?? [];
$tournamentId      = (int) ($tournamentId ?? $pot['tournament_id'] ?? 0);
$canManage         = $canManage ?? true;
$disabledAttr      = $canManage ? '' : 'disabled';
$readonlyAttr      = $canManage ? '' : 'readonly';
$gameCount         = max(1, count($gameNos ?? []));
$allowSideScroll   = $gameCount > 8;
$teamColWidth      = $allowSideScroll ? 150 : max(150, 260 - (($gameCount - 1) * 18));
$scoreColWidth     = $allowSideScroll ? 44 : max(44, 52 - (($gameCount - 1) * 2));
$placementColWidth = $allowSideScroll ? 40 : max(40, 46 - (($gameCount - 1) * 2));
?>

<?php if ($showCardWrapper): ?>
<section class="card pot-module-card excel-pot-card <?= ! empty($isCurrent) ? 'pot-module-current' : '' ?>" id="pot-card-<?= esc((string) $pot['id']) ?>" data-pot-card data-pot-id="<?= esc((string) $pot['id']) ?>">
    <div class="<?= esc($cardBodyClass) ?> pot-module-body" style="padding: 0 !important; gap: 0 !important;">
<?php endif; ?>

<div class="pot-module-shell" style="gap: 0 !important;">
    <!-- Form Metadata Pot -->
    <form
        action="<?= site_url('pots/update/' . $pot['id']) ?>"
        method="post"
        id="<?= esc($metaFormId) ?>"
        class="js-pot-meta-form"
        data-can-manage="<?= $canManage ? '1' : '0' ?>"
        data-pot-id="<?= esc((string) $pot['id']) ?>"
        data-pot-update-url="<?= site_url('pots/update/' . $pot['id']) ?>"
    >
        <?= csrf_field() ?>
        <input type="hidden" name="tournament_id" value="<?= esc((string) $tournamentId) ?>">
        <input type="hidden" name="redirect_to" value="<?= current_url() ?>">
    </form>

    <!-- ================= EXCEL POT RIBBON BAR ================= -->
    <div class="excel-pot-ribbon">
        <!-- Identitas Pot (Urutan & Nama Pot) -->
        <div class="excel-pot-identity">
            <div class="excel-pot-order-badge" title="Urutan Pot">
                <span>#</span>
                <input
                    type="number"
                    min="1"
                    name="pot_sort_order"
                    form="<?= esc($metaFormId) ?>"
                    class="form-control form-control-sm pot-order-inline js-pot-input"
                    value="<?= esc((string) ($pot['sort_order'] ?? 1)) ?>"
                    <?= $disabledAttr ?>
                >
            </div>

            <input
                type="text"
                name="pot_name"
                form="<?= esc($metaFormId) ?>"
                class="form-control excel-pot-title-input js-pot-input"
                value="<?= esc($pot['name']) ?>"
                title="Klik untuk mengganti Nama Pot"
                <?= $readonlyAttr ?>
            >

            <span class="pot-module-context-text js-pot-context-text d-none" data-tournament-name="<?= esc(($tournamentName ?? '') !== '' ? (string) $tournamentName : 'Tournament') ?>">
                <?= esc(($tournamentName ?? '') !== '' ? (string) $tournamentName : 'Tournament') ?> / <?= esc($pot['name'] ?? 'Pot') ?>
            </span>
        </div>

        <!-- Toolbar Aksi Terkelompok ala Spreadsheet -->
        <div class="excel-pot-toolbar controller-only">
            <!-- Pencarian Cepat Tim / Player di Pot Ini -->
            <div class="score-toolbar-search custom-dropdown-wrapper" style="width: 210px; min-width: 180px;">
                <input type="text" class="form-control form-control-sm js-universal-lookup" placeholder="Cari tim / player di pot ini..." autocomplete="off">
                <div class="custom-dropdown-menu js-custom-dropdown js-universal-lookup-dropdown"></div>
            </div>

            <div class="excel-btn-divider"></div>

            <!-- Grup Baris & Klasemen -->
            <button type="button" class="btn btn-outline-secondary btn-sm toolbar-btn js-add-team-row" title="Tambah Baris Tim Baru" <?= $disabledAttr ?>>+ Tim</button>
            <button type="button" class="btn btn-outline-info btn-sm toolbar-btn js-sort-standings" title="Urutkan Klasemen Berdasarkan Total Poin">Urutkan Skor</button>
            <button
                type="button"
                class="btn btn-outline-success btn-sm toolbar-btn js-advance-selected"
                data-advance-url="<?= site_url('pots/advance/' . $pot['id']) ?>"
                title="Promosikan Tim yang Dicentang (Lolos) ke Pot Baru"
                <?= $disabledAttr ?>
            >
                Naik Pot &rarr;
            </button>

            <div class="excel-btn-divider"></div>

            <!-- Grup Kolom Game -->
            <button type="button" class="btn btn-outline-primary btn-sm toolbar-btn js-add-game" id="<?= esc($addButtonId) ?>" title="Tambah Kolom Game" <?= $disabledAttr ?>>+ Game</button>
            <button type="button" class="btn btn-outline-danger btn-sm toolbar-btn js-remove-game" id="<?= esc($removeButtonId) ?>" title="Hapus Kolom Game Terakhir" <?= $disabledAttr ?>>- Game</button>

            <div class="excel-btn-divider"></div>

            <!-- Grup Data & Screenshot -->
            <button type="button" class="btn btn-outline-secondary btn-sm toolbar-btn" data-bs-toggle="collapse" data-bs-target="#<?= esc($screenshotId) ?>" aria-expanded="false" aria-controls="<?= esc($screenshotId) ?>">
                Screenshot<?= (!empty($pot['reference_image_1']) || !empty($pot['reference_image_2'])) ? ' (Ada)' : '' ?>
            </button>
            <button type="button" class="btn btn-outline-warning btn-sm toolbar-btn js-clear-score-data" title="Kosongkan Hanya Nilai Skor (Tim Tetap Ada)" <?= $disabledAttr ?>>Reset Skor</button>
            <button type="submit" form="<?= esc($formId) ?>" class="btn btn-primary btn-sm toolbar-btn js-save-score-now" <?= $disabledAttr ?>>Simpan</button>

            <form action="<?= site_url('pots/delete/' . $pot['id']) ?>" method="post" class="m-0 d-inline js-confirm-delete-form" data-confirm-title="Hapus Pot" data-confirm-message="Yakin ingin menghapus pot ini beserta team dan score di dalamnya?" data-confirm-submit="Hapus Pot">
                <?= csrf_field() ?>
                <button type="submit" class="btn btn-outline-danger btn-sm toolbar-btn" title="Hapus Pot Ini" <?= $disabledAttr ?>>Hapus Pot</button>
            </form>
        </div>
    </div>

    <!-- Panel Collapsible Screenshot Referensi -->
    <div class="collapse pot-screenshot-collapse controller-only" id="<?= esc($screenshotId) ?>">
        <div class="pot-inline-panel" style="border-left: none; border-right: none;">
            <form action="<?= site_url('pots/update-images/' . $pot['id']) ?>" method="post" enctype="multipart/form-data" class="row g-2 align-items-end">
                <?= csrf_field() ?>
                <div class="col-md-5">
                    <label class="form-label small text-muted mb-1">Screenshot Hasil Pertandingan 1</label>
                    <input type="file" name="reference_image_1" class="form-control form-control-sm rounded-0" accept="image/*" <?= $disabledAttr ?>>
                </div>
                <div class="col-md-5">
                    <label class="form-label small text-muted mb-1">Screenshot Hasil Pertandingan 2</label>
                    <input type="file" name="reference_image_2" class="form-control form-control-sm rounded-0" accept="image/*" <?= $disabledAttr ?>>
                </div>
                <div class="col-md-2 d-grid">
                    <button type="submit" class="btn btn-sm btn-primary toolbar-btn rounded-0" <?= $disabledAttr ?>>Upload Gambar</button>
                </div>
            </form>

            <?php if (! empty($pot['reference_image_1']) || ! empty($pot['reference_image_2'])): ?>
                <div class="score-reference-grid mt-2">
                    <?php if (! empty($pot['reference_image_1'])): ?>
                        <img src="<?= site_url($pot['reference_image_1']) ?>" alt="Reference 1" class="score-reference-image border rounded-0">
                    <?php endif; ?>
                    <?php if (! empty($pot['reference_image_2'])): ?>
                        <img src="<?= site_url($pot['reference_image_2']) ?>" alt="Reference 2" class="score-reference-image border rounded-0">
                    <?php endif; ?>
                </div>
            <?php endif; ?>
        </div>
    </div>

    <!-- ================= SPREADSHEET BULK SCORE FORM ================= -->
    <form
        action="<?= site_url('scores/save-bulk') ?>"
        method="post"
        id="<?= esc($formId) ?>"
        class="pot-calculator-form js-score-bulk-form"
        data-can-manage="<?= $canManage ? '1' : '0' ?>"
        data-pot-id="<?= esc((string) $pot['id']) ?>"
        data-pot-update-url="<?= site_url('pots/update/' . $pot['id']) ?>"
        data-pot-advance-url="<?= site_url('pots/advance/' . $pot['id']) ?>"
        data-placement-map='<?= json_encode($placementMap, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) ?>'
        data-point-system="<?= esc($pointSystem ?? 'ffws') ?>"
        data-kill-multiplier="<?= esc($killPoints ?? 1) ?>"
        data-custom-points="<?= esc($customPoints ?? '') ?>"
    >
        <?= csrf_field() ?>
        <input type="hidden" name="pot_id" value="<?= esc((string) $pot['id']) ?>">
        <input type="hidden" name="tournament_id" value="<?= esc((string) $tournamentId) ?>">
        <input type="hidden" name="redirect_to" value="<?= current_url() ?>">
        <input type="hidden" name="game_count" id="<?= esc($gameCountId) ?>" class="js-game-count" value="<?= esc((string) count($gameNos)) ?>">

        <div class="score-table-shell excel-table-container<?= $allowSideScroll ? ' is-scrollable' : '' ?>" style="border: none !important; --team-col-width: <?= esc((string) $teamColWidth) ?>px; --score-col-width: <?= esc((string) $scoreColWidth) ?>px; --placement-col-width: <?= esc((string) $placementColWidth) ?>px;">
            <table class="table table-bordered table-sm score-table score-calculator-table excel-spreadsheet m-0" id="<?= esc($tableId) ?>">
                <thead>
                    <tr>
                        <th rowspan="2" class="text-center align-middle score-no-col">#</th>
                        <th rowspan="2" class="align-middle score-team-col" style="text-align: left !important; padding-left: 8px !important;">Nama Tim</th>
                        <?php foreach ($gameNos as $gameNo): ?>
                            <th colspan="3" class="text-center game-group-head" data-game-group="<?= esc((string) $gameNo) ?>">GAME <?= esc((string) $gameNo) ?></th>
                        <?php endforeach; ?>
                        <th rowspan="2" class="text-center align-middle qualify-col controller-only" title="Centang untuk promosi ke babak berikutnya">Lolos</th>
                        <th rowspan="2" class="text-center align-middle total-col js-total-head">TOTAL</th>
                        <th rowspan="2" class="text-center align-middle action-col controller-only">Aksi</th>
                    </tr>
                    <tr id="<?= esc($subHeaderId) ?>">
                        <?php foreach ($gameNos as $gameNo): ?>
                            <th class="text-center game-subhead" data-game-col="<?= esc((string) $gameNo) ?>" data-col-role="rank">Rank</th>
                            <th class="text-center game-subhead" data-game-col="<?= esc((string) $gameNo) ?>" data-col-role="placement">P.Rank</th>
                            <th class="text-center game-subhead" data-game-col="<?= esc((string) $gameNo) ?>" data-col-role="kill">Kill</th>
                        <?php endforeach; ?>
                    </tr>
                </thead>

                <tbody>
                    <?php foreach ($teams as $index => $team): ?>
                        <?php
                        $teamScores  = $scoresByTeam[$team['id']] ?? [];
                        $teamMembers = array_values(array_filter(array_map(
                            static fn (array $member): string => trim((string) ($member['player_name'] ?? '')),
                            $membersByTeam[$team['id']] ?? []
                        ), static fn (string $name): bool => $name !== ''));
                        $searchLabel = trim(implode(', ', array_filter([
                            trim((string) $team['name']),
                            implode(', ', $teamMembers),
                        ], static fn (string $value): bool => $value !== '')));
                        $searchPlayerText = implode("\n", $teamMembers);
                        $memberTooltip = $teamMembers !== [] ? 'Roster: ' . implode(', ', $teamMembers) : 'Belum ada data roster';
                        ?>
                        <tr
                            data-team-row
                            data-team-id="<?= esc((string) $team['id']) ?>"
                            data-pot-id="<?= esc((string) $pot['id']) ?>"
                            data-search-label="<?= esc($searchLabel !== '' ? $searchLabel : (string) $team['name']) ?>"
                            data-search-players="<?= esc($searchPlayerText) ?>"
                        >
                            <td class="score-no-col js-row-number"><?= esc((string) ($index + 1)) ?></td>

                            <td class="score-team-col team-cell" title="<?= esc($memberTooltip) ?>">
                                <div class="team-cell-inner">
                                    <div class="team-main-line">
                                        <div class="team-manager-combobox-shell team-table-combobox-shell custom-dropdown-wrapper">
                                            <input
                                                type="text"
                                                class="form-control form-control-sm fw-semibold team-name-input compact-input js-team-input js-table-team-name-input"
                                                name="team_names[<?= esc((string) $team['id']) ?>]"
                                                value="<?= esc($team['name']) ?>"
                                                autocomplete="off"
                                                <?= $readonlyAttr ?>
                                            >
                                            <div class="custom-dropdown-menu js-custom-dropdown js-table-team-dropdown"></div>
                                        </div>
                                    </div>
                                </div>
                            </td>

                            <?php foreach ($gameNos as $gameNo): ?>
                                <?php
                                $score     = $teamScores[$gameNo] ?? null;
                                $rank      = old("scores.{$team['id']}.{$gameNo}.rank_no", $score['rank_no'] ?? '');
                                $kill      = old("scores.{$team['id']}.{$gameNo}.kill_point", $score['kill_point'] ?? '');
                                $placement = $score['placement_point'] ?? 0;
                                ?>
                                <td class="game-cell" data-game-col="<?= esc((string) $gameNo) ?>" data-col-role="rank">
                                    <input
                                        type="number"
                                        min="1"
                                        max="12"
                                        placeholder="-"
                                        class="form-control form-control-sm score-input js-score-input"
                                        name="scores[<?= esc((string) $team['id']) ?>][<?= esc((string) $gameNo) ?>][rank_no]"
                                        value="<?= esc((string) $rank) ?>"
                                        <?= $disabledAttr ?>
                                    >
                                </td>

                                <td class="score-placement-cell" data-game-col="<?= esc((string) $gameNo) ?>" data-col-role="placement">
                                    <?= esc((string) $placement) ?>
                                </td>

                                <td class="game-cell" data-game-col="<?= esc((string) $gameNo) ?>" data-col-role="kill">
                                    <input
                                        type="number"
                                        min="0"
                                        placeholder="0"
                                        class="form-control form-control-sm score-input js-score-input"
                                        name="scores[<?= esc((string) $team['id']) ?>][<?= esc((string) $gameNo) ?>][kill_point]"
                                        value="<?= esc((string) $kill) ?>"
                                        <?= $disabledAttr ?>
                                    >
                                </td>
                            <?php endforeach; ?>

                            <td class="qualify-cell controller-only">
                                <input
                                    type="checkbox"
                                    class="form-check-input js-advance-team"
                                    value="<?= esc((string) $team['id']) ?>"
                                    <?= $disabledAttr ?>
                                >
                            </td>

                            <td class="score-total-cell total-cell"><?= esc((string) ($totalsByTeam[$team['id']] ?? 0)) ?></td>

                            <td class="team-row-actions controller-only">
                                <button
                                    type="button"
                                    class="btn btn-outline-danger btn-sm toolbar-btn js-inline-team-delete"
                                    style="height: 22px !important; padding: 0 6px !important; font-size: 0.68rem !important;"
                                    data-delete-url="<?= site_url('teams/detach/' . $team['id']) ?>"
                                    data-team-id="<?= esc((string) $team['id']) ?>"
                                    data-team-name="<?= esc((string) $team['name']) ?>"
                                    data-confirm-title="Lepas Dari Pot"
                                    data-confirm-message="Yakin ingin melepas team ini dari pot dan menghapus score terkait? Data team tetap tersimpan di database."
                                    data-confirm-submit="Lepas"
                                    title="Keluarkan tim dari Pot ini"
                                    <?= $disabledAttr ?>
                                >
                                    &times;
                                </button>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>

            <?php if ($teams === []): ?>
                <div class="pot-empty-state js-pot-empty-state p-3 text-center text-muted">
                    <div>Belum ada tim di dalam pot ini. Klik tombol <strong>+ Tim</strong> di atas atau tarik tim lewat menu Drag &amp; Drop Manager.</div>
                </div>
            <?php endif; ?>
        </div>

        <!-- Status Bar & Petunjuk Shortcut Spreadsheet -->
        <div class="excel-statusbar controller-only">
            <div>
                <span>Navigasi Cepat:</span>
                <span class="excel-kbd">&uarr;</span>
                <span class="excel-kbd">&darr;</span>
                <span class="excel-kbd">&larr;</span>
                <span class="excel-kbd">&rarr;</span>
                <span>Pindah Sel</span>
                &nbsp;|&nbsp;
                <span class="excel-kbd">Enter</span>
                <span>Turun 1 Baris (Kolom Sama)</span>
            </div>
            <div>
                <span>Sistem Poin: <strong><?= esc(strtoupper((string) ($pointSystem ?? 'FFWS'))) ?></strong> (Kill &times;<?= esc((string) ($killPoints ?? 1)) ?>) &bull; Autosave Aktif</span>
            </div>
        </div>
    </form>
</div>

<?php if ($showCardWrapper): ?>
    </div>
</section>
<?php endif; ?>