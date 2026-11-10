<?php

$user    = $user ?? auth()->user();
$isAdmin = $isAdmin ?? ($user !== null && $user->inGroup('admin'));

if (! $isAdmin) {
    return;
}

$request = service('request');
$segments = $request->getUri()->getSegments();
$segment1 = trim((string) ($segments[0] ?? ''));
$currentPath = trim($request->getUri()->getPath(), '/');

$quickLinks = [
    [
        'label' => 'Management Event',
        'href' => site_url('dashboard'),
        'icon' => 'ME',
        'active' => $segment1 === '' || $segment1 === 'dashboard' || $segment1 === 'tournaments',
    ],
    [
        'label' => 'Import Teams',
        'href' => site_url('imports/teams'),
        'icon' => 'IM',
        'active' => $segment1 === 'imports',
    ],
    [
        'label' => 'Teams',
        'href' => site_url('teams/roster'),
        'icon' => 'TM',
        'active' => $segment1 === 'teams',
    ],
];
?>
<div class="app-global-cms-backdrop js-global-cms-backdrop"></div>

<!-- Tambahan style: top 75px dan penyesuaian tinggi agar turun tepat di bawah navbar -->
<aside class="app-global-cms-sidebar" id="globalCmsPanel" aria-label="Global controller" style="top: 100px; height: calc(100vh - 75px);">
    
    <!-- Bagian Logo (Brand) dan Profil User di dalam sidebar DIHAPUS -->
    <!-- Karena informasi tersebut sudah tampil dengan rapi di Navbar Atas -->

    <div class="app-global-cms-body">
        <div class="app-global-cms-section">
            <nav class="app-global-cms-nav">
                <?php foreach ($quickLinks as $link): ?>
                    <a
                        href="<?= esc($link['href']) ?>"
                        class="app-global-cms-nav-link<?= $link['active'] ? ' is-active' : '' ?>"
                        data-global-cms-item
                        data-search-text="<?= esc(strtolower($link['label'])) ?>">
                        <span class="app-global-cms-nav-icon"><?= esc($link['icon']) ?></span>
                        <span class="app-global-cms-nav-copy">
                            <span class="app-global-cms-nav-text"><?= esc($link['label']) ?></span>

                            <?php if (! empty($link['description'])): ?>
                                <span class="app-global-cms-nav-meta">
                                    <?= esc($link['description']) ?>
                                </span>
                            <?php endif; ?>

                        </span>
                    </a>
                <?php endforeach; ?>
            </nav>
        </div>
    </div>
</aside>