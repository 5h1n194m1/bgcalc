<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<div id="smartImportApp"
    style="color: #e2e8f0; width: 100%; padding-bottom: 48px; font-family: system-ui, -apple-system, sans-serif;">
    <div id="smartImportCsrf" style="display: none;"><?= csrf_field() ?></div>

    <!-- ================= HEADER CARD ================= -->
    <div
        style="background: #0f172a; border: 1px solid #334155; border-left: 4px solid #3b82f6; padding: 16px 20px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
        <div>
            <h1
                style="margin: 0; font-size: 1.15rem; font-weight: 800; color: #f8fafc; text-transform: uppercase; letter-spacing: 0.05em;">
                Smart CSV / Spreadsheet Import Engine
            </h1>
            <p style="margin: 6px 0 0 0; font-size: 0.8rem; color: #94a3b8;">
                Upload file (.csv, .tsv, .txt) atau Copy-Paste langsung dari Excel / Google Sheets, lalu cocokkan kolom
                secara bebas sebelum masuk ke Pot.
            </p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="<?= site_url('teams/roster') ?>"
                style="background: #1e293b; color: #38bdf8; border: 1px solid #334155; padding: 8px 14px; font-size: 0.78rem; font-weight: 700; text-decoration: none; text-transform: uppercase;">
                Ke Mass Roster Hub
            </a>
            <a href="<?= site_url('teams/drag-manager') ?>"
                style="background: #1e293b; color: #cbd5e1; border: 1px solid #334155; padding: 8px 14px; font-size: 0.78rem; font-weight: 700; text-decoration: none; text-transform: uppercase;">
                Ke Drag Manager
            </a>
        </div>
    </div>

    <!-- ================= STEP 1: UPLOAD / PASTE ================= -->
    <div style="background: #0f172a; border: 1px solid #334155; padding: 20px; margin-bottom: 20px;">
        <div
            style="border-bottom: 1px solid #1e293b; padding-bottom: 10px; margin-bottom: 16px; font-weight: 800; font-size: 0.88rem; color: #38bdf8; text-transform: uppercase;">
            Langkah 1: Sumber Data (Pilih File atau Copy-Paste Spreadsheet)
        </div>

        <form id="formSmartPreview" enctype="multipart/form-data">
            <div
                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px; margin-bottom: 16px;">
                <div>
                    <label
                        style="display: block; font-size: 0.74rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 6px;">
                        Opsi A: Upload File (.CSV / .TSV / .TXT)
                    </label>
                    <input type="file" name="team_file" id="smartFileInput" accept=".csv,.tsv,.txt"
                        style="width: 100%; background: #0b1120; border: 1px solid #334155; color: #f8fafc; padding: 9px 12px; font-size: 0.82rem; box-sizing: border-box;">
                    <div style="font-size: 0.72rem; color: #64748b; margin-top: 6px;">
                        Mendukung pemisah Koma (`,`), Titik Koma (`;`), dan Tab secara otomatis.
                    </div>
                </div>

                <div>
                    <label
                        style="display: block; font-size: 0.74rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 6px;">
                        Opsi B: Atau Copy-Paste Langsung Sel dari Excel / Google Sheets
                    </label>
                    <textarea name="raw_paste" id="smartPasteInput" rows="4"
                        placeholder="Nama Team&#9;Kapten&#9;Player 2&#9;Player 3&#9;Pot&#10;ONIC Esports&#9;Kiboy&#9;Kairi&#9;Sanz&#9;POT 1"
                        style="width: 100%; background: #0b1120; border: 1px solid #334155; color: #f8fafc; padding: 9px 12px; font-size: 0.82rem; font-family: monospace; box-sizing: border-box;"></textarea>
                </div>
            </div>

            <div style="display: flex; justify-content: flex-end;">
                <button type="submit" id="btnReadPreview"
                    style="background: #2563eb; color: #ffffff; border: 1px solid #3b82f6; padding: 9px 20px; font-weight: 800; font-size: 0.82rem; cursor: pointer; text-transform: uppercase;">
                    1. Baca Header &amp; Tampilkan Preview Data
                </button>
            </div>
        </form>
    </div>

    <!-- ================= STEP 2: DYNAMIC COLUMN MAPPING & PREVIEW ================= -->
    <div id="stepDynamicMapping" style="display: none; background: #0f172a; border: 1px solid #334155; padding: 20px;">
        <div
            style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #1e293b; padding-bottom: 10px; margin-bottom: 16px;">
            <span style="font-weight: 800; font-size: 0.88rem; color: #4ade80; text-transform: uppercase;">
                Langkah 2: Pencocokan Kolom Dinamis &amp; Smart Pot Allocator
            </span>
            <span id="previewRowCountBadge"
                style="background: #1e293b; color: #38bdf8; border: 1px solid #334155; padding: 3px 10px; font-size: 0.76rem; font-weight: 800;">
                0 Baris
            </span>
        </div>

        <form id="formCommitSmartImport">
            <!-- Pengaturan Turnamen & Mode Pot -->
            <div
                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 16px;">
                <div>
                    <label
                        style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 5px;">
                        Pilih Tournament Tujuan *
                    </label>
                    <select id="importTournamentId" required
                        style="width: 100%; background: #0b1120; border: 1px solid #334155; color: #f8fafc; padding: 8px 10px; font-size: 0.82rem;">
                        <option value="">-- Pilih Tournament --</option>
                        <?php foreach (($tournaments ?? []) as $t): ?>
                            <option value="<?= esc((string) $t['id']) ?>"><?= esc($t['name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>

                <div>
                    <label
                        style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 5px;">
                        Mode Alokasi Pot
                    </label>
                    <select id="importModeSelect"
                        style="width: 100%; background: #0b1120; border: 1px solid #334155; color: #f8fafc; padding: 8px 10px; font-size: 0.82rem;">
                        <option value="smart_overflow" selected>Smart Auto-Overflow (Otomatis Isi POT 1 -> POT 2 dst)
                        </option>
                        <option value="specific_pot">Masukkan ke Pot Spesifik (Overflow Jika Penuh)</option>
                        <option value="unassigned">Masukkan Semua ke Unassigned (Tanpa Pot)</option>
                        <option value="sandbox">Masukkan Semua ke Sandbox / Recycle Bin</option>
                    </select>
                </div>

                <div>
                    <label
                        style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 5px;">
                        Stage Default
                    </label>
                    <select id="importStageSelect"
                        style="width: 100%; background: #0b1120; border: 1px solid #334155; color: #f8fafc; padding: 8px 10px; font-size: 0.82rem;">
                        <option value="kualifikasi" selected>Kualifikasi</option>
                        <option value="semifinal">Semifinal</option>
                        <option value="grandfinal">Grand Final</option>
                    </select>
                </div>

                <div id="specificPotWrap" style="display: none;">
                    <label
                        style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 5px;">
                        Target Pot
                    </label>
                    <select id="importPotIdSelect"
                        style="width: 100%; background: #0b1120; border: 1px solid #334155; color: #f8fafc; padding: 8px 10px; font-size: 0.82rem;">
                        <option value="">-- Auto --</option>
                        <?php foreach (($pots ?? []) as $p): ?>
                            <option value="<?= esc((string) $p['id']) ?>"><?= esc($p['name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
            </div>

            <!-- Pemetaan Kolom -->
            <div
                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 16px;">
                <div>
                    <label
                        style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #38bdf8; margin-bottom: 5px;">
                        Kolom Nama Tim (Wajib) *
                    </label>
                    <select id="mapColTeamName" required
                        style="width: 100%; background: #0b1120; border: 1px solid #3b82f6; color: #f8fafc; padding: 8px 10px; font-size: 0.82rem;"></select>
                </div>

                <div>
                    <label
                        style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 5px;">
                        Kolom Nama Pot / Grup (Opsional)
                    </label>
                    <select id="mapColPotName"
                        style="width: 100%; background: #0b1120; border: 1px solid #334155; color: #f8fafc; padding: 8px 10px; font-size: 0.82rem;"></select>
                </div>

                <div>
                    <label
                        style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 5px;">
                        Kolom Stage / Babak (Opsional)
                    </label>
                    <select id="mapColStage"
                        style="width: 100%; background: #0b1120; border: 1px solid #334155; color: #f8fafc; padding: 8px 10px; font-size: 0.82rem;"></select>
                </div>
            </div>

            <div style="margin-bottom: 16px;">
                <label
                    style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 6px;">
                    Kolom Anggota / Roster Pemain (Bisa Centang Lebih dari 1 Kolom)
                </label>
                <div id="mapColMembersBox"
                    style="display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 8px; background: #0b1120; border: 1px solid #334155; padding: 12px; max-height: 150px; overflow-y: auto;">
                </div>
            </div>

            <!-- Tabel Preview -->
            <div style="margin-bottom: 16px;">
                <label
                    style="display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; margin-bottom: 6px;">
                    Preview 10 Baris Pertama
                </label>
                <div style="overflow-x: auto; max-height: 300px; border: 1px solid #334155; background: #090d16;">
                    <table id="smartPreviewTable"
                        style="width: 100%; border-collapse: collapse; font-family: monospace; font-size: 0.78rem;">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

            <div
                style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                <div id="smartImportStatus" style="font-size: 0.84rem; font-weight: 700; color: #38bdf8;"></div>
                <button type="submit" id="btnExecuteSmartImport"
                    style="background: #16a34a; color: #ffffff; border: 1px solid #22c55e; padding: 10px 24px; font-weight: 800; font-size: 0.82rem; cursor: pointer; text-transform: uppercase;">
                    2. Eksekusi Import ke Database
                </button>
            </div>
        </form>
    </div>
</div>

<script <?= function_exists('csp_script_nonce') ? csp_script_nonce() : '' ?>>
    document.addEventListener('DOMContentLoaded', function () {
        var parsedRowsCache = [];

        var formPreview = document.getElementById('formSmartPreview');
        var formCommit = document.getElementById('formCommitSmartImport');
        var stepMapping = document.getElementById('stepDynamicMapping');
        var modeSelect = document.getElementById('importModeSelect');
        var specPotWrap = document.getElementById('specificPotWrap');
        var mapTeamName = document.getElementById('mapColTeamName');
        var mapPotName = document.getElementById('mapColPotName');
        var mapStage = document.getElementById('mapColStage');
        var mapMembersBox = document.getElementById('mapColMembersBox');
        var previewTable = document.getElementById('smartPreviewTable');
        var statusBox = document.getElementById('smartImportStatus');

        function getCsrf() {
            var input = document.querySelector('#smartImportCsrf input[type="hidden"]');
            return {
                name: input ? input.name : (document.body.getAttribute('data-bg-csrf-token-name') || '<?= esc(csrf_token()) ?>'),
                hash: input ? input.value : (document.body.getAttribute('data-bg-csrf-hash') || '<?= esc(csrf_hash()) ?>')
            };
        }

        function updateCsrf(res) {
            if (!res || !res.csrfHash) return;
            var input = document.querySelector('#smartImportCsrf input[type="hidden"]');
            if (input) input.value = res.csrfHash;
            document.body.setAttribute('data-bg-csrf-hash', res.csrfHash);
        }

        if (modeSelect) {
            modeSelect.addEventListener('change', function () {
                specPotWrap.style.display = (modeSelect.value === 'specific_pot') ? 'block' : 'none';
            });
        }

        function fillColumnDropdown(selectEl, headers, guessedIdx, allowEmpty) {
            selectEl.innerHTML = '';
            if (allowEmpty) {
                var emptyOpt = document.createElement('option');
                emptyOpt.value = '-1';
                emptyOpt.textContent = '-- Tidak Dipakai / Abaikan --';
                selectEl.appendChild(emptyOpt);
            }
            headers.forEach(function (h, i) {
                var opt = document.createElement('option');
                opt.value = String(i);
                opt.textContent = '[Kolom ' + (i + 1) + '] ' + h;
                if (i === guessedIdx) opt.selected = true;
                selectEl.appendChild(opt);
            });
        }

        formPreview.addEventListener('submit', function (e) {
            e.preventDefault();
            var btn = document.getElementById('btnReadPreview');
            btn.disabled = true;
            btn.textContent = 'Membaca Data...';

            var fd = new FormData(formPreview);
            var csrf = getCsrf();
            fd.append(csrf.name, csrf.hash);

            fetch('<?= site_url("imports/raw-csv/preview") ?>', {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                body: fd
            })
                .then(function (r) { return r.json(); })
                .then(function (res) {
                    updateCsrf(res);

                    if (res.status !== 'success') {
                        alert(res.message || 'Gagal membaca data preview.');
                        return;
                    }

                    parsedRowsCache = res.all_rows || [];
                    document.getElementById('previewRowCountBadge').textContent = res.total_rows + ' Baris Data';

                    var guess = res.auto_map || {};
                    fillColumnDropdown(mapTeamName, res.headers, guess.team_name >= 0 ? guess.team_name : 0, false);
                    fillColumnDropdown(mapPotName, res.headers, guess.pot_name !== undefined ? guess.pot_name : -1, true);
                    fillColumnDropdown(mapStage, res.headers, guess.stage !== undefined ? guess.stage : -1, true);

                    mapMembersBox.innerHTML = '';
                    res.headers.forEach(function (h, i) {
                        var lbl = document.createElement('label');
                        lbl.style.cssText = 'display:flex; align-items:center; gap:6px; font-size:0.78rem; color:#f1f5f9; cursor:pointer;';
                        var cb = document.createElement('input');
                        cb.type = 'checkbox';
                        cb.value = String(i);
                        cb.className = 'js-map-member-col';
                        if (Array.isArray(guess.members) && guess.members.indexOf(i) !== -1) {
                            cb.checked = true;
                        }
                        lbl.appendChild(cb);
                        lbl.appendChild(document.createTextNode('[' + (i + 1) + '] ' + h));
                        mapMembersBox.appendChild(lbl);
                    });

                    var thead = previewTable.querySelector('thead');
                    var tbody = previewTable.querySelector('tbody');
                    thead.innerHTML = '';
                    tbody.innerHTML = '';

                    var trH = document.createElement('tr');
                    res.headers.forEach(function (h, i) {
                        var th = document.createElement('th');
                        th.style.cssText = 'background:#1e293b; color:#38bdf8; padding:6px 10px; border:1px solid #334155; text-align:left; white-space:nowrap;';
                        th.textContent = '[' + (i + 1) + '] ' + h;
                        trH.appendChild(th);
                    });
                    thead.appendChild(trH);

                    (res.preview_rows || []).forEach(function (row) {
                        var tr = document.createElement('tr');
                        res.headers.forEach(function (_, colIdx) {
                            var td = document.createElement('td');
                            td.style.cssText = 'padding:5px 10px; border:1px solid #1e293b; color:#cbd5e1; white-space:nowrap;';
                            td.textContent = row[colIdx] !== undefined ? row[colIdx] : '';
                            tr.appendChild(td);
                        });
                        tbody.appendChild(tr);
                    });

                    stepMapping.style.display = 'block';
                    stepMapping.scrollIntoView({ behavior: 'smooth' });
                })
                .catch(function () {
                    alert('Terjadi kesalahan jaringan saat membaca preview.');
                })
                .finally(function () {
                    btn.disabled = false;
                    btn.textContent = '1. Baca Header & Tampilkan Preview Data';
                });
        });

        formCommit.addEventListener('submit', function (e) {
            e.preventDefault();
            var btn = document.getElementById('btnExecuteSmartImport');
            btn.disabled = true;
            btn.textContent = 'Mengimpor...';
            statusBox.style.color = '#38bdf8';
            statusBox.textContent = 'Memvalidasi dan mengalokasikan tim ke Pot...';

            var memberCols = Array.from(document.querySelectorAll('.js-map-member-col:checked')).map(function (cb) {
                return parseInt(cb.value, 10);
            });
            var csrf = getCsrf();

            var payload = {
                tournament_id: document.getElementById('importTournamentId').value,
                import_mode: modeSelect.value,
                stage: document.getElementById('importStageSelect').value,
                pot_id: document.getElementById('importPotIdSelect').value,
                mapping: {
                    team_name: parseInt(mapTeamName.value, 10),
                    pot_name: parseInt(mapPotName.value, 10),
                    stage: parseInt(mapStage.value, 10),
                    members: memberCols
                },
                rows: parsedRowsCache
            };
            payload[csrf.name] = csrf.hash;

            fetch('<?= site_url("imports/raw-csv/process") ?>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRF-TOKEN': csrf.hash
                },
                body: JSON.stringify(payload)
            })
                .then(function (r) { return r.json(); })
                .then(function (res) {
                    updateCsrf(res);

                    if (res.status !== 'success') {
                        statusBox.style.color = '#f87171';
                        statusBox.textContent = res.message || 'Import gagal.';
                        return;
                    }

                    statusBox.style.color = '#4ade80';
                    statusBox.textContent = res.message;
                    setTimeout(function () {
                        if (res.redirectUrl) window.location.href = res.redirectUrl;
                    }, 1000);
                })
                .catch(function () {
                    statusBox.style.color = '#f87171';
                    statusBox.textContent = 'Kesalahan jaringan saat menyimpan import.';
                })
                .finally(function () {
                    btn.disabled = false;
                    btn.textContent = '2. Eksekusi Import ke Database';
                });
        });
    });
</script>
<?= $this->endSection() ?>