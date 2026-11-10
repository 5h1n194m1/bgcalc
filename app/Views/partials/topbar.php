<?php
$isAdmin = auth()->user()?->inGroup('admin') ?? false;
$username = $user?->username ?? $user?->email ?? 'User';
$roleLabel = $isAdmin ? 'Administrator' : 'User';
?>
<header class="dashboard-topbar">
    <div class="topbar-left">
        <button type="button" class="btn-hamburger js-sidebar-toggle" aria-label="Toggle Sidebar">
            <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path stroke-linecap="square" stroke-linejoin="miter" d="M4 6h16M4 12h16M4 18h16"></path>
            </svg>
        </button>
        <h1 class="topbar-page-title"><?= esc($pageTitle ?? 'Dashboard') ?></h1>
    </div>
    
    <div class="topbar-right">
        <div class="topbar-user-info">
            <span class="user-name"><?= esc($username) ?></span>
            <span class="user-role"><?= esc($roleLabel) ?></span>
        </div>
        <!-- Logout button triggers JS clear as requested previously -->
        <a href="<?= site_url('logout') ?>" onclick="localStorage.clear(); sessionStorage.clear();" class="btn-logout">
            Logout
        </a>
    </div>
</header>
