<?php

namespace App\Controllers;

use App\Models\PotModel;
use App\Models\TeamMemberModel;
use App\Models\TeamModel;
use App\Models\TournamentModel;
use CodeIgniter\HTTP\Files\UploadedFile;
use RuntimeException;
use SimpleXMLElement;
use ZipArchive;

class ImportController extends BaseController
{
    private const MAX_MEMBERS = 6;
    private const MAX_IMPORT_ROWS = 500;
    private const MAX_XML_BYTES = 4_000_000;

    private TournamentModel $tournamentModel;
    private PotModel $potModel;
    private TeamModel $teamModel;
    private TeamMemberModel $teamMemberModel;

    public function __construct()
    {
        $this->tournamentModel   = new TournamentModel();
        $this->potModel          = new PotModel();
        $this->teamModel         = new TeamModel();
        $this->teamMemberModel   = new TeamMemberModel();
    }

    public function teams()
    {
        $tournamentId = $this->request->getGet('tournament_id');
        $potId = $this->request->getGet('pot_id');
        $query = ['tab' => 'import'];
        if ($tournamentId) {
            $query['tournament_id'] = $tournamentId;
        }
        if ($potId) {
            $query['pot_id'] = $potId;
        }

        return redirect()->to(site_url('teams/roster') . '?' . http_build_query($query));
    }

    public function storeTeams()
    {
        $redirectTo = trim((string) ($this->request->getPost('redirect_to') ?? ''));

        if (! $this->validate([
            'team_file' => [
                'label' => 'File import team',
                'rules' => 'uploaded[team_file]|mime_in[team_file,text/plain,text/csv,application/csv,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/zip]|ext_in[team_file,csv,txt,xlsx]|max_size[team_file,4096]',
            ],
        ])) {
            $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
            return $target
                ->withInput()
                ->with('error', 'File import belum valid.')
                ->with('validation', $this->validator->getErrors());
        }

        $file = $this->request->getFile('team_file');
        $importMode = (string) $this->request->getPost('import_mode');
        if (! in_array($importMode, ['global', 'with_pot'], true)) {
            $importMode = 'global';
        }

        $selectedTournamentId = (int) ($this->request->getPost('tournament_id') ?? 0);
        $selectedPotId = (int) ($this->request->getPost('pot_id') ?? 0);

        if ($selectedTournamentId <= 0) {
            $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
            return $target->withInput()->with('error', 'Pilih tournament terlebih dahulu sebelum import team.');
        }

        if ($importMode === 'with_pot') {
            if ($selectedPotId <= 0) {
                $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
                return $target->withInput()->with('error', 'Mode dengan pot wajib memilih pot tujuan.');
            }

            $pot = $this->potModel->find($selectedPotId);
            if ($pot === null || (int) $pot['tournament_id'] !== $selectedTournamentId) {
                $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
                return $target->withInput()->with('error', 'Pot tujuan import tidak valid.');
            }
        }

        try {
            $rows = $this->parseImportFile($file);
        } catch (RuntimeException $exception) {
            $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
            return $target->withInput()->with('error', $exception->getMessage());
        }

        if ($rows === []) {
            $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
            return $target->withInput()->with('error', 'Tidak ada data team yang bisa diimport.');
        }

        if (count($rows) > self::MAX_IMPORT_ROWS) {
            $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
            return $target->withInput()->with('error', 'Import dibatasi maksimal ' . self::MAX_IMPORT_ROWS . ' baris per file.');
        }

        // PERSIAPAN CEK KAPASITAS POT
        $targetPotId = $importMode === 'with_pot' && $selectedPotId > 0 ? $selectedPotId : null;
        $existingTeamsByScope = [];
        
        $existingTeams = $targetPotId !== null
            ? $this->teamModel
                ->where('pot_id', $targetPotId)
                ->orderBy('sort_order', 'ASC')
                ->orderBy('name', 'ASC')
                ->findAll()
            : $this->teamModel
                ->where('pot_id IS NULL', null, false)
                ->orderBy('sort_order', 'ASC')
                ->orderBy('name', 'ASC')
                ->findAll();

        foreach ($existingTeams as $team) {
            $existingTeamsByScope[$this->normalizeName((string) $team['name'])] = $team;
        }

        // VALIDASI KAPASITAS POT JIKA IMPORT KE DALAM POT (ENFORCE max_teams_per_pot)
        if ($targetPotId !== null && isset($pot)) {
            $tournament = $this->tournamentModel->find($selectedTournamentId);
            $maxTeams = (int) ($pot['max_teams'] ?? 0) > 0
                ? (int) $pot['max_teams']
                : (int) ($tournament['max_teams_per_pot'] ?? 12);
            $existingCount = count($existingTeams);
            
            // Hitung hanya tim unik baru dari file yang belum ada di database pot saat ini
            $newTeamsCount = 0;
            $seenNewTeams = [];
            foreach ($rows as $row) {
                $normalizedName = $this->normalizeName($row['team_name']);
                if ($normalizedName === '') {
                    continue;
                }
                if (! isset($existingTeamsByScope[$normalizedName]) && ! isset($seenNewTeams[$normalizedName])) {
                    $seenNewTeams[$normalizedName] = true;
                    $newTeamsCount++;
                }
            }
            
            $finalCount = $existingCount + $newTeamsCount;
            
            if ($finalCount > $maxTeams) {
                $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
                return $target->withInput()->with('error', "Gagal import: Pot tujuan sudah penuh atau akan melebihi kapasitas. Maksimal {$maxTeams} team. (Saat ini ada {$existingCount} team, Anda mencoba meng-import {$newTeamsCount} team baru).");
            }
        }

        $db = db_connect();
        try {
            $db->transException(true)->transStart();

            foreach ($rows as $row) {
                $teamId = $this->upsertImportedTeam($targetPotId, $selectedTournamentId, $row, $existingTeamsByScope);
                $this->replaceTeamMembers($teamId, $row['players']);
            }

            $db->transComplete();
        } catch (\Throwable $e) {
            if ($db->transStatus() !== false) {
                $db->transRollback();
            }

            $target = $redirectTo !== '' ? redirect()->to($redirectTo) : redirect()->back();
            return $target->withInput()->with('error', 'Import team gagal disimpan ke database: ' . $e->getMessage());
        }

        if ($redirectTo !== '') {
            $targetUrl = $redirectTo;
        } else {
            $query = array_filter([
                'tournament_id' => $selectedTournamentId > 0 ? $selectedTournamentId : null,
                'pot_id'        => $selectedPotId > 0 ? $selectedPotId : null,
            ], static fn ($value) => $value !== null);

            $targetUrl = site_url('teams/roster?tab=roster');
            if ($query !== []) {
                $targetUrl .= '&' . http_build_query($query);
            }
        }

        $modeLabel = $importMode === 'with_pot'
            ? ' ke team pot terpilih'
            : ' ke team sistem tanpa pot';

        return redirect()->to($targetUrl)->with('success', count($rows) . ' team berhasil diimport' . $modeLabel . '.');
    }

    private function parseImportFile(UploadedFile $file): array
    {
        $extension = strtolower($file->getExtension() ?: pathinfo($file->getName(), PATHINFO_EXTENSION));
        $path = $file->getTempName();

        if ($extension === 'xlsx') {
            return $this->parseXlsxFile($path);
        }

        if (in_array($extension, ['csv', 'txt'], true)) {
            return $this->parseDelimitedFile($path);
        }

        throw new RuntimeException('Format file belum didukung. Gunakan CSV, TXT, atau XLSX.');
    }

    private function parseDelimitedFile(string $path): array
    {
        $sample = file_get_contents($path, false, null, 0, 4096) ?: '';
        $delimiter = $this->detectDelimiter($sample);

        $handle = fopen($path, 'rb');
        if ($handle === false) {
            throw new RuntimeException('File import tidak dapat dibaca.');
        }

        $headers = fgetcsv($handle, 0, $delimiter);
        if ($headers === false) {
            fclose($handle);
            throw new RuntimeException('Header file tidak ditemukan.');
        }

        $rows = [];
        while (($columns = fgetcsv($handle, 0, $delimiter)) !== false) {
            if ($columns === [null] || $columns === []) {
                continue;
            }
            $rows[] = $columns;
            if (count($rows) > self::MAX_IMPORT_ROWS) {
                fclose($handle);
                throw new RuntimeException('Import dibatasi maksimal ' . self::MAX_IMPORT_ROWS . ' baris per file.');
            }
        }

        fclose($handle);

        return $this->normalizeImportedRows($headers, $rows);
    }

    private function parseXlsxFile(string $path): array
    {
        $rows = $this->readXlsxRows($path);
        if ($rows === []) {
            throw new RuntimeException('Sheet XLSX tidak berisi data yang bisa dibaca.');
        }

        $headers = array_shift($rows);
        if (! is_array($headers) || $headers === []) {
            throw new RuntimeException('Header XLSX tidak ditemukan.');
        }

        return $this->normalizeImportedRows($headers, $rows);
    }

    private function normalizeImportedRows(array $headers, array $rows): array
    {
        $normalizedHeaders = array_map(fn ($header) => $this->normalizeHeader((string) $header), $headers);

        if (in_array('team_name', $normalizedHeaders, true)) {
            return $this->buildRowsFromStandardHeaders($normalizedHeaders, $rows);
        }

        if (in_array('nama_team', $normalizedHeaders, true) || in_array('nick_captain', $normalizedHeaders, true)) {
            return $this->buildRowsFromFormResponseHeaders($normalizedHeaders, $rows);
        }

        throw new RuntimeException('Format file belum dikenali. Gunakan template header lama atau file XLSX respons form seperti contoh yang Anda lampirkan.');
    }

    private function buildRowsFromStandardHeaders(array $headers, array $rows): array
    {
        $map = [];
        foreach ($headers as $index => $header) {
            if ($header !== '') {
                $map[$header] = $index;
            }
        }

        $result = [];
        foreach ($rows as $row) {
            $teamName = $this->cellValue($row, $map['team_name'] ?? null);
            if ($teamName === '') {
                continue;
            }

            $players = [];
            for ($index = 1; $index <= self::MAX_MEMBERS; $index++) {
                $nameKey = 'player_' . $index . '_name';
                $fallbackKey = 'player_' . $index;
                $roleKey = 'player_' . $index . '_role';

                $playerName = $this->cellValue($row, $map[$nameKey] ?? $map[$fallbackKey] ?? null);
                $playerRole = $this->cellValue($row, $map[$roleKey] ?? null);

                if ($playerName === '') {
                    continue;
                }

                $players[] = [
                    'player_name' => $this->limitText($playerName, 80),
                    'player_role' => $this->limitText($playerRole, 40),
                ];
            }

            $result[] = [
                'team_name'   => $this->limitText($teamName, 80),
                'leader_name' => $this->limitText($this->cellValue($row, $map['leader_name'] ?? null), 80),
                'whatsapp'    => $this->limitText($this->cellValue($row, $map['whatsapp'] ?? null), 40),
                'email'       => $this->limitText($this->cellValue($row, $map['email'] ?? null), 120),
                'notes'       => $this->limitText($this->cellValue($row, $map['notes'] ?? null), 255),
                'players'     => $players,
            ];
        }

        return $result;
    }

    private function buildRowsFromFormResponseHeaders(array $headers, array $rows): array
    {
        $teamIndex = $this->firstHeaderIndex($headers, ['nama_team']);
        $leaderIndex = $this->firstHeaderIndex($headers, ['nick_captain']);
        $phoneIndex = $this->firstHeaderIndex($headers, ['no_perwakilan', 'no_wa', 'whatsapp']);
        $emailIndex = $this->firstHeaderIndex($headers, ['email']);
        $notesIndex = $this->firstHeaderIndex($headers, ['bukti_pembayaran']);

        $playerIndexes = [];
        foreach ($headers as $index => $header) {
            if ($header === '') {
                continue;
            }

            if (str_contains($header, 'nick_player') || $header === 'nick_captain') {
                $playerIndexes[] = $index;
            }
        }

        $result = [];
        foreach ($rows as $row) {
            $teamName = $this->cellValue($row, $teamIndex);
            if ($teamName === '') {
                continue;
            }

            $players = [];
            $seen = [];
            foreach ($playerIndexes as $index) {
                $name = $this->cellValue($row, $index);
                if ($name === '' || $name === '-') {
                    continue;
                }

                $normalized = $this->normalizeName($name);
                if ($normalized === '' || isset($seen[$normalized])) {
                    continue;
                }

                $seen[$normalized] = true;
                $players[] = [
                    'player_name' => $this->limitText($name, 80),
                    'player_role' => '',
                ];

                if (count($players) >= self::MAX_MEMBERS) {
                    break;
                }
            }

            $result[] = [
                'team_name'   => $this->limitText($teamName, 80),
                'leader_name' => $this->limitText($this->cellValue($row, $leaderIndex), 80),
                'whatsapp'    => $this->limitText($this->cellValue($row, $phoneIndex), 40),
                'email'       => $this->limitText($this->cellValue($row, $emailIndex), 120),
                'notes'       => $this->limitText($this->cellValue($row, $notesIndex), 255),
                'players'     => $players,
            ];
        }

        return $result;
    }

    private function limitText(string $value, int $maxLength = 120): string
    {
        $value = $this->cleanImportText($value, true);
        if ($value === '') {
            return '';
        }

        if (function_exists('mb_substr')) {
            return mb_substr($value, 0, $maxLength);
        }

        return substr($value, 0, $maxLength);
    }
    
    private function cleanImportText(string $value, bool $allowLineBreaks = false): string
    {
        if ($value === '') {
            return '';
        }

        if (! mb_check_encoding($value, 'UTF-8')) {
            $converted = @iconv('UTF-8', 'UTF-8//IGNORE', $value);
            if ($converted !== false) {
                $value = $converted;
            }
        }

        $value = str_replace("\0", '', $value);

        if ($allowLineBreaks) {
            $value = preg_replace('/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/u', '', $value) ?? $value;
            $value = preg_replace('/\r\n?/', "\n", $value) ?? $value;
        } else {
            $value = preg_replace('/[\x00-\x1F\x7F]/u', '', $value) ?? $value;
        }

        $value = preg_replace('/\s+/u', ' ', $value) ?? $value;

        return trim($value);
    }

    private function detectDelimiter(string $sample): string
    {
        $candidates = [',', ';', "\t"];
        $best = ',';
        $bestCount = 0;

        foreach ($candidates as $candidate) {
            $count = substr_count($sample, $candidate);
            if ($count > $bestCount) {
                $best = $candidate;
                $bestCount = $count;
            }
        }

        return $best;
    }

    private function readXlsxRows(string $path): array
    {
        $zip = new ZipArchive();
        if ($zip->open($path) !== true) {
            throw new RuntimeException('File XLSX tidak bisa dibuka.');
        }

        $sharedStrings = [];
        $sharedStringXml = $zip->getFromName('xl/sharedStrings.xml');
        if ($sharedStringXml !== false && strlen($sharedStringXml) > self::MAX_XML_BYTES) {
            $zip->close();
            throw new RuntimeException('File XLSX terlalu besar untuk diproses.');
        }
        if ($sharedStringXml !== false) {
            $sharedStrings = $this->readSharedStrings($sharedStringXml);
        }

        $sheetXml = $zip->getFromName('xl/worksheets/sheet1.xml');
        if ($sheetXml === false) {
            $zip->close();
            throw new RuntimeException('Sheet pertama XLSX tidak ditemukan.');
        }
        if (strlen($sheetXml) > self::MAX_XML_BYTES) {
            $zip->close();
            throw new RuntimeException('Sheet XLSX terlalu besar untuk diproses.');
        }

        $rows = $this->readSheetRows($sheetXml, $sharedStrings);
        $zip->close();

        return $rows;
    }

    private function readSharedStrings(string $xml): array
    {
        $document = simplexml_load_string($xml, SimpleXMLElement::class, LIBXML_NONET | LIBXML_NOERROR | LIBXML_NOWARNING);
        if (! $document instanceof SimpleXMLElement) {
            return [];
        }

        $document->registerXPathNamespace('a', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
        $items = $document->xpath('//a:si') ?: [];

        $strings = [];
        foreach ($items as $item) {
            $parts = $item->xpath('.//a:t') ?: [];
            $value = '';
            foreach ($parts as $part) {
                $value .= (string) $part;
            }
            $strings[] = $value;
        }

        return $strings;
    }

    private function readSheetRows(string $xml, array $sharedStrings): array
    {
        $document = simplexml_load_string($xml, SimpleXMLElement::class, LIBXML_NONET | LIBXML_NOERROR | LIBXML_NOWARNING);
        if (! $document instanceof SimpleXMLElement) {
            return [];
        }

        $document->registerXPathNamespace('a', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
        $rowNodes = $document->xpath('//a:sheetData/a:row') ?: [];

        $rows = [];
        foreach ($rowNodes as $rowNode) {
            $cells = [];
            $cellNodes = $rowNode->xpath('./a:c') ?: [];

            foreach ($cellNodes as $cellNode) {
                $ref = (string) ($cellNode['r'] ?? '');
                $type = (string) ($cellNode['t'] ?? '');
                $index = $this->columnIndexFromReference($ref);
                if ($index < 0) {
                    continue;
                }

                $value = '';
                if ($type === 's') {
                    $sharedIndex = (int) ($cellNode->v ?? 0);
                    $value = (string) ($sharedStrings[$sharedIndex] ?? '');
                } elseif ($type === 'inlineStr') {
                    $parts = $cellNode->xpath('./a:is/a:t') ?: [];
                    foreach ($parts as $part) {
                        $value .= (string) $part;
                    }
                } else {
                    $value = (string) ($cellNode->v ?? '');
                }

                $cells[$index] = trim($value);
            }

            if ($cells === []) {
                continue;
            }

            ksort($cells);
            $maxIndex = max(array_keys($cells));
            $row = [];
            for ($index = 0; $index <= $maxIndex; $index++) {
                $row[] = $cells[$index] ?? '';
            }

            if (implode('', $row) === '') {
                continue;
            }

            $rows[] = $row;
            if (count($rows) > self::MAX_IMPORT_ROWS + 1) {
                throw new RuntimeException('Import dibatasi maksimal ' . self::MAX_IMPORT_ROWS . ' baris per file.');
            }
        }

        return $rows;
    }

    private function columnIndexFromReference(string $reference): int
    {
        if ($reference === '') {
            return -1;
        }

        if (! preg_match('/^([A-Z]+)/i', $reference, $matches)) {
            return -1;
        }

        $letters = strtoupper($matches[1]);
        $index = 0;
        $length = strlen($letters);

        for ($i = 0; $i < $length; $i++) {
            $index = ($index * 26) + (ord($letters[$i]) - 64);
        }

        return $index - 1;
    }

    private function firstHeaderIndex(array $headers, array $needles): ?int
    {
        foreach ($headers as $index => $header) {
            foreach ($needles as $needle) {
                if ($header === $needle || str_contains($header, $needle)) {
                    return $index;
                }
            }
        }

        return null;
    }

    private function cellValue(array $row, ?int $index): string
    {
        if ($index === null) {
            return '';
        }

        $value = (string) ($row[$index] ?? '');
        $value = $this->cleanImportText($value, true);
        return $value === 'NULL' ? '' : $value;
    }

    private function normalizeHeader(string $header): string
    {
        $header = strtolower(trim(str_replace(["\r", "\n", "\t"], ' ', $header)));
        $header = preg_replace('/[^a-z0-9]+/', '_', $header) ?? '';
        return trim($header, '_');
    }

    private function upsertImportedTeam(?int $potId, int $tournamentId, array $row, array &$existingTeamsByScope): int
    {
        $normalizedName = $this->normalizeName($row['team_name']);
        $team = $existingTeamsByScope[$normalizedName] ?? null;

        if ($team !== null) {
            $teamId = (int) $team['id'];
            $this->teamModel->update($teamId, [
                'tournament_id' => $tournamentId > 0 ? $tournamentId : null,
                'pot_id' => $potId,
                'name'   => $row['team_name'],
            ]);
            return $teamId;
        }

        $nextSortOrder = $potId !== null
            ? $this->teamModel->where('pot_id', $potId)->countAllResults() + 1
            : $this->teamModel->where('pot_id IS NULL', null, false)->countAllResults() + 1;

        $teamId = (int) $this->teamModel->insert([
            'tournament_id' => $tournamentId > 0 ? $tournamentId : null,
            'pot_id'     => $potId,
            'name'       => $row['team_name'],
            'sort_order' => $nextSortOrder,
        ], true);

        $existingTeamsByScope[$normalizedName] = [
            'id'        => $teamId,
            'tournament_id' => $tournamentId > 0 ? $tournamentId : null,
            'pot_id'    => $potId,
            'name'      => $row['team_name'],
            'sort_order'=> $nextSortOrder,
        ];

        return $teamId;
    }

    private function replaceTeamMembers(int $teamId, array $players): void
    {
        $this->teamMemberModel->where('team_id', $teamId)->delete();

        $seen = [];
        foreach (array_slice($players, 0, self::MAX_MEMBERS) as $player) {
            $playerName = trim((string) ($player['player_name'] ?? ''));
            if ($playerName === '') {
                continue;
            }

            $normalized = $this->normalizeName($playerName);
            if ($normalized === '' || isset($seen[$normalized])) {
                continue;
            }

            $seen[$normalized] = true;
            $this->teamMemberModel->insert([
                'team_id'     => $teamId,
                'player_name' => $this->limitText($playerName, 80),
                'player_role' => ! empty($player['player_role']) ? (string) $player['player_role'] : null,
            ]);
        }
    }

    private function normalizeName(string $value): string
    {
        $value = strtolower(trim($value));
        return preg_replace('/[^a-z0-9]+/', '', $value) ?? '';
    }
}