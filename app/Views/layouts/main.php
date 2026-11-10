<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= esc($pageTitle ?? 'Battleground Calc') ?></title>
    <!-- Keep Bootstrap for internal components as user might still use it inside the page -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Base dark app CSS -->
    <link href="<?= base_url('assets/css/dark-app.css?v=' . time()) ?>" rel="stylesheet">
    <!-- NEW DASHBOARD LAYOUT CSS -->
    <link href="<?= base_url('assets/css/dashboard-layout.css?v=' . time()) ?>" rel="stylesheet">
    <?= $this->renderSection('styles') ?>
</head>
<?php
$layoutUser = auth()->user();
$hasGlobalCms = $layoutUser !== null && $layoutUser->inGroup('admin');
?>

<body class="app-dark new-dashboard-theme<?= $hasGlobalCms ? ' has-global-cms' : '' ?>"
    data-bg-base-url="<?= esc(site_url('/'), 'attr') ?>" data-bg-csrf-token-name="<?= esc(csrf_token(), 'attr') ?>"
    data-bg-csrf-hash="<?= esc(csrf_hash(), 'attr') ?>">

    <div class="dashboard-wrapper">
        <!-- SIDEBAR -->
        <?= $this->include('partials/sidebar', ['user' => $layoutUser, 'isAdmin' => $hasGlobalCms]) ?>

        <!-- CONTENT AREA (Topbar + Main) -->
        <div class="dashboard-content-wrapper">
            <!-- TOPBAR -->
            <?= $this->include('partials/topbar', ['user' => $layoutUser, 'isAdmin' => $hasGlobalCms, 'pageTitle' => $pageTitle ?? 'Dashboard']) ?>

            <!-- MAIN CONTENT -->
            <main class="dashboard-main-content">
                <div id="ajaxFlashHost" class="app-flash-host"></div>
                <?= $this->include('partials/flash') ?>
                <?= $this->renderSection('content') ?>
            </main>
        </div>
    </div>

    <!-- MODALS -->
    <?= $this->renderSection('modals') ?>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- CUKUP 2 FILE JS INTI INI SAJA (Zero Conflict) -->
    <script src="<?= base_url('assets/js/app-shell.js?v=' . time()) ?>"></script>
    <script src="<?= base_url('assets/js/score-workspace.js?v=' . time()) ?>"></script>

    <!-- GLOBAL 80% COMPACT UI SCALER (ANTI-BOCOR CSS) -->
    <script <?= function_exists('csp_script_nonce') ? csp_script_nonce() : '' ?>>
        (function () {
            var globalScaleStyle = document.createElement('style');
            globalScaleStyle.textContent = [
                'html { zoom: 0.8; }',
                /* Kompensasi tinggi layar (100vh / 0.8 = 125vh) agar sidebar & background tetap penuh sampai bawah */
                'body, .dashboard-wrapper, .dashboard-content-wrapper { min-height: 125vh !important; }',
                '.dashboard-sidebar, .js-dashboard-sidebar, .js-sidebar-overlay { height: 125vh !important; min-height: 125vh !important; }'
            ].join('\n');
            document.head.appendChild(globalScaleStyle);
        })();
    </script>

</body>

</html>