<?php
$user    = $user ?? auth()->user();
$isAdmin = $isAdmin ?? ($user !== null && $user->inGroup('admin'));

$username = $user?->username ?? $user?->email ?? 'User';
$roleLabel = $isAdmin ? 'Administrator' : 'User';
?>

<!-- KUNCI NAVBAR: Mematikan animasi lompat & pergeseran layout dari tema -->
<style>
    /* 1. Matikan efek "melompat" pada tombol burger saat diklik/fokus */
    .nav-sidebar-toggle:hover,
    .nav-sidebar-toggle:focus,
    .nav-sidebar-toggle:active {
        transform: none !important;
    }

    /* 2. Kunci bantalan (padding) navbar agar tidak ditarik oleh sistem Sidebar */
    @media (min-width: 1200px) {
        body.has-global-cms .app-topbar .container-fluid,
        body.has-global-cms.app-global-cms-collapsed .app-topbar .container-fluid {
            padding-left: 1.5rem !important;
            transition: none !important;
        }
    }
</style>

<nav class="navbar navbar-expand-xl navbar-dark app-topbar sticky-top">
    <div class="container-fluid px-3 px-xl-4" style="padding-left: 1.5rem !important; transition: none !important;">
        
        <div class="d-flex align-items-center gap-2 flex-shrink-0">
            <?php if ($isAdmin): ?>
                <button type="button" class="btn btn-link nav-sidebar-toggle js-global-cms-toggle" aria-controls="globalCmsPanel" aria-expanded="false" aria-label="Toggle global controller">
                    <span class="nav-sidebar-toggle-bars"></span>
                </button>
            <?php endif; ?>

            <a href="<?= site_url('dashboard') ?>" class="navbar-brand app-brand d-flex align-items-center gap-2 m-0 text-decoration-none">
                <span class="app-brand-mark" aria-hidden="true">BC</span>
                <span class="app-brand-copy d-flex flex-column lh-sm">
                    <span class="app-brand-name">Battleground Calc</span>
                    <span class="app-brand-subtitle">Admin Workspace</span>
                </span>
            </a>
        </div>

        <button class="navbar-toggler ms-2" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <div class="d-flex align-items-center gap-2 gap-xl-3 ms-auto mt-3 mt-xl-0">
                <div class="app-user-pill">
                    <div class="app-user-avatar" aria-hidden="true"><?= esc(mb_strtoupper(mb_substr((string) $username, 0, 1))) ?></div>
                    <div class="app-user-copy">
                        <div class="app-user-name"><?= esc($username) ?></div>
                        <div class="app-user-role"><?= esc($roleLabel) ?></div>
                    </div>
                </div>
                <!-- Tombol logout yang sudah dilengkapi penghapus memori cache JS -->
                <a href="<?= site_url('logout') ?>" onclick="localStorage.clear(); sessionStorage.clear();" class="btn btn-outline-light btn-sm app-btn app-btn-ghost">Logout</a>
            </div>
        </div>
    </div>
</nav>