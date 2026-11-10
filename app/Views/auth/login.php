<?= $this->extend(config('Auth')->views['layout']) ?>

<?= $this->section('title') ?>Login - Battleground Calc<?= $this->endSection() ?>

<?= $this->section('main') ?>
<?php
    $rawError = session('error');
    $displayError = $rawError;
    $expired = service('request')->getGet('expired') === '1';
    $throttled = service('request')->getGet('throttled') === '1';

    if ($expired) {
        $displayError = 'Sesi berakhir, silakan login kembali.';
    } elseif ($throttled) {
        $displayError = 'Terlalu banyak percobaan login. Tunggu sebentar lalu coba lagi.';
    } elseif (is_string($displayError) && trim($displayError) === 'The action you requested is not allowed.') {
        $displayError = 'Sesi berakhir, silakan login kembali.';
    }
?>
<div class="container-fluid auth-container">
    <div class="auth-card-wrap">
        <section class="card auth-card">
            <div class="card-body auth-card-body">
                <div class="auth-brand-block">
                    <div class="auth-eyebrow" style="font-size:2rem; letter-spacing:2px; margin-bottom:0.5rem;">🎮</div>
                    <div class="auth-eyebrow">Battleground Calc</div>
                    <h1 class="auth-title">Masuk</h1>
                    <p style="color:#6c757d; font-size:0.82rem; margin-top:-0.4rem;">Tournament Score Management System</p>
                </div>

                <?php if ($displayError !== null) : ?>
                    <div class="alert alert-danger" role="alert"><?= esc($displayError) ?></div>
                <?php elseif (session('errors') !== null) : ?>
                    <div class="alert alert-danger" role="alert">
                        <?php if (is_array(session('errors'))) : ?>
                            <?php foreach (session('errors') as $error) : ?>
                                <div><?= esc($error) ?></div>
                            <?php endforeach ?>
                        <?php else : ?>
                            <?= esc(session('errors')) ?>
                        <?php endif ?>
                    </div>
                <?php endif ?>

                <?php if (session('notice') !== null) : ?>
                    <div class="alert alert-secondary" role="alert"><?= esc(session('notice')) ?></div>
                <?php endif ?>

                <?php if (session('message') !== null) : ?>
                    <div class="alert alert-success" role="alert"><?= esc(session('message')) ?></div>
                <?php endif ?>

                <form action="<?= url_to('login') ?>" method="post" class="auth-form" novalidate>
                    <?= csrf_field() ?>

                    <div class="mb-3">
                        <label for="loginEmail" class="form-label auth-label">Email</label>
                        <input
                            type="email"
                            class="form-control"
                            id="loginEmail"
                            name="email"
                            inputmode="email"
                            autocomplete="email"
                            placeholder="nama@email.com"
                            value="<?= old('email') ?>"
                            required
                        >
                    </div>

                    <div class="mb-3">
                        <label for="loginPassword" class="form-label auth-label mb-1">Password</label>
                        <div class="input-group">
                            <input
                                type="password"
                                class="form-control"
                                id="loginPassword"
                                name="password"
                                autocomplete="current-password"
                                placeholder="Masukkan password"
                                required
                            >
                            <button type="button" class="btn btn-outline-secondary" id="togglePassword" tabindex="-1" title="Tampilkan/Sembunyikan password">👁</button>
                        </div>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary auth-submit-btn">Login</button>
                    </div>
                </form>
            </div>
        </section>
    </div>
</div>
<?= $this->endSection() ?>

<?= $this->section('pageScripts') ?>
<script>
    document.getElementById('togglePassword').addEventListener('click', function () {
        var input = document.getElementById('loginPassword');
        var isHidden = input.type === 'password';
        input.type = isHidden ? 'text' : 'password';
        this.textContent = isHidden ? '🙈' : '👁';
    });
</script>
<?= $this->endSection() ?>