<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<style>
/* Zero Border Radius Utilitarian Dark Theme */
* {
    border-radius: 0 !important;
}
.raw-import-card {
    background-color: #1a1a1a;
    border: 1px solid #444;
    padding: 20px;
    color: #fff;
    margin-bottom: 20px;
}
.raw-import-header {
    border-bottom: 1px solid #444;
    padding-bottom: 10px;
    margin-bottom: 20px;
    font-weight: bold;
    font-size: 1.2rem;
}
.util-input, .util-select, .util-btn {
    background-color: #2a2a2a;
    border: 1px solid #555;
    color: #fff;
    padding: 10px 15px;
    width: 100%;
    margin-bottom: 15px;
    outline: none;
}
.util-input:focus, .util-select:focus {
    border-color: #888;
}
.util-btn {
    background-color: #0056b3;
    border: 1px solid #004494;
    cursor: pointer;
    font-weight: bold;
    transition: background 0.2s;
}
.util-btn:hover {
    background-color: #004494;
}
.util-label {
    display: block;
    margin-bottom: 5px;
    color: #ccc;
    font-size: 0.9rem;
}
.log-area {
    background: #111;
    border: 1px solid #444;
    padding: 15px;
    min-height: 100px;
    max-height: 300px;
    overflow-y: auto;
    font-family: monospace;
    font-size: 0.85rem;
    color: #0f0;
}
</style>

<div class="raw-import-card">
    <div class="raw-import-header">Raw Google Forms CSV Importer</div>
    
    <label class="util-label">Select Tournament</label>
    <select id="csvTournament" class="util-select">
        <option value="">-- Select Tournament --</option>
        <?php foreach ($tournaments as $t): ?>
            <option value="<?= esc($t['id']) ?>"><?= esc($t['name']) ?></option>
        <?php endforeach; ?>
    </select>

    <label class="util-label">Select Pot (Optional)</label>
    <select id="csvPot" class="util-select">
        <option value="">-- No Pot (Global) --</option>
        <?php foreach ($pots as $p): ?>
            <option value="<?= esc($p['id']) ?>"><?= esc($p['name']) ?> (Tr: <?= esc($p['tournament_id']) ?>)</option>
        <?php endforeach; ?>
    </select>

    <label class="util-label">Upload Raw CSV File</label>
    <input type="file" id="csvFile" class="util-input" accept=".csv" />

    <button id="btnProcessCsv" class="util-btn">PROCESS & IMPORT CSV</button>
</div>

<div class="raw-import-card">
    <div class="raw-import-header">Process Log</div>
    <div id="importLog" class="log-area">Ready...</div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/5.4.1/papaparse.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
    const btnProcess = document.getElementById('btnProcessCsv');
    const fileInput = document.getElementById('csvFile');
    const tournamentSelect = document.getElementById('csvTournament');
    const potSelect = document.getElementById('csvPot');
    const importLog = document.getElementById('importLog');

    function logMessage(msg) {
        importLog.innerHTML += `<div>> ${msg}</div>`;
        importLog.scrollTop = importLog.scrollHeight;
    }

    btnProcess.addEventListener('click', () => {
        const file = fileInput.files[0];
        const tournamentId = tournamentSelect.value;
        const potId = potSelect.value;

        if (!tournamentId) {
            alert('Please select a tournament.');
            return;
        }

        if (!file) {
            alert('Please select a CSV file.');
            return;
        }

        logMessage('Reading CSV with PapaParse...');

        Papa.parse(file, {
            header: true,
            skipEmptyLines: true,
            complete: function(results) {
                logMessage(`Parsed ${results.data.length} rows.`);
                processParsedData(results.data, tournamentId, potId);
            },
            error: function(err) {
                logMessage(`PapaParse Error: ${err.message}`);
            }
        });
    });

    function processParsedData(rows, tournamentId, potId) {
        const payload = [];

        rows.forEach((row, index) => {
            // Find team name column (messy header matching)
            let teamName = '';
            let whatsapp = '';
            let players = [];

            // Simple heuristic to find columns
            for (let key in row) {
                const lowerKey = key.toLowerCase();
                const val = row[key] ? row[key].trim() : '';

                if (!val) continue;

                if (lowerKey.includes('nama team') || lowerKey.includes('team name') || lowerKey.includes('nama_team')) {
                    teamName = val;
                } else if (lowerKey.includes('wa') || lowerKey.includes('whatsapp') || lowerKey.includes('perwakilan')) {
                    whatsapp = val;
                } else if (lowerKey.includes('nick') || lowerKey.includes('player') || lowerKey.includes('pemain') || lowerKey.includes('anggota')) {
                    players.push(val);
                }
            }

            if (teamName) {
                payload.push({
                    team_name: teamName,
                    whatsapp: whatsapp,
                    players: players
                });
            }
        });

        logMessage(`Mapped ${payload.length} valid teams.`);
        if (payload.length > 0) {
            sendToBackend(payload, tournamentId, potId);
        } else {
            logMessage('No valid teams found to import.');
        }
    }

    function sendToBackend(data, tournamentId, potId) {
        logMessage('Sending payload to backend...');
        
        // Get CSRF from body dataset (standard in this app)
        const csrfTokenName = document.body.dataset.bgCsrfTokenName;
        const csrfHash = document.body.dataset.bgCsrfHash;

        fetch('<?= site_url('imports/raw-csv/process') ?>', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                [csrfTokenName]: csrfHash
            },
            body: JSON.stringify({
                data: data,
                tournament_id: tournamentId,
                pot_id: potId
            })
        })
        .then(response => response.json())
        .then(res => {
            // Update CSRF token for future requests
            if (res.csrfTokenName && res.csrfHash) {
                document.body.dataset.bgCsrfTokenName = res.csrfTokenName;
                document.body.dataset.bgCsrfHash = res.csrfHash;
            }

            if (res.status === 'success') {
                logMessage(`SUCCESS: ${res.message}`);
                alert('Import successful!');
            } else {
                logMessage(`ERROR: ${res.message}`);
            }
        })
        .catch(error => {
            logMessage(`Fetch Error: ${error}`);
        });
    }

    // Vanilla JS Sidebar Toggle (Fallback/Enforcement)
    const sidebar = document.querySelector('.js-dashboard-sidebar');
    const overlay = document.querySelector('.js-sidebar-overlay');
    // Assuming there is a toggle button somewhere or we can create one
    // But since the layout handles it, we just ensure it exists
    document.addEventListener('click', (e) => {
        if (e.target.closest('.js-sidebar-toggle')) {
            if (sidebar) sidebar.classList.toggle('collapsed');
            if (overlay) overlay.classList.toggle('active');
        }
    });
});
</script>
<?= $this->endSection() ?>
