<!doctype html>
<html lang="en" style="font-size: 12.8px !important;">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= esc($pageTitle ?? 'Battleground Calc') ?></title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Base dark app CSS -->
    <link href="<?= base_url('assets/css/dark-app.css?v=' . time()) ?>" rel="stylesheet">
    <!-- Dashboard Layout CSS -->
    <link href="<?= base_url('assets/css/dashboard-layout.css?v=' . time()) ?>" rel="stylesheet">
    <!-- GLOBAL COMPACT 80% CSS (MURNI KODE TANPA ZOOM) -->
    <link href="<?= base_url('assets/css/compact-80.css?v=' . time()) ?>" rel="stylesheet">
    <?= $this->renderSection('styles') ?>
</head>
<?php
$layoutUser = auth()->user();
$hasGlobalCms = $layoutUser !== null && $layoutUser->inGroup('admin');
?>

<body class="app-dark new-dashboard-theme<?= $hasGlobalCms ? ' has-global-cms' : '' ?>"
    style="font-size: 12.8px !important;" data-bg-base-url="<?= esc(site_url('/'), 'attr') ?>"
    data-bg-csrf-token-name="<?= esc(csrf_token(), 'attr') ?>" data-bg-csrf-hash="<?= esc(csrf_hash(), 'attr') ?>">

    <div class="dashboard-wrapper">
        <!-- SIDEBAR -->
        <?= $this->include('partials/sidebar', ['user' => $layoutUser, 'isAdmin' => $hasGlobalCms]) ?>

        <!-- CONTENT AREA (Topbar + Main) -->
        <div class="dashboard-content-wrapper">
            <!-- TOPBAR -->
            <?= $this->include('partials/topbar', ['user' => $layoutUser, 'isAdmin' => $hasGlobalCms, 'pageTitle' => $pageTitle ?? 'Dashboard']) ?>

            <!-- MAIN CONTENT -->
            <main class="dashboard-main-content" style="padding: 10px 14px !important;">
                <div id="ajaxFlashHost" class="app-flash-host"></div>
                <?= $this->include('partials/flash') ?>
                <?= $this->renderSection('content') ?>
            </main>
        </div>
    </div>

    <!-- MODALS -->
    <?= $this->renderSection('modals') ?>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<?= base_url('assets/js/app-shell.js?v=' . time()) ?>"></script>
    <script src="<?= base_url('assets/js/score-workspace.js?v=' . time()) ?>"></script>

</body>

</html>