<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="dashboard-page">
    <div class="page-header dashboard-page-header d-flex justify-content-between align-items-center flex-wrap gap-3 mb-2">
        <div class="page-title-block">
            <h1 class="h3 mb-1 text-white">Daftar Tournament</h1>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Kelola turnamen, pot, dan tim Anda di sini.</p>
        </div>

        <?php if (auth()->user()?->inGroup('admin')): ?>
            <a href="<?= site_url('tournaments/create') ?>" class="btn btn-primary btn-sm app-btn btn-sharp">
                + Tambah Tournament
            </a>
        <?php endif; ?>
    </div>

    <!-- Pengecekan Data Kosong -->
    <?php if ($tournaments === []): ?>
        <div class="card bg-dark border-secondary shadow-sm mt-4" style="border-radius: 0;">
            <div class="card-body p-5 text-center text-muted">
                <p class="mb-0">Belum ada tournament. Klik tombol "+ Tambah Tournament" di atas untuk memulai.</p>
            </div>
        </div>
    <?php else: ?>
    
        <!-- Grid Card Turnamen (Flat Minimalist) -->
        <div class="tournament-grid">
            <?php foreach ($tournaments as $tournament): ?>
                <?php
                $status = $tournament['status'] ?? 'belum_mulai';
                $statusLabel = $statusOptions[$status] ?? ucwords(str_replace('_', ' ', $status));
                
                $statusBoxClass = match ($status) {
                    'start' => 'status-live',
                    'selesai' => 'status-finished',
                    default => 'status-standby',
                };
                ?>
                
                <div class="t-card">
                    <div class="t-card-header">
                        <div>
                            <h3 class="t-card-title"><?= esc($tournament['name']) ?></h3>
                            <div class="t-card-id">ID: <?= esc($tournament['id']) ?></div>
                        </div>
                    </div>

                    <div class="t-card-stats">
                        <div class="t-stat-item">
                            <span class="t-stat-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M2.5.5A.5.5 0 0 1 3 0h10a.5.5 0 0 1 .5.5c0 .538-.012 1.05-.034 1.536a3 3 0 1 1-1.133 5.89c-.79 1.865-1.878 2.777-2.833 3.011v2.173l1.425.356c.194.048.377.135.537.255L13.3 15.1a.5.5 0 0 1-.3.9H3a.5.5 0 0 1-.3-.9l1.838-1.379c.16-.12.343-.207.537-.255L6.5 13.11v-2.173c-.955-.234-2.043-1.146-2.833-3.012a3 3 0 1 1-1.132-5.89A33.076 33.076 0 0 1 2.5.5zm.099 2.54a2 2 0 0 0 .72 3.935c-.333-1.05-.588-2.346-.72-3.935zm10.083 3.935a2 2 0 0 0 .72-3.935c-.133 1.59-.388 2.885-.72 3.935zM3.504 1c.007.517.026 1.006.056 1.469.13 2.028.457 3.546.87 4.667C5.294 9.48 6.484 10 8 10s2.706-.52 3.57-2.864c.413-1.12.74-2.64.87-4.667.03-.463.049-.952.056-1.469H3.504z"/></svg>
                            </span>
                            <span><?= esc((string) $tournament['pot_count']) ?> Pot Pertandingan</span>
                        </div>
                        <div class="t-stat-item">
                            <span class="t-stat-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8Zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022ZM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4Zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816ZM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0Zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"/></svg>
                            </span>
                            <span><?= esc((string) $tournament['team_count']) ?> Tim Terdaftar</span>
                        </div>
                    </div>

                    <div class="t-status-box <?= $statusBoxClass ?>">
                        <span class="status-indicator"></span>
                        <?= esc($statusLabel) ?>
                    </div>

                    <div class="t-card-actions">
                        <div class="t-action-left">
                            <a href="<?= site_url('tournaments/edit/' . $tournament['id']) ?>" class="btn-icon" title="Edit Tournament">
                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/></svg>
                            </a>
                            <form action="<?= site_url('tournaments/delete/' . $tournament['id']) ?>" method="post" class="m-0" data-confirm="Hapus tournament ini beserta seluruh data turunannya?">
                                <?= csrf_field() ?>
                                <input type="hidden" name="redirect_to" value="<?= esc(current_url()) ?>">
                                <button type="submit" class="btn-icon btn-icon-danger" title="Hapus Tournament">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5Zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5Zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6Z"/><path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1ZM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118ZM2.5 3h11V2h-11v1Z"/></svg>
                                </button>
                            </form>
                        </div>
                        <a href="<?= site_url('tournaments/' . $tournament['id'] . '/pots') ?>" class="btn-open">
                            Buka Turnamen <span aria-hidden="true">➔</span>
                        </a>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>
<?= $this->endSection() ?>