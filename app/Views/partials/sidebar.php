<?php
$request = service('request');
$segments = $request->getUri()->getSegments();
$segment1 = trim((string) ($segments[0] ?? ''));
$segment2 = trim((string) ($segments[1] ?? ''));

$navLinks = [
    [
        'label' => 'Dashboard',
        'href' => site_url('dashboard'),
        'icon' => '<svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="square" stroke-linejoin="miter" d="M3 3h7v9H3zM14 3h7v5h-7zM14 12h7v9h-7zM3 16h7v5H3z"></path></svg>',
        'active' => $segment1 === '' || $segment1 === 'dashboard' || $segment1 === 'tournaments',
    ],
    [
        'label' => 'Drag & Drop Manager',
        'href' => site_url('teams/drag-manager'),
        'icon' => '<svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="square" stroke-linejoin="miter" d="M4 6h16M4 12h16M4 18h16"></path></svg>',
        'active' => $segment1 === 'teams' && $segment2 === 'drag-manager',
    ],
    [
        'label' => 'Import Teams (Raw CSV)',
        'href' => site_url('imports/raw-csv'),
        'icon' => '<svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="square" stroke-linejoin="miter" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path></svg>',
        'active' => $segment1 === 'imports' && $segment2 === 'raw-csv',
    ],
    [
        'label' => 'Edit Teams (Roster Hub)',
        'href' => site_url('teams/roster'),
        'icon' => '<svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="square" stroke-linejoin="miter" d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"></path></svg>',
        'active' => $segment1 === 'teams' && $segment2 === 'roster',
    ],
];
?>
<aside class="dashboard-sidebar js-dashboard-sidebar" aria-hidden="true">
    <div class="sidebar-brand" style="justify-content: space-between;">
        <div style="display: flex; align-items: center; gap: 0.65rem; min-width: 0;">
            <div class="brand-logo">BC</div>
            <div class="brand-text">Battleground Calc</div>
        </div>
        <button type="button" class="js-sidebar-close" aria-label="Close Sidebar"
            style="background: transparent; border: 1px solid #334155; color: #94a3b8; width: 28px; height: 28px; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1rem; line-height: 1; cursor: pointer;">
            &times;
        </button>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-group-title">Main Navigation</div>
        <?php foreach ($navLinks as $link): ?>
            <a href="<?= esc($link['href']) ?>" class="sidebar-link<?= $link['active'] ? ' active' : '' ?>">
                <span class="sidebar-link-icon"
                    style="display: inline-flex; align-items: center;"><?= $link['icon'] ?></span>
                <span class="sidebar-link-label"><?= esc($link['label']) ?></span>
            </a>
        <?php endforeach; ?>
    </nav>
</aside>
<div class="sidebar-overlay js-sidebar-overlay"></div>