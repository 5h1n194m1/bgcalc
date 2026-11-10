<?php

namespace App\Controllers;

use App\Models\PotModel;
use App\Models\ScoreModel;
use App\Models\TeamMemberModel;
use App\Models\TeamModel;
use App\Models\TournamentModel;
use CodeIgniter\Exceptions\PageNotFoundException;

class TeamController extends BaseController
{
    private const MAX_MEMBERS = 6;

    private PotModel $potModel;
    private TeamModel $teamModel;
    private TeamMemberModel $teamMemberModel;
    private TournamentModel $tournamentModel;
    private ScoreModel $scoreModel;
    private bool $hasSandboxCol = false;

    public function __construct()
    {
        $this->potModel = new PotModel();
        $this->teamModel = new TeamModel();
        $this->teamMemberModel = new TeamMemberModel();
        $this->tournamentModel = new TournamentModel();
        $this->scoreModel = new ScoreModel();

        try {
            $this->hasSandboxCol = db_connect()->fieldExists('is_sandbox', 'teams');
        } catch (\Throwable $e) {
            $this->hasSandboxCol = false;
        }
    }

    public function index(int $potId)
    {
        return redirect()->to(site_url('pots/' . $potId . '/scores'));
    }

    /**
     * GET /teams/roster
     * Halaman utama Team Management Hub (Pro Spreadsheet + Smart Import Tab)
     */
    public function rosterIndex()
    {
        $this->cleanupRosterData();
        $tournaments = $this->tournamentModel->orderBy('created_at', 'DESC')->findAll();
        $rawTournamentId = $this->request->getGet('tournament_id');

        $perPage = (int) ($this->request->getGet('per_page') ?? 48);
        if (!in_array($perPage, [24, 48, 72, 96, 200], true)) {
            $perPage = 48;
        }

        if ($rawTournamentId === null) {
            $selectedTournamentKey = $tournaments !== [] ? (string) $tournaments[0]['id'] : 'all';
        } else {
            $selectedTournamentKey = trim((string) $rawTournamentId);
            if ($selectedTournamentKey === '') {
                $selectedTournamentKey = 'all';
            }
        }

        $selectedTournamentId = ctype_digit($selectedTournamentKey) ? (int) $selectedTournamentKey : 0;
        $showOnlyWithoutTournament = $selectedTournamentKey === 'none';
        $showOnlyWithoutPot = $selectedTournamentKey === 'unassigned';
        $showOnlySandbox = $selectedTournamentKey === 'sandbox';

        $selectCols = 'teams.id, teams.tournament_id, teams.name, teams.sort_order, teams.pot_id, '
            . ($this->hasSandboxCol ? 'teams.is_sandbox, ' : '0 AS is_sandbox, ')
            . 'pots.name AS pot_name, pots.stage AS pot_stage, '
            . 'COALESCE(pot_tournaments.name, team_tournaments.name) AS tournament_name, '
            . 'COALESCE(pot_tournaments.status, team_tournaments.status) AS tournament_status';

        $teamsBuilder = $this->teamModel
            ->select($selectCols)
            ->join('pots', 'pots.id = teams.pot_id', 'left')
            ->join('tournaments AS pot_tournaments', 'pot_tournaments.id = pots.tournament_id', 'left')
            ->join('tournaments AS team_tournaments', 'team_tournaments.id = teams.tournament_id', 'left');

        if ($selectedTournamentId > 0) {
            $teamsBuilder->groupStart()
                ->where('pots.tournament_id', $selectedTournamentId)
                ->orGroupStart()
                ->where('teams.pot_id IS NULL', null, false)
                ->where('teams.tournament_id', $selectedTournamentId)
                ->groupEnd()
                ->groupEnd();
        } elseif ($showOnlySandbox && $this->hasSandboxCol) {
            $teamsBuilder->where('teams.is_sandbox', 1);
        } elseif ($showOnlyWithoutPot) {
            $teamsBuilder->where('teams.pot_id IS NULL', null, false);
            if ($this->hasSandboxCol) {
                $teamsBuilder->where('teams.is_sandbox', 0);
            }
        } elseif ($showOnlyWithoutTournament) {
            $teamsBuilder->where('teams.pot_id IS NULL', null, false)
                ->groupStart()
                ->where('teams.tournament_id IS NULL', null, false)
                ->orWhere('teams.tournament_id', 0)
                ->groupEnd();
        }

        if ($this->hasSandboxCol) {
            $teamsBuilder->orderBy('teams.is_sandbox', 'ASC');
        }

        $teams = $teamsBuilder
            ->orderBy('COALESCE(pot_tournaments.name, team_tournaments.name)', 'ASC', false)
            ->orderBy('pots.stage', 'ASC')
            ->orderBy('pots.sort_order', 'ASC')
            ->orderBy('teams.sort_order', 'ASC')
            ->orderBy('teams.name', 'ASC')
            ->paginate($perPage);

        $pager = $this->teamModel->pager;

        $potOptionsBuilder = $this->potModel
            ->select('pots.id, pots.name, pots.stage, pots.sort_order, tournaments.id AS tournament_id, tournaments.name AS tournament_name, tournaments.status AS tournament_status')
            ->join('tournaments', 'tournaments.id = pots.tournament_id');

        if ($selectedTournamentId > 0) {
            $potOptionsBuilder->where('pots.tournament_id', $selectedTournamentId);
        }

        $potOptions = $potOptionsBuilder
            ->orderBy('tournaments.name', 'ASC')
            ->orderBy('pots.stage', 'ASC')
            ->orderBy('pots.sort_order', 'ASC')
            ->orderBy('pots.name', 'ASC')
            ->findAll();

        $teamIds = array_map(static fn(array $team): int => (int) $team['id'], $teams);
        $membersByTeam = $this->memberNamesByTeam($teamIds);

        $stageLabels = [
            'kualifikasi' => 'Kualifikasi',
            'semifinal' => 'Semifinal',
            'grandfinal' => 'Grand Final',
        ];

        $rows = array_map(function (array $team) use ($membersByTeam, $stageLabels): array {
            $teamId = (int) $team['id'];
            $isSandbox = (int) ($team['is_sandbox'] ?? 0) === 1;
            $members = array_values(array_filter($membersByTeam[$teamId] ?? [], static fn(string $name): bool => $name !== ''));

            $rawPotName = trim((string) ($team['pot_name'] ?? ''));
            $stageKey = $isSandbox ? 'sandbox' : strtolower(trim((string) ($team['pot_stage'] ?? '')));
            $stageTitle = $isSandbox ? 'Sandbox' : ($stageLabels[$stageKey] ?? ($stageKey !== '' ? ucfirst($stageKey) : ''));

            $displayPotName = $isSandbox
                ? '[Sandbox / Recycle Bin]'
                : (($rawPotName !== '' && $stageTitle !== '') ? '[' . $stageTitle . '] - ' . $rawPotName : $rawPotName);

            return [
                'id' => $teamId,
                'pot_id' => $team['pot_id'] !== null ? (int) $team['pot_id'] : null,
                'is_sandbox' => $isSandbox ? 1 : 0,
                'tournament_id' => $team['tournament_id'] !== null ? (int) $team['tournament_id'] : null,
                'name' => (string) ($team['name'] ?? '-'),
                'members' => $members,
                'member_text' => $members !== [] ? implode(', ', $members) : '-',
                'pot_name' => $displayPotName,
                'raw_pot_name' => $rawPotName,
                'pot_stage' => $stageKey,
                'stage_label' => $stageTitle,
                'tournament_name' => trim((string) ($team['tournament_name'] ?? '')),
                'scope_label' => $isSandbox
                    ? 'Sandbox / Recycle Bin'
                    : ($team['pot_id'] === null
                        ? 'Tanpa Pot'
                        : trim($displayPotName . (trim((string) ($team['tournament_name'] ?? '')) !== '' ? ' / ' . trim((string) ($team['tournament_name'] ?? '')) : ''))),
                'is_locked' => (string) ($team['tournament_status'] ?? '') === TournamentModel::STATUS_SELESAI,
            ];
        }, $teams);

        $potOptionsPayload = array_map(static function (array $pot) use ($stageLabels): array {
            $stageKey = strtolower(trim((string) ($pot['stage'] ?? 'kualifikasi')));
            $stageTitle = $stageLabels[$stageKey] ?? ucfirst($stageKey !== '' ? $stageKey : 'Kualifikasi');
            $potName = (string) ($pot['name'] ?? 'Pot');
            $label = '[' . $stageTitle . '] - ' . $potName;

            return [
                'id' => (int) $pot['id'],
                'tournament_id' => (int) ($pot['tournament_id'] ?? 0),
                'name' => $potName,
                'raw_name' => $potName,
                'stage' => $stageKey,
                'stage_label' => $stageTitle,
                'sort_order' => (int) ($pot['sort_order'] ?? 0),
                'tournament_name' => (string) ($pot['tournament_name'] ?? 'Tournament'),
                'status' => (string) ($pot['tournament_status'] ?? TournamentModel::STATUS_BELUM_MULAI),
                'label' => $label,
            ];
        }, $potOptions);

        $potsForImport = $selectedTournamentId > 0
            ? $this->potModel
                ->where('tournament_id', $selectedTournamentId)
                ->orderBy('stage', 'ASC')
                ->orderBy('sort_order', 'ASC')
                ->orderBy('name', 'ASC')
                ->findAll()
            : $this->potModel
                ->orderBy('tournament_id', 'DESC')
                ->orderBy('stage', 'ASC')
                ->orderBy('sort_order', 'ASC')
                ->findAll();

        $selectedPotId = (int) ($this->request->getGet('pot_id') ?? 0);
        $activeTab = trim((string) ($this->request->getGet('tab') ?? 'roster'));
        if (!in_array($activeTab, ['roster', 'import'], true)) {
            $activeTab = 'roster';
        }

        return view('teams/roster', [
            'pageTitle' => 'Team Management Hub',
            'rows' => $rows,
            'pager' => $pager,
            'perPage' => $perPage,
            'tournaments' => $tournaments,
            'selectedTournamentKey' => $selectedTournamentKey,
            'selectedTournamentId' => $selectedTournamentId,
            'potOptions' => $potOptionsPayload,
            'pots' => $potsForImport,
            'selectedPotId' => $selectedPotId,
            'activeTab' => $activeTab,
        ]);
    }

    public function exportTemplate()
    {
        $tournamentId = (int) ($this->request->getGet('tournament_id') ?? 0);
        if ($tournamentId <= 0) {
            return redirect()->to(site_url('teams/roster'))->with('error', 'Pilih tournament terlebih dahulu sebelum export.');
        }

        $tournament = $this->tournamentModel->find($tournamentId);
        if ($tournament === null) {
            return redirect()->to(site_url('teams/roster'))->with('error', 'Tournament tidak ditemukan.');
        }

        $payload = $this->buildTournamentTemplateExport($tournamentId);

        return view('teams/export_template', [
            'pageTitle' => 'Export Template CSV',
            'tournament' => $tournament,
            'exports' => $payload['exports'],
            'unassignedTeams' => $payload['unassignedTeams'],
        ]);
    }

    public function downloadTemplateCsv(int $potId)
    {
        $pot = $this->potWithTournament($potId);
        if ($pot === null) {
            throw PageNotFoundException::forPageNotFound('Pot tidak ditemukan.');
        }

        $payload = $this->buildPotTemplateExport($potId);
        $filename = url_title((string) ($pot['tournament_name'] ?? 'tournament'), '-', true)
            . '-' . url_title((string) ($pot['name'] ?? 'pot'), '-', true) . '.csv';

        return $this->response
            ->setHeader('Content-Type', 'text/csv; charset=UTF-8')
            ->setHeader('Content-Disposition', 'attachment; filename="' . $filename . '"')
            ->setBody("\xEF\xBB\xBF" . $payload['csvText']);
    }

    public function managerData()
    {
        $tournaments = $this->tournamentModel->orderBy('created_at', 'DESC')->findAll();

        $selectedTournamentId = (int) ($this->request->getGet('tournament_id') ?? 0);
        if ($selectedTournamentId <= 0 && $tournaments !== []) {
            $selectedTournamentId = (int) $tournaments[0]['id'];
        }

        $pots = $selectedTournamentId > 0
            ? $this->potModel->where('tournament_id', $selectedTournamentId)->orderBy('stage', 'ASC')->orderBy('sort_order', 'ASC')->orderBy('name', 'ASC')->findAll()
            : [];

        $potScope = trim((string) ($this->request->getGet('pot_scope') ?? ''));
        $rawPotId = $this->request->getGet('pot_id');
        $selectedPotId = (int) ($rawPotId ?? 0);

        if ($potScope !== 'unassigned' && ($rawPotId === null || $rawPotId === '') && $pots !== []) {
            $selectedPotId = (int) $pots[0]['id'];
        }

        if ($potScope === 'unassigned') {
            $teams = $this->lookupTeamsForManager($selectedTournamentId);
            $selectedPotId = 0;
        } else {
            $teams = $selectedPotId > 0
                ? $this->teamModel->where('pot_id', $selectedPotId)->orderBy('sort_order', 'ASC')->orderBy('name', 'ASC')->findAll()
                : [];
        }

        $teamIds = array_map(static fn(array $team): int => (int) $team['id'], $teams);
        $membersByTeam = [];
        $scoreStatsByTeam = [];

        if ($teamIds !== []) {
            $members = $this->teamMemberModel
                ->whereIn('team_id', $teamIds)
                ->orderBy('id', 'ASC')
                ->findAll();

            foreach ($members as $member) {
                $membersByTeam[(int) $member['team_id']][] = trim((string) ($member['player_name'] ?? ''));
            }

            $scoreRows = $this->scoreModel
                ->select('team_id, COUNT(DISTINCT game_no) AS games_played, COALESCE(SUM(total_point), 0) AS total_score, COALESCE(SUM(kill_point), 0) AS total_kill')
                ->whereIn('team_id', $teamIds)
                ->groupBy('team_id')
                ->findAll();

            foreach ($scoreRows as $scoreRow) {
                $scoreStatsByTeam[(int) $scoreRow['team_id']] = [
                    'games_played' => (int) ($scoreRow['games_played'] ?? 0),
                    'total_score' => (int) ($scoreRow['total_score'] ?? 0),
                    'total_kill' => (int) ($scoreRow['total_kill'] ?? 0),
                ];
            }
        }

        $teamPayload = [];
        foreach ($teams as $team) {
            $teamId = (int) $team['id'];
            $members = array_values(array_filter($membersByTeam[$teamId] ?? [], static fn(string $name): bool => $name !== ''));
            $scoreStats = $scoreStatsByTeam[$teamId] ?? [
                'games_played' => 0,
                'total_score' => 0,
                'total_kill' => 0,
            ];

            $teamPayload[] = [
                'id' => $teamId,
                'pot_id' => $team['pot_id'] !== null ? (int) $team['pot_id'] : null,
                'name' => (string) $team['name'],
                'sort_order' => (int) ($team['sort_order'] ?? 0),
                'member_count' => count($members),
                'member_text' => implode(', ', $members),
                'members' => $members,
                'games_played' => (int) $scoreStats['games_played'],
                'total_score' => (int) $scoreStats['total_score'],
                'total_kill' => (int) $scoreStats['total_kill'],
                'pot_name' => trim((string) ($team['pot_name'] ?? '')),
                'tournament_name' => trim((string) ($team['tournament_name'] ?? '')),
                'scope_label' => $team['pot_id'] === null
                    ? 'Tanpa Pot'
                    : trim((string) ($team['pot_name'] ?? '') . (trim((string) ($team['tournament_name'] ?? '')) !== '' ? ' / ' . trim((string) ($team['tournament_name'] ?? '')) : '')),
            ];
        }

        $lookupRows = $this->lookupTeamsForManager($selectedTournamentId);
        $lookupIds = array_map(static fn(array $team): int => (int) $team['id'], $lookupRows);
        $lookupMembersByTeam = $this->memberNamesByTeam($lookupIds);
        $lookupPayload = [];

        foreach ($lookupRows as $team) {
            $teamId = (int) $team['id'];
            $members = array_values(array_filter($lookupMembersByTeam[$teamId] ?? [], static fn(string $name): bool => $name !== ''));
            $potName = trim((string) ($team['pot_name'] ?? ''));
            $tournamentName = trim((string) ($team['tournament_name'] ?? ''));
            $scopeLabel = $team['pot_id'] === null
                ? 'Tanpa Pot'
                : trim($potName . ($tournamentName !== '' ? ' / ' . $tournamentName : ''));

            $lookupPayload[] = [
                'id' => $teamId,
                'pot_id' => $team['pot_id'] !== null ? (int) $team['pot_id'] : null,
                'tournament_id' => $team['tournament_id'] !== null ? (int) $team['tournament_id'] : null,
                'name' => (string) $team['name'],
                'sort_order' => (int) ($team['sort_order'] ?? 0),
                'pot_name' => $potName,
                'tournament_name' => $tournamentName,
                'scope_label' => $scopeLabel !== '' ? $scopeLabel : 'Tanpa Pot',
                'members' => $members,
                'member_count' => count($members),
                'member_text' => implode(', ', $members),
                'search_text' => strtolower(trim(implode(' ', array_filter([
                    (string) $team['name'],
                    implode(', ', $members),
                    $potName,
                    $tournamentName,
                ])))),
            ];
        }

        $stageLabels = [
            'kualifikasi' => 'Kualifikasi',
            'semifinal' => 'Semifinal',
            'grandfinal' => 'Grand Final',
        ];

        return $this->response->setJSON([
            'status' => 'success',
            'tournaments' => array_map(static fn(array $t): array => [
                'id' => (int) $t['id'],
                'name' => (string) $t['name'],
                'status' => (string) ($t['status'] ?? TournamentModel::STATUS_BELUM_MULAI),
            ], $tournaments),
            'pots' => array_map(static function (array $pot) use ($stageLabels): array {
                $stageKey = strtolower(trim((string) ($pot['stage'] ?? 'kualifikasi')));
                $stageTitle = $stageLabels[$stageKey] ?? ucfirst($stageKey !== '' ? $stageKey : 'Kualifikasi');
                $potName = (string) ($pot['name'] ?? 'Pot');
                $displayName = '[' . $stageTitle . '] - ' . $potName;

                return [
                    'id' => (int) $pot['id'],
                    'tournament_id' => (int) $pot['tournament_id'],
                    'name' => $displayName,
                    'raw_name' => $potName,
                    'stage' => $stageKey,
                    'stage_label' => $stageTitle,
                    'sort_order' => (int) ($pot['sort_order'] ?? 0),
                    'max_teams' => (int) ($pot['max_teams'] ?? 12),
                ];
            }, $pots),
            'teams' => $teamPayload,
            'lookupTeams' => $lookupPayload,
            'selectedTournamentId' => $selectedTournamentId,
            'selectedPotId' => $selectedPotId,
            'csrfTokenName' => csrf_token(),
            'csrfHash' => csrf_hash(),
        ]);
    }

    /**
     * SMART POT ALLOCATOR & AUTO-OVERFLOW ENGINE
     */
    private function resolveTargetPotWithAutoOverflow(
        int $tournamentId,
        string $stage,
        ?int $requestedPotId,
        string $rawPotName,
        ?int $excludeTeamId = null,
        bool $autoAssignIfEmpty = true
    ): array {
        if ($tournamentId <= 0) {
            $latestTournament = $this->tournamentModel->orderBy('created_at', 'DESC')->first();
            $tournamentId = $latestTournament !== null ? (int) $latestTournament['id'] : 0;
        }

        if ($tournamentId <= 0) {
            return ['ok' => false, 'message' => 'Pilih atau buat Tournament terlebih dahulu.'];
        }

        $tournament = $this->tournamentModel->find($tournamentId);
        if ($tournament === null) {
            return ['ok' => false, 'message' => 'Tournament tujuan tidak ditemukan.'];
        }

        if (($tournament['status'] ?? '') === TournamentModel::STATUS_SELESAI) {
            return ['ok' => false, 'message' => 'Tournament sudah selesai (finished). Data tim dikunci.'];
        }

        $cleanName = trim($rawPotName);
        if (preg_match('/^\[[^\]]+\]\s*-\s*(.+)$/u', $cleanName, $matches)) {
            $cleanName = trim($matches[1]);
        }

        $lowerName = strtolower($cleanName);

        // Jika stage atau nama pot adalah Sandbox / Recycle Bin
        if ($stage === 'sandbox' || in_array($lowerName, ['sandbox', 'recycle bin', 'trash', 'cadangan', 'parkir'], true)) {
            return [
                'ok' => true,
                'pot_id' => null,
                'is_sandbox' => 1,
                'pot' => null,
                'tournament_id' => $tournamentId,
                'overflow_note' => 'Dipindahkan ke Sandbox / Recycle Bin.',
            ];
        }

        // Jika eksplisit Unassigned / Tanpa Pot
        if (in_array($lowerName, ['unassigned', 'none', 'tanpa pot', '-', '0', 'kosong'], true)) {
            return [
                'ok' => true,
                'pot_id' => null,
                'is_sandbox' => 0,
                'pot' => null,
                'tournament_id' => $tournamentId,
                'overflow_note' => '',
            ];
        }

        if ($requestedPotId === null && $cleanName === '' && !$autoAssignIfEmpty) {
            return [
                'ok' => true,
                'pot_id' => null,
                'is_sandbox' => 0,
                'pot' => null,
                'tournament_id' => $tournamentId,
                'overflow_note' => '',
            ];
        }

        $defaultMaxTeams = max(1, (int) ($tournament['max_teams_per_pot'] ?? 12));
        $defaultGameCount = max(1, (int) ($tournament['default_game_count'] ?? 5));

        $candidatePot = null;
        if ($requestedPotId !== null && $requestedPotId > 0) {
            $found = $this->potModel->find($requestedPotId);
            if ($found !== null && (int) $found['tournament_id'] === $tournamentId) {
                $candidatePot = $found;
                $stage = strtolower(trim((string) ($found['stage'] ?? $stage)));
            }
        } elseif ($cleanName !== '') {
            $candidatePot = $this->potModel
                ->where('tournament_id', $tournamentId)
                ->where('stage', $stage)
                ->where('LOWER(TRIM(name))', strtolower($cleanName))
                ->first();

            if ($candidatePot === null) {
                $candidatePot = $this->potModel
                    ->where('tournament_id', $tournamentId)
                    ->where('LOWER(TRIM(name))', strtolower($cleanName))
                    ->first();
                if ($candidatePot !== null) {
                    $stage = strtolower(trim((string) ($candidatePot['stage'] ?? $stage)));
                }
            }

            if ($candidatePot === null) {
                $lastPot = $this->potModel
                    ->where('tournament_id', $tournamentId)
                    ->where('stage', $stage)
                    ->orderBy('sort_order', 'DESC')
                    ->first();
                $nextOrder = ((int) ($lastPot['sort_order'] ?? 0)) + 1;

                $newPotId = (int) $this->potModel->insert([
                    'tournament_id' => $tournamentId,
                    'name' => $cleanName,
                    'stage' => $stage,
                    'sort_order' => max(1, $nextOrder),
                    'game_count' => $defaultGameCount,
                    'max_teams' => $defaultMaxTeams,
                    'reference_image_1' => null,
                    'reference_image_2' => null,
                ], true);

                $createdPot = $this->potModel->find($newPotId);
                return [
                    'ok' => true,
                    'pot_id' => $newPotId,
                    'is_sandbox' => 0,
                    'pot' => $createdPot,
                    'tournament_id' => $tournamentId,
                    'overflow_note' => "Pot baru '{$cleanName}' otomatis dibuat.",
                ];
            }
        }

        $stagePots = $this->potModel
            ->where('tournament_id', $tournamentId)
            ->where('stage', $stage)
            ->orderBy('sort_order', 'ASC')
            ->orderBy('id', 'ASC')
            ->findAll();

        if ($stagePots === []) {
            $firstPotName = $cleanName !== '' ? $cleanName : 'POT 1';
            $newPotId = (int) $this->potModel->insert([
                'tournament_id' => $tournamentId,
                'name' => $firstPotName,
                'stage' => $stage,
                'sort_order' => 1,
                'game_count' => $defaultGameCount,
                'max_teams' => $defaultMaxTeams,
                'reference_image_1' => null,
                'reference_image_2' => null,
            ], true);

            $createdPot = $this->potModel->find($newPotId);
            return [
                'ok' => true,
                'pot_id' => $newPotId,
                'is_sandbox' => 0,
                'pot' => $createdPot,
                'tournament_id' => $tournamentId,
                'overflow_note' => "Otomatis membuat dan memasukkan ke {$firstPotName}.",
            ];
        }

        $hasCapacity = function (array $potRow) use ($defaultMaxTeams, $excludeTeamId): bool {
            $max = (int) ($potRow['max_teams'] ?? 0) > 0 ? (int) $potRow['max_teams'] : $defaultMaxTeams;
            $builder = $this->teamModel->where('pot_id', (int) $potRow['id']);
            if ($this->hasSandboxCol) {
                $builder->where('is_sandbox', 0);
            }
            if ($excludeTeamId !== null && $excludeTeamId > 0) {
                $builder->where('id !=', $excludeTeamId);
            }
            return $builder->countAllResults() < $max;
        };

        $startIndex = 0;
        if ($candidatePot !== null) {
            if ($hasCapacity($candidatePot)) {
                return [
                    'ok' => true,
                    'pot_id' => (int) $candidatePot['id'],
                    'is_sandbox' => 0,
                    'pot' => $candidatePot,
                    'tournament_id' => $tournamentId,
                    'overflow_note' => '',
                ];
            }

            foreach ($stagePots as $idx => $sp) {
                if ((int) $sp['id'] === (int) $candidatePot['id']) {
                    $startIndex = $idx + 1;
                    break;
                }
            }
        }

        for ($i = $startIndex, $total = count($stagePots); $i < $total; $i++) {
            if ($hasCapacity($stagePots[$i])) {
                $chosenPot = $stagePots[$i];
                $note = $candidatePot !== null
                    ? "Pot '{$candidatePot['name']}' penuh, dialihkan ke '{$chosenPot['name']}'."
                    : "Otomatis ditempatkan ke '{$chosenPot['name']}'.";

                return [
                    'ok' => true,
                    'pot_id' => (int) $chosenPot['id'],
                    'is_sandbox' => 0,
                    'pot' => $chosenPot,
                    'tournament_id' => $tournamentId,
                    'overflow_note' => $note,
                ];
            }
        }

        for ($i = 0; $i < $startIndex; $i++) {
            if ($hasCapacity($stagePots[$i])) {
                $chosenPot = $stagePots[$i];
                return [
                    'ok' => true,
                    'pot_id' => (int) $chosenPot['id'],
                    'is_sandbox' => 0,
                    'pot' => $chosenPot,
                    'tournament_id' => $tournamentId,
                    'overflow_note' => "Pot '{$candidatePot['name']}' penuh, dialihkan ke '{$chosenPot['name']}'.",
                ];
            }
        }

        $nextNumber = count($stagePots) + 1;
        $autoPotName = 'POT ' . $nextNumber;
        while (
            $this->potModel
                ->where('tournament_id', $tournamentId)
                ->where('stage', $stage)
                ->where('LOWER(TRIM(name))', strtolower($autoPotName))
                ->first() !== null
        ) {
            $nextNumber++;
            $autoPotName = 'POT ' . $nextNumber;
        }

        $lastPot = end($stagePots);
        $nextSortOrder = ((int) ($lastPot['sort_order'] ?? count($stagePots))) + 1;

        $newPotId = (int) $this->potModel->insert([
            'tournament_id' => $tournamentId,
            'name' => $autoPotName,
            'stage' => $stage,
            'sort_order' => max(1, $nextSortOrder),
            'game_count' => $defaultGameCount,
            'max_teams' => $defaultMaxTeams,
            'reference_image_1' => null,
            'reference_image_2' => null,
        ], true);

        $createdPot = $this->potModel->find($newPotId);

        return [
            'ok' => true,
            'pot_id' => $newPotId,
            'is_sandbox' => 0,
            'pot' => $createdPot,
            'tournament_id' => $tournamentId,
            'overflow_note' => "Semua pot penuh, otomatis membuat & masuk ke '{$autoPotName}'.",
        ];
    }

    public function store()
    {
        $this->cleanupRosterData();
        $isAjax = $this->request->isAJAX();
        $data = $this->sanitizeTeamPayload($this->request->getPost([
            'tournament_id',
            'pot_id',
            'stage',
            'pot_name',
            'name',
            'sort_order',
            'redirect_to',
            'member_text',
        ]));

        if (!$this->validateData($data, $this->rules())) {
            return $this->teamErrorResponse('Data team belum valid.', $isAjax, $this->validator->getErrors());
        }

        $requestedPotId = $this->normalizePotId($data['pot_id'] ?? null);
        $requestedTournamentId = $this->normalizeTournamentId($data['tournament_id'] ?? null) ?? 0;
        $rawPotName = trim((string) ($data['pot_name'] ?? ''));
        $stage = strtolower(trim((string) ($data['stage'] ?? 'kualifikasi')));
        if (!in_array($stage, ['kualifikasi', 'semifinal', 'grandfinal', 'sandbox'], true)) {
            $stage = 'kualifikasi';
        }

        $allocation = $this->resolveTargetPotWithAutoOverflow(
            $requestedTournamentId,
            $stage,
            $requestedPotId,
            $rawPotName,
            null,
            true
        );

        if (!$allocation['ok']) {
            return $this->teamErrorResponse($allocation['message'], $isAjax);
        }

        $potId = $allocation['pot_id'];
        $isSandbox = (int) ($allocation['is_sandbox'] ?? 0);
        $targetTournamentId = (int) $allocation['tournament_id'];
        $overflowNote = (string) ($allocation['overflow_note'] ?? '');

        $existingCount = $potId !== null
            ? $this->teamModel->where('pot_id', $potId)->countAllResults()
            : $this->teamModel->where('pot_id IS NULL', null, false)->countAllResults();

        $name = $this->cleanRosterText((string) ($data['name'] ?? ''), 150);
        $sortOrder = $this->cleanRosterText((string) ($data['sort_order'] ?? ''), 20);
        $memberText = $this->cleanRosterText((string) ($data['member_text'] ?? ''), 1000, true);

        if ($name === '') {
            $name = $this->nextAvailableTeamName($potId, $existingCount + 1);
        } elseif (($duplicate = $this->findDuplicateTeamInScope($name, $potId, null, $targetTournamentId)) !== null) {
            return $this->teamErrorResponse($this->duplicateTeamMessage($name, $duplicate, $potId), $isAjax);
        }

        $insertRow = [
            'tournament_id' => $targetTournamentId > 0 ? $targetTournamentId : null,
            'pot_id' => $potId,
            'name' => $name,
            'sort_order' => $sortOrder === '' ? ($existingCount + 1) : (int) $sortOrder,
        ];
        if ($this->hasSandboxCol) {
            $insertRow['is_sandbox'] = $isSandbox;
        }

        $teamId = (int) $this->teamModel->insert($insertRow, true);
        $this->syncMembersFromText($teamId, $memberText);

        $redirectTo = trim((string) ($data['redirect_to'] ?? ''));
        if ($redirectTo === '' || str_contains($redirectTo, 'imports/teams')) {
            $redirectTo = site_url('teams/roster?tab=roster' . ($targetTournamentId > 0 ? '&tournament_id=' . $targetTournamentId : ''));
        }

        $successMsg = 'Team "' . $name . '" berhasil ditambahkan.' . ($overflowNote !== '' ? ' (' . $overflowNote . ')' : '');

        if ($isAjax) {
            return $this->response->setJSON([
                'status' => 'success',
                'message' => $successMsg,
                'teamId' => $teamId,
                'potId' => $potId ?? 0,
                'redirectUrl' => $redirectTo,
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        return redirect()->to($redirectTo)->with('success', $successMsg);
    }

    public function update(int $id)
    {
        $this->cleanupRosterData();
        $isAjax = $this->request->isAJAX();
        $data = $this->sanitizeTeamPayload($this->request->getPost(['tournament_id', 'pot_id', 'stage', 'pot_name', 'name', 'sort_order', 'redirect_to', 'member_text']));
        $redirectTo = trim((string) ($data['redirect_to'] ?? ''));
        if ($redirectTo === '' || str_contains($redirectTo, 'imports/teams')) {
            $redirectTo = site_url('teams/roster?tab=roster');
        }
        $result = $this->applyTeamUpdate($id, $data, $this->allowsUnassignedTeams());

        if (!$result['ok']) {
            return $this->teamErrorResponse($result['message'], $isAjax, $result['validation']);
        }

        if ($isAjax) {
            return $this->response->setJSON([
                'status' => 'success',
                'message' => $result['message'],
                'teamId' => $id,
                'potId' => $result['potId'] ?? 0,
                'previousPotId' => $result['previousPotId'] ?? 0,
                'redirectUrl' => $redirectTo,
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        return redirect()->to($redirectTo)->with('success', $result['message']);
    }

    public function bulkUpdate()
    {
        $this->cleanupRosterData();
        $isAjax = $this->request->isAJAX();
        $redirectTo = trim((string) ($this->request->getPost('redirect_to') ?? ''));
        if ($redirectTo === '' || str_contains($redirectTo, 'imports/teams')) {
            $redirectTo = site_url('teams/roster?tab=roster');
        }
        $allowsUnassigned = true;
        $teamsPayload = $this->sanitizeTeamsPayload((array) $this->request->getPost('teams'));

        if (!is_array($teamsPayload) || $teamsPayload === []) {
            return $this->teamErrorResponse('Belum ada perubahan team yang bisa disimpan.', $isAjax);
        }

        $singleTeamId = $this->normalizeBulkTeamId($this->request->getPost('save_single_team_id'));
        if ($singleTeamId === null) {
            $teamsPayload = $this->filterChangedBulkPayload($teamsPayload);
            if ($teamsPayload === []) {
                if ($isAjax) {
                    return $this->response->setJSON([
                        'status' => 'info',
                        'message' => 'Tidak ada perubahan baru untuk disimpan.',
                        'csrfTokenName' => csrf_token(),
                        'csrfHash' => csrf_hash(),
                    ]);
                }
                return redirect()->to($redirectTo)->with('info', 'Tidak ada perubahan baru untuk disimpan.');
            }
        }

        $targetTeamIds = $singleTeamId !== null ? [$singleTeamId] : array_map('intval', array_keys($teamsPayload));
        $updatedCount = 0;
        $lastMessage = 'Team berhasil diperbarui.';
        $db = db_connect();

        try {
            $db->transException(true)->transStart();

            foreach ($targetTeamIds as $teamId) {
                if (!isset($teamsPayload[$teamId]) || !is_array($teamsPayload[$teamId])) {
                    continue;
                }

                $rowData = $teamsPayload[$teamId];
                $rowData['redirect_to'] = $redirectTo;
                $result = $this->applyTeamUpdate((int) $teamId, $rowData, $allowsUnassigned);

                if (!$result['ok']) {
                    throw new \RuntimeException($result['message']);
                }

                $lastMessage = $result['message'];
                $updatedCount++;
            }

            $db->transComplete();
        } catch (\Throwable $e) {
            if ($db->transStatus() !== false) {
                $db->transRollback();
            }
            return $this->teamErrorResponse($e->getMessage(), $isAjax);
        }

        $successMessage = $singleTeamId !== null
            ? $lastMessage
            : $updatedCount . ' team berhasil diperbarui.';

        if ($isAjax) {
            return $this->response->setJSON([
                'status' => 'success',
                'message' => $successMessage,
                'updatedCount' => $updatedCount,
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        return redirect()->to($redirectTo)->with('success', $successMessage);
    }

    /**
     * POST /teams/bulk-action
     * Menangani aksi massal dari checkbox tabel Raw Teams (Auto-Overflow, Unassigned, Sandbox, Hapus Aman)
     */
    public function bulkAction()
    {
        $this->cleanupRosterData();
        $payload = $this->request->getJSON(true);
        if (!is_array($payload)) {
            $payload = $this->request->getPost();
        }

        $teamIds = array_values(array_filter(array_map('intval', (array) ($payload['team_ids'] ?? []))));
        $action = trim((string) ($payload['action'] ?? ''));
        $tournamentId = (int) ($payload['tournament_id'] ?? 0);

        if ($teamIds === [] || $action === '') {
            return $this->response->setStatusCode(422)->setJSON([
                'status' => 'error',
                'message' => 'Pilih minimal 1 tim dan aksi yang ingin dijalankan.',
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        $db = db_connect();
        try {
            $db->transException(true)->transStart();

            switch ($action) {
                case 'to_sandbox':
                    $upd = ['pot_id' => null];
                    if ($this->hasSandboxCol) {
                        $upd['is_sandbox'] = 1;
                    }
                    $this->teamModel->whereIn('id', $teamIds)->set($upd)->update();
                    $msg = count($teamIds) . ' tim berhasil dipindahkan ke Sandbox / Recycle Bin.';
                    break;

                case 'to_unassigned':
                    $upd = ['pot_id' => null];
                    if ($this->hasSandboxCol) {
                        $upd['is_sandbox'] = 0;
                    }
                    $this->teamModel->whereIn('id', $teamIds)->set($upd)->update();
                    $msg = count($teamIds) . ' tim berhasil dikembalikan ke Unassigned.';
                    break;

                case 'auto_overflow':
                    foreach ($teamIds as $id) {
                        $team = $this->teamModel->find($id);
                        if (!$team) {
                            continue;
                        }
                        $tId = $tournamentId > 0 ? $tournamentId : (int) ($team['tournament_id'] ?? 0);
                        $alloc = $this->resolveTargetPotWithAutoOverflow($tId, 'kualifikasi', null, '', $id, true);
                        if ($alloc['ok']) {
                            $upd = [
                                'pot_id' => $alloc['pot_id'],
                                'tournament_id' => $alloc['tournament_id'],
                            ];
                            if ($this->hasSandboxCol) {
                                $upd['is_sandbox'] = 0;
                            }
                            $this->teamModel->update($id, $upd);
                        }
                    }
                    $msg = count($teamIds) . ' tim berhasil dialokasikan otomatis ke Pot aktif.';
                    break;

                case 'delete_safe':
                    $this->scoreModel->whereIn('team_id', $teamIds)->delete();
                    $this->teamMemberModel->whereIn('team_id', $teamIds)->delete();
                    $this->teamModel->whereIn('id', $teamIds)->delete();
                    $msg = count($teamIds) . ' tim beserta skor & anggotanya berhasil dihapus secara aman.';
                    break;

                default:
                    throw new \RuntimeException('Aksi massal tidak dikenali.');
            }

            $db->transComplete();
        } catch (\Throwable $e) {
            if ($db->transStatus() !== false) {
                $db->transRollback();
            }
            return $this->response->setStatusCode(500)->setJSON([
                'status' => 'error',
                'message' => 'Gagal memproses aksi massal: ' . $e->getMessage(),
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        return $this->response->setJSON([
            'status' => 'success',
            'message' => $msg,
            'csrfTokenName' => csrf_token(),
            'csrfHash' => csrf_hash(),
        ]);
    }

    public function delete(int $id)
    {
        return $this->destroyTeam($id, 'delete');
    }

    public function detach(int $id)
    {
        return $this->destroyTeam($id, 'detach');
    }

    private function destroyTeam(int $id, string $mode)
    {
        $team = $this->teamModel->find($id);
        $isAjax = $this->request->isAJAX();
        $deleteMode = $mode === 'detach' ? 'detach' : 'delete';

        if ($team === null) {
            if ($isAjax) {
                return $this->response->setStatusCode(404)->setJSON([
                    'status' => 'error',
                    'message' => 'Team tidak ditemukan.',
                    'csrfTokenName' => csrf_token(),
                    'csrfHash' => csrf_hash(),
                ]);
            }
            throw PageNotFoundException::forPageNotFound('Team tidak ditemukan.');
        }

        $potId = isset($team['pot_id']) && $team['pot_id'] !== null ? (int) $team['pot_id'] : null;
        $pot = $potId !== null ? $this->potWithTournament($potId) : null;

        if ($pot !== null && !$this->isPotEditable($pot)) {
            return $this->teamErrorResponse('Tournament sudah finished. Team tidak bisa dihapus.', $isAjax);
        }

        $db = db_connect();
        $redirectTo = trim((string) ($this->request->getPost('redirect_to') ?? ''));
        if ($redirectTo === '' || str_contains($redirectTo, 'imports/teams')) {
            $fallbackUrl = $potId !== null ? site_url('pots/' . $potId . '/scores') : site_url('teams/roster?tab=roster');
        } else {
            $fallbackUrl = $redirectTo;
        }

        try {
            $db->transException(true)->transStart();
            if ($deleteMode === 'detach') {
                if ($potId !== null) {
                    $this->scoreModel->where('team_id', $id)->where('pot_id', $potId)->delete();
                }

                $nextSortOrder = $this->teamModel->where('pot_id IS NULL', null, false)->countAllResults() + 1;
                $upd = [
                    'tournament_id' => $pot !== null ? (int) ($pot['tournament_id'] ?? 0) : $team['tournament_id'],
                    'pot_id' => null,
                    'sort_order' => $nextSortOrder,
                ];
                if ($this->hasSandboxCol) {
                    $upd['is_sandbox'] = 0;
                }
                $this->teamModel->update($id, $upd);
            } else {
                $this->scoreModel->where('team_id', $id)->delete();
                $this->teamMemberModel->where('team_id', $id)->delete();
                $this->teamModel->delete($id);
            }
            $db->transComplete();
        } catch (\Throwable $e) {
            if ($db->transStatus() !== false) {
                $db->transRollback();
            }
            return $this->teamErrorResponse('Gagal memproses penghapusan tim.', $isAjax);
        }

        if ($isAjax) {
            return $this->response->setJSON([
                'status' => 'success',
                'message' => $deleteMode === 'detach' ? 'Team dilepas dari pot.' : 'Team berhasil dihapus.',
                'teamId' => $id,
                'potId' => $potId ?? 0,
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        return redirect()->to($fallbackUrl)->with('success', $deleteMode === 'detach' ? 'Team dilepas dari pot.' : 'Team berhasil dihapus.');
    }

    private function rules(): array
    {
        return [
            'pot_id' => ['label' => 'Pot', 'rules' => 'permit_empty|is_natural'],
            'tournament_id' => ['label' => 'Tournament', 'rules' => 'permit_empty|is_natural'],
            'stage' => ['label' => 'Stage', 'rules' => 'permit_empty|in_list[kualifikasi,semifinal,grandfinal,sandbox]'],
            'pot_name' => ['label' => 'Nama Pot', 'rules' => 'permit_empty|max_length[100]'],
            'name' => ['label' => 'Nama team', 'rules' => 'permit_empty|max_length[150]'],
            'sort_order' => ['label' => 'Urutan', 'rules' => 'permit_empty|is_natural'],
        ];
    }

    private function buildTournamentTemplateExport(int $tournamentId): array
    {
        $pots = $this->potModel
            ->where('tournament_id', $tournamentId)
            ->orderBy('sort_order', 'ASC')
            ->orderBy('name', 'ASC')
            ->findAll();

        $exports = [];
        foreach ($pots as $pot) {
            $exports[] = $this->buildPotTemplateExport((int) $pot['id']);
        }

        $unassignedTeams = $this->teamModel
            ->where('tournament_id', $tournamentId)
            ->where('pot_id IS NULL', null, false)
            ->orderBy('sort_order', 'ASC')
            ->orderBy('name', 'ASC')
            ->findAll();

        return [
            'exports' => $exports,
            'unassignedTeams' => $unassignedTeams,
        ];
    }

    private function buildPotTemplateExport(int $potId): array
    {
        $pot = $this->potWithTournament($potId);
        if ($pot === null) {
            throw PageNotFoundException::forPageNotFound('Pot tidak ditemukan.');
        }

        $teams = $this->teamModel
            ->where('pot_id', $potId)
            ->orderBy('sort_order', 'ASC')
            ->orderBy('name', 'ASC')
            ->findAll();

        $teamIds = array_map(static fn(array $team): int => (int) $team['id'], $teams);
        $scores = $teamIds === []
            ? []
            : $this->scoreModel
                ->where('pot_id', $potId)
                ->whereIn('team_id', $teamIds)
                ->orderBy('game_no', 'ASC')
                ->findAll();

        $scoresByTeam = [];
        $gameCount = 2;
        foreach ($scores as $score) {
            $teamId = (int) $score['team_id'];
            $gameNo = (int) $score['game_no'];
            $scoresByTeam[$teamId][$gameNo] = $score;
            $gameCount = max($gameCount, $gameNo);
        }

        $gameCount = max(2, $gameCount);
        $matrix = $this->buildTemplateMatrix($teams, $scoresByTeam, $gameCount, (string) ($pot['name'] ?? 'POT'));

        return [
            'pot' => $pot,
            'teams' => $teams,
            'gameCount' => $gameCount,
            'matrix' => $matrix,
            'csvText' => $this->matrixToCsv($matrix),
            'clipboardText' => $this->matrixToTsv($matrix),
        ];
    }

    private function buildTemplateMatrix(array $teams, array $scoresByTeam, int $gameCount, string $potName): array
    {
        $headerRow1 = ['No', 'Nama Tim', '', ''];
        $headerRow2 = ['', '', '', ''];
        $headerRow3 = ['', '', '', ''];

        for ($gameNo = 1; $gameNo <= $gameCount; $gameNo++) {
            $headerRow1 = array_merge($headerRow1, [$gameNo === 1 ? strtoupper($potName) : '', '', '']);
            $headerRow2 = array_merge($headerRow2, ['GAME ' . $gameNo, '', '']);
            $headerRow3 = array_merge($headerRow3, ['Rank', 'P.Rank', 'P.Kill']);
        }

        $headerRow1[] = 'Total Point';
        $headerRow2[] = '';
        $headerRow3[] = '';

        $rows = [$headerRow1, $headerRow2, $headerRow3];

        foreach ($teams as $index => $team) {
            $excelRow = $index + 4;
            $row = [
                $index + 1,
                (string) ($team['name'] ?? ''),
                '',
                '',
            ];

            $totalRefs = [];
            for ($gameNo = 1; $gameNo <= $gameCount; $gameNo++) {
                $rankColumn = $this->excelColumnName(5 + (($gameNo - 1) * 3));
                $placementColumn = $this->excelColumnName(6 + (($gameNo - 1) * 3));
                $killColumn = $this->excelColumnName(7 + (($gameNo - 1) * 3));
                $rankValue = $scoresByTeam[(int) $team['id']][$gameNo]['rank_no'] ?? '';
                $killValue = $scoresByTeam[(int) $team['id']][$gameNo]['kill_point'] ?? '';

                $row[] = $rankValue !== '' ? (int) $rankValue : '';
                $row[] = '=IF(' . $rankColumn . $excelRow . '="","",IFERROR(IFS(VALUE(' . $rankColumn . $excelRow . ')=0,0,VALUE(' . $rankColumn . $excelRow . ')=1,12,VALUE(' . $rankColumn . $excelRow . ')=2,9,VALUE(' . $rankColumn . $excelRow . ')=3,8,VALUE(' . $rankColumn . $excelRow . ')=4,7,VALUE(' . $rankColumn . $excelRow . ')=5,6,VALUE(' . $rankColumn . $excelRow . ')=6,5,VALUE(' . $rankColumn . $excelRow . ')=7,4,VALUE(' . $rankColumn . $excelRow . ')=8,3,VALUE(' . $rankColumn . $excelRow . ')=9,2,VALUE(' . $rankColumn . $excelRow . ')=10,1,VALUE(' . $rankColumn . $excelRow . ')>=11,0),0))';
                $row[] = $killValue !== '' ? (int) $killValue : '';

                $totalRefs[] = $placementColumn . $excelRow;
                $totalRefs[] = $killColumn . $excelRow;
            }

            $row[] = '=IF(B' . $excelRow . '="","",SUM(' . implode(',', $totalRefs) . '))';
            $rows[] = $row;
        }

        return $rows;
    }

    private function matrixToCsv(array $matrix): string
    {
        $lines = array_map(function (array $row): string {
            $escaped = array_map(function ($value): string {
                $string = str_replace(["\r", "\n"], ' ', (string) ($value ?? ''));
                $string = str_replace('"', '""', $string);
                return '"' . $string . '"';
            }, $row);
            return implode(',', $escaped);
        }, $matrix);

        return implode("\r\n", $lines) . "\r\n";
    }

    private function matrixToTsv(array $matrix): string
    {
        $lines = array_map(static function (array $row): string {
            $escaped = array_map(static function ($value): string {
                return str_replace(["\t", "\r", "\n"], [' ', ' ', ' '], (string) ($value ?? ''));
            }, $row);
            return implode("\t", $escaped);
        }, $matrix);

        return implode("\r\n", $lines) . "\r\n";
    }

    private function excelColumnName(int $columnNumber): string
    {
        $name = '';
        $index = $columnNumber;
        while ($index > 0) {
            $index--;
            $name = chr(65 + ($index % 26)) . $name;
            $index = intdiv($index, 26);
        }
        return $name;
    }

    private function syncMembersFromText(int $teamId, string $memberText): void
    {
        $members = $this->memberListFromText($memberText);

        $this->teamMemberModel->where('team_id', $teamId)->delete();
        foreach ($members as $memberName) {
            $this->teamMemberModel->insert([
                'team_id' => $teamId,
                'player_name' => $this->cleanRosterText($memberName, 80),
                'player_role' => null,
            ]);
        }
    }

    private function memberListFromText(string $memberText): array
    {
        $memberText = $this->cleanRosterText($memberText, 1000, true);
        $memberText = str_replace([";", "\r\n", "\r"], [",", "\n", "\n"], $memberText);
        $chunks = preg_split('/\n|,/', $memberText) ?: [];
        $members = [];

        foreach ($chunks as $chunk) {
            $name = $this->cleanRosterText($chunk, 80);
            if ($name === '') {
                continue;
            }
            $members[] = preg_replace('/\s+/u', ' ', $name) ?? $name;
        }

        return array_slice(array_values(array_unique($members)), 0, self::MAX_MEMBERS);
    }

    private function normalizeName(string $value): string
    {
        $value = $this->cleanRosterText($value, 150);
        $value = strtolower(trim($value));
        return preg_replace('/[^a-z0-9]+/u', '', $value) ?? '';
    }

    private function potWithTournament(int $potId): ?array
    {
        return $this->potModel
            ->select('pots.*, tournaments.status AS tournament_status, tournaments.max_teams_per_pot')
            ->join('tournaments', 'tournaments.id = pots.tournament_id')
            ->where('pots.id', $potId)
            ->first();
    }

    private function isPotEditable(array $pot): bool
    {
        return (string) ($pot['tournament_status'] ?? TournamentModel::STATUS_BELUM_MULAI) !== TournamentModel::STATUS_SELESAI;
    }

    private function memberNamesByTeam(array $teamIds): array
    {
        if ($teamIds === []) {
            return [];
        }

        $membersByTeam = [];
        $members = $this->teamMemberModel
            ->whereIn('team_id', $teamIds)
            ->orderBy('id', 'ASC')
            ->findAll();

        foreach ($members as $member) {
            $name = trim((string) ($member['player_name'] ?? ''));
            if ($name === '') {
                continue;
            }
            $membersByTeam[(int) $member['team_id']][] = $name;
        }

        return $membersByTeam;
    }

    private function lookupTeamsForManager(int $selectedTournamentId): array
    {
        $builder = $this->teamModel
            ->select('teams.id, teams.tournament_id, teams.pot_id, teams.name, teams.sort_order, pots.name AS pot_name, COALESCE(pots.tournament_id, teams.tournament_id) AS tournament_id, COALESCE(pot_tournaments.name, team_tournaments.name) AS tournament_name')
            ->join('pots', 'pots.id = teams.pot_id', 'left')
            ->join('tournaments AS pot_tournaments', 'pot_tournaments.id = pots.tournament_id', 'left')
            ->join('tournaments AS team_tournaments', 'team_tournaments.id = teams.tournament_id', 'left');

        if ($selectedTournamentId > 0) {
            $builder->groupStart()
                ->where('pots.tournament_id', $selectedTournamentId)
                ->orGroupStart()
                ->where('teams.pot_id IS NULL', null, false)
                ->where('teams.tournament_id', $selectedTournamentId)
                ->groupEnd()
                ->groupEnd();
        }

        return $builder
            ->orderBy('teams.name', 'ASC')
            ->orderBy('teams.sort_order', 'ASC')
            ->findAll();
    }

    private function normalizePotId($value): ?int
    {
        $value = trim((string) ($value ?? ''));
        if ($value === '' || $value === '0' || !ctype_digit($value)) {
            return null;
        }
        $potId = (int) $value;
        return $potId > 0 ? $potId : null;
    }

    private function normalizeTournamentId($value): ?int
    {
        $value = trim((string) ($value ?? ''));
        if ($value === '' || $value === '0' || !ctype_digit($value)) {
            return null;
        }
        $tournamentId = (int) $value;
        return $tournamentId > 0 ? $tournamentId : null;
    }

    private function cleanupRosterData(): void
    {
        try {
            $db = db_connect();
            $set = 't.tournament_id = p.tournament_id' . ($this->hasSandboxCol ? ', t.is_sandbox = 0' : '');
            $db->query("
                UPDATE teams t
                INNER JOIN pots p ON p.id = t.pot_id
                SET {$set}
                WHERE t.pot_id IS NOT NULL
                  AND (t.tournament_id IS NULL OR t.tournament_id = 0 OR t.tournament_id != p.tournament_id" . ($this->hasSandboxCol ? ' OR t.is_sandbox != 0' : '') . ")
            ");
        } catch (\Throwable $e) {
            // ignore on read-only
        }
    }

    private function sanitizeTeamPayload(array $data): array
    {
        if (isset($data['name'])) {
            $data['name'] = $this->cleanRosterText((string) $data['name'], 150);
        }
        if (isset($data['member_text'])) {
            $data['member_text'] = $this->cleanRosterText((string) $data['member_text'], 1000, true);
        }
        if (isset($data['redirect_to'])) {
            $data['redirect_to'] = $this->cleanRosterText((string) $data['redirect_to'], 255);
        }
        if (isset($data['sort_order'])) {
            $data['sort_order'] = $this->cleanRosterText((string) $data['sort_order'], 20);
        }
        if (isset($data['tournament_id'])) {
            $data['tournament_id'] = $this->cleanRosterText((string) $data['tournament_id'], 20);
        }
        if (isset($data['pot_id'])) {
            $data['pot_id'] = $this->cleanRosterText((string) $data['pot_id'], 20);
        }
        if (isset($data['stage'])) {
            $rawStage = strtolower(trim((string) $data['stage']));
            $rawStage = str_replace([' ', '_', '-'], '', $rawStage);
            $data['stage'] = $this->cleanRosterText($rawStage, 50);
        }
        if (isset($data['pot_name'])) {
            $data['pot_name'] = $this->cleanRosterText((string) $data['pot_name'], 100);
        }

        return $data;
    }

    private function sanitizeTeamsPayload(array $teamsPayload): array
    {
        foreach ($teamsPayload as $teamId => $rowData) {
            if (!is_array($rowData)) {
                continue;
            }
            $teamsPayload[$teamId] = $this->sanitizeTeamPayload($rowData);
        }
        return $teamsPayload;
    }

    private function cleanRosterText(string $value, int $maxLength = 150, bool $allowLineBreaks = false): string
    {
        if ($value === '') {
            return '';
        }

        if (!mb_check_encoding($value, 'UTF-8')) {
            $converted = @iconv('UTF-8', 'UTF-8//IGNORE', $value);
            if ($converted !== false) {
                $value = $converted;
            }
        }

        $value = str_replace("\0", '', $value);

        if ($allowLineBreaks) {
            $value = preg_replace('/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/u', '', $value) ?? $value;
            $value = preg_replace('/\r\n?/', "\n", $value) ?? $value;
            $value = preg_replace('/[^\S\n]+/u', ' ', $value) ?? $value;
        } else {
            $value = preg_replace('/[\x00-\x1F\x7F]/u', '', $value) ?? $value;
            $value = preg_replace('/\s+/u', ' ', $value) ?? $value;
        }
        $value = trim($value);

        return function_exists('mb_substr') ? mb_substr($value, 0, $maxLength) : substr($value, 0, $maxLength);
    }

    private function allowsUnassignedTeams(): bool
    {
        return true;
    }

    private function normalizeBulkTeamId($value): ?int
    {
        $value = trim((string) ($value ?? ''));
        if ($value === '' || !ctype_digit($value)) {
            return null;
        }
        $teamId = (int) $value;
        return $teamId > 0 ? $teamId : null;
    }

    private function filterChangedBulkPayload(array $teamsPayload): array
    {
        $changed = [];
        foreach ($teamsPayload as $teamId => $rowData) {
            if (is_array($rowData) && trim((string) ($rowData['__changed'] ?? '')) === '1') {
                $changed[$teamId] = $rowData;
            }
        }
        return $changed;
    }

    private function applyTeamUpdate(int $id, array $data, bool $allowsUnassigned): array
    {
        $team = $this->teamModel->find($id);
        if ($team === null) {
            return ['ok' => false, 'message' => 'Team tidak ditemukan.', 'validation' => []];
        }

        $currentPot = isset($team['pot_id']) && $team['pot_id'] !== null
            ? $this->potWithTournament((int) $team['pot_id'])
            : null;

        if ($currentPot !== null && !$this->isPotEditable($currentPot)) {
            return ['ok' => false, 'message' => 'Tournament sudah finished. Team tidak bisa diubah.', 'validation' => []];
        }

        $data = $this->sanitizeTeamPayload($data);
        if (!$this->validateData($data, $this->rules())) {
            return ['ok' => false, 'message' => 'Perubahan team belum valid.', 'validation' => $this->validator->getErrors()];
        }

        $requestedTournamentId = $this->normalizeTournamentId($data['tournament_id'] ?? $team['tournament_id'] ?? null) ?? 0;
        if ($requestedTournamentId <= 0 && $currentPot !== null) {
            $requestedTournamentId = (int) ($currentPot['tournament_id'] ?? 0);
        }

        $explicitPotId = $this->normalizePotId($data['pot_id'] ?? null);
        $rawPotName = trim((string) ($data['pot_name'] ?? ''));
        $rawStageInput = strtolower(trim((string) ($data['stage'] ?? '')));
        $stage = str_replace([' ', '_', '-'], '', $rawStageInput);

        if ($stage === 'sandbox') {
            $targetPotId = null;
            $isSandbox = 1;
            $targetTournamentId = $requestedTournamentId;
            $overflowNote = 'Dipindahkan ke Sandbox / Recycle Bin.';
        } elseif ($stage === '' && $rawPotName === '' && $explicitPotId === null) {
            $targetPotId = null;
            $isSandbox = 0;
            $targetTournamentId = $requestedTournamentId;
            $overflowNote = '';
        } else {
            $hasValidStage = in_array($stage, ['kualifikasi', 'semifinal', 'grandfinal'], true);
            if (!$hasValidStage) {
                $stage = $currentPot !== null ? strtolower((string) ($currentPot['stage'] ?? 'kualifikasi')) : 'kualifikasi';
            }

            $wasUnassigned = ($team['pot_id'] === null || (int) $team['pot_id'] === 0);
            $autoAssignIfEmpty = ($wasUnassigned && $hasValidStage) || (!array_key_exists('pot_name', $data) && !array_key_exists('pot_id', $data));
            $overflowNote = '';

            if (
                !$wasUnassigned
                && $explicitPotId === null
                && $rawPotName !== ''
                && $currentPot !== null
                && strtolower(trim((string) $currentPot['name'])) === strtolower(trim(preg_replace('/^\[[^\]]+\]\s*-\s*/u', '', $rawPotName)))
                && strtolower((string) ($currentPot['stage'] ?? 'kualifikasi')) === $stage
            ) {
                $targetPotId = (int) $currentPot['id'];
                $isSandbox = 0;
                $targetTournamentId = (int) $currentPot['tournament_id'];
            } else {
                $allocation = $this->resolveTargetPotWithAutoOverflow(
                    $requestedTournamentId,
                    $stage,
                    $explicitPotId,
                    $rawPotName,
                    $id,
                    $autoAssignIfEmpty
                );

                if (!$allocation['ok']) {
                    return ['ok' => false, 'message' => $allocation['message'], 'validation' => []];
                }

                $targetPotId = $allocation['pot_id'];
                $isSandbox = (int) ($allocation['is_sandbox'] ?? 0);
                $targetTournamentId = (int) $allocation['tournament_id'];
                $overflowNote = (string) ($allocation['overflow_note'] ?? '');
            }
        }

        $name = $this->cleanRosterText((string) ($data['name'] ?? ''), 150);
        $sortOrder = $this->cleanRosterText((string) ($data['sort_order'] ?? ''), 20);
        $finalName = $name === '' ? (string) $team['name'] : $name;

        if ($isSandbox === 0 && ($duplicate = $this->findDuplicateTeamInScope($finalName, $targetPotId, $id, $targetTournamentId)) !== null) {
            return ['ok' => false, 'message' => $this->duplicateTeamMessage($finalName, $duplicate, $targetPotId), 'validation' => []];
        }

        $finalSortOrder = $sortOrder !== '' ? (int) $sortOrder : (int) ($team['sort_order'] ?? 1);
        if ($targetPotId !== null && $targetPotId !== (int) ($team['pot_id'] ?? 0) && $sortOrder === '') {
            $finalSortOrder = $this->teamModel->where('pot_id', $targetPotId)->countAllResults() + 1;
        }

        $updRow = [
            'tournament_id' => $targetTournamentId > 0 ? $targetTournamentId : null,
            'pot_id' => $targetPotId,
            'name' => $finalName,
            'sort_order' => max(1, $finalSortOrder),
        ];
        if ($this->hasSandboxCol) {
            $updRow['is_sandbox'] = $isSandbox;
        }

        $this->teamModel->update($id, $updRow);

        if (array_key_exists('member_text', $data)) {
            $this->syncMembersFromText($id, (string) ($data['member_text'] ?? ''));
        }

        return [
            'ok' => true,
            'message' => 'Team "' . $finalName . '" berhasil diperbarui.' . ($overflowNote !== '' ? ' (' . $overflowNote . ')' : ''),
            'validation' => [],
            'potId' => $targetPotId ?? 0,
            'previousPotId' => (int) ($team['pot_id'] ?? 0),
        ];
    }

    private function findDuplicateTeamInScope(string $teamName, ?int $targetPotId = null, ?int $excludeTeamId = null, ?int $targetTournamentId = null): ?array
    {
        $normalizedTeamName = $this->normalizeName($teamName);
        if ($normalizedTeamName === '') {
            return null;
        }

        $builder = $this->teamModel
            ->select('teams.id, teams.tournament_id, teams.pot_id, teams.name, pots.name AS pot_name, COALESCE(pots.tournament_id, teams.tournament_id) AS tournament_id')
            ->join('pots', 'pots.id = teams.pot_id', 'left');

        if ($excludeTeamId !== null) {
            $builder->where('teams.id !=', $excludeTeamId);
        }

        if ($targetPotId !== null) {
            $builder->where('teams.pot_id', $targetPotId);
        } elseif ($targetTournamentId !== null && $targetTournamentId > 0) {
            $builder->where('teams.pot_id IS NULL', null, false)
                ->where('teams.tournament_id', $targetTournamentId);
            if ($this->hasSandboxCol) {
                $builder->where('teams.is_sandbox', 0);
            }
        }

        foreach ($builder->findAll() as $team) {
            if ($this->normalizeName((string) ($team['name'] ?? '')) === $normalizedTeamName) {
                return $team;
            }
        }

        return null;
    }

    private function duplicateTeamMessage(string $teamName, array $duplicateTeam, ?int $targetPotId = null): string
    {
        $safeTeamName = trim($teamName) !== '' ? trim($teamName) : 'Team ini';

        if ($duplicateTeam['pot_id'] === null || (int) $duplicateTeam['pot_id'] === 0) {
            return 'Nama team "' . $safeTeamName . '" sudah ada di daftar Unassigned (Tanpa Pot) pada turnamen ini.';
        }

        if ($targetPotId !== null && (int) $duplicateTeam['pot_id'] === $targetPotId) {
            return 'Nama team "' . $safeTeamName . '" sudah terdaftar di dalam pot ini.';
        }

        $potName = trim((string) ($duplicateTeam['pot_name'] ?? ''));
        return $potName !== ''
            ? 'Nama team "' . $safeTeamName . '" sudah ada di ' . $potName . '.'
            : 'Nama team "' . $safeTeamName . '" sudah ada di dalam pot tersebut.';
    }

    private function nextAvailableTeamName(?int $targetPotId, int $seed = 1): string
    {
        $candidate = max(1, $seed);
        while (true) {
            $name = 'Team ' . $candidate;
            if ($this->findDuplicateTeamInScope($name, $targetPotId) === null) {
                return $name;
            }
            $candidate++;
        }
    }

    private function teamErrorResponse(string $message, bool $isAjax, array $validation = [])
    {
        if ($isAjax) {
            return $this->response->setStatusCode(422)->setJSON([
                'status' => 'error',
                'message' => $message,
                'validation' => $validation,
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        $redirect = redirect()->back()->with('error', $message);
        return $validation === [] ? $redirect : $redirect->with('validation', $validation);
    }

    /**
     * GET /teams/drag-manager
     * Menyiapkan data untuk view drag_manager.php (Unassigned + Sandbox + Pots)
     */
    public function dragManager()
    {
        $this->cleanupRosterData();

        $unassignedBuilder = $this->teamModel->where('pot_id IS NULL', null, false);
        if ($this->hasSandboxCol) {
            $unassignedBuilder->where('is_sandbox', 0);
        }
        $unassignedTeams = $unassignedBuilder
            ->orderBy('sort_order', 'ASC')
            ->orderBy('name', 'ASC')
            ->findAll();

        $sandboxTeams = [];
        if ($this->hasSandboxCol) {
            $sandboxTeams = $this->teamModel
                ->where('pot_id IS NULL', null, false)
                ->where('is_sandbox', 1)
                ->orderBy('sort_order', 'ASC')
                ->orderBy('name', 'ASC')
                ->findAll();
        }

        $tournaments = $this->tournamentModel->orderBy('created_at', 'DESC')->findAll();

        $allPots = $this->potModel
            ->orderBy('tournament_id', 'DESC')
            ->orderBy('sort_order', 'ASC')
            ->findAll();

        $allTeams = $this->teamModel
            ->where('pot_id IS NOT NULL', null, false)
            ->orderBy('sort_order', 'ASC')
            ->orderBy('name', 'ASC')
            ->findAll();

        $teamsByPot = [];
        foreach ($allTeams as $t) {
            $teamsByPot[(int) $t['pot_id']][] = $t;
        }

        $stageLabels = [
            'kualifikasi' => 'Kualifikasi',
            'semifinal' => 'Semifinal',
            'grandfinal' => 'Grand Final',
        ];

        $potsByTournament = [];
        foreach ($allPots as $p) {
            $stageKey = strtolower(trim((string) ($p['stage'] ?? 'kualifikasi')));
            $p['stage_label'] = $stageLabels[$stageKey] ?? ucfirst($stageKey);
            $p['teams'] = $teamsByPot[(int) $p['id']] ?? [];
            $potsByTournament[(int) $p['tournament_id']][] = $p;
        }

        foreach ($tournaments as &$t) {
            $t['pots'] = $potsByTournament[(int) $t['id']] ?? [];
        }
        unset($t);

        return view('teams/drag_manager', [
            'pageTitle' => 'Drag & Drop Team Manager',
            'unassignedTeams' => $unassignedTeams,
            'sandboxTeams' => $sandboxTeams,
            'tournaments' => $tournaments,
        ]);
    }

    /**
     * POST /teams/drag-manager/save
     * Mendukung Move, Clone/Promote Multi-Pot, Unassigned (pot_id = 0), dan Sandbox (pot_id = -1)
     */
    public function saveDragManager()
    {
        $json = $this->request->getJSON(true);
        if (!is_array($json)) {
            $json = $this->request->getPost();
        }

        $teams = $json['teams'] ?? [];

        if (!is_array($teams) || empty($teams)) {
            return $this->response->setStatusCode(400)->setJSON([
                'status' => 'error',
                'message' => 'Tidak ada data tim yang dikirim.',
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        $allPots = $this->potModel->select('id, tournament_id')->findAll();
        $potTournamentMap = [];
        foreach ($allPots as $p) {
            $potTournamentMap[(int) $p['id']] = (int) $p['tournament_id'];
        }

        $db = db_connect();
        $updatedCount = 0;
        $clonedCount = 0;

        try {
            $db->transException(true)->transStart();

            foreach ($teams as $row) {
                $isClone = !empty($row['is_clone']);
                $teamId = (int) ($row['team_id'] ?? 0);
                $sourceTeamId = (int) ($row['source_team_id'] ?? $teamId);
                $rawPotId = (int) ($row['pot_id'] ?? 0);
                $isSandbox = (!empty($row['is_sandbox']) || $rawPotId === -1) ? 1 : 0;
                $potId = ($rawPotId > 0 && $isSandbox === 0) ? $rawPotId : null;
                $sortOrder = max(1, (int) ($row['sort_order'] ?? 1));

                $tournamentId = null;
                if ($potId !== null && isset($potTournamentMap[$potId])) {
                    $tournamentId = $potTournamentMap[$potId];
                } elseif (!empty($row['tournament_id']) && (int) $row['tournament_id'] > 0) {
                    $tournamentId = (int) $row['tournament_id'];
                }

                // KASUS A: Tim hasil Promosi / Lolos Babak (Multi-Pot Clone)
                if ($isClone && $sourceTeamId > 0 && $potId !== null) {
                    $sourceTeam = $this->teamModel->find($sourceTeamId);
                    if ($sourceTeam === null) {
                        continue;
                    }

                    $alreadyInPot = $this->teamModel
                        ->where('pot_id', $potId)
                        ->where('LOWER(TRIM(name))', strtolower(trim((string) $sourceTeam['name'])))
                        ->first();

                    if ($alreadyInPot !== null) {
                        $updClone = [
                            'tournament_id' => $tournamentId,
                            'sort_order' => $sortOrder,
                        ];
                        if ($this->hasSandboxCol) {
                            $updClone['is_sandbox'] = 0;
                        }
                        $this->teamModel->update((int) $alreadyInPot['id'], $updClone);
                        $updatedCount++;
                        continue;
                    }

                    $insClone = [
                        'tournament_id' => $tournamentId ?? $sourceTeam['tournament_id'],
                        'pot_id' => $potId,
                        'name' => (string) $sourceTeam['name'],
                        'sort_order' => $sortOrder,
                    ];
                    if ($this->hasSandboxCol) {
                        $insClone['is_sandbox'] = 0;
                    }

                    $newTeamId = (int) $this->teamModel->insert($insClone, true);

                    if ($newTeamId > 0) {
                        $members = $this->teamMemberModel->where('team_id', $sourceTeamId)->findAll();
                        foreach ($members as $m) {
                            $this->teamMemberModel->insert([
                                'team_id' => $newTeamId,
                                'player_name' => $m['player_name'],
                                'player_role' => $m['player_role'] ?? null,
                            ]);
                        }
                        $clonedCount++;
                    }
                    continue;
                }

                // KASUS B: Update / Pindah ke Pot, Unassigned, atau Sandbox
                if ($teamId <= 0) {
                    continue;
                }

                $existingTeam = $this->teamModel->find($teamId);
                if ($existingTeam === null) {
                    continue;
                }

                $finalTourneyId = $potId !== null
                    ? $tournamentId
                    : ($existingTeam['tournament_id'] !== null ? (int) $existingTeam['tournament_id'] : null);

                $updRow = [
                    'pot_id' => $potId,
                    'tournament_id' => $finalTourneyId,
                    'sort_order' => $sortOrder,
                ];
                if ($this->hasSandboxCol) {
                    $updRow['is_sandbox'] = $isSandbox;
                }

                $this->teamModel->update($teamId, $updRow);
                $updatedCount++;
            }

            $db->transComplete();
        } catch (\Throwable $e) {
            if ($db->transStatus() !== false) {
                $db->transRollback();
            }
            return $this->response->setStatusCode(500)->setJSON([
                'status' => 'error',
                'message' => 'Gagal menyimpan: ' . $e->getMessage(),
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        return $this->response->setJSON([
            'status' => 'success',
            'message' => "Berhasil menyimpan! ({$updatedCount} tim diperbarui, {$clonedCount} tim dipromosikan).",
            'csrfTokenName' => csrf_token(),
            'csrfHash' => csrf_hash(),
        ]);
    }

    /**
     * ========================================================================
     * SMART CSV / SPREADSHEET IMPORT ENGINE (PREVIEW & DYNAMIC MAPPING)
     * ========================================================================
     */

    public function rawCsvView()
    {
        $this->cleanupRosterData();
        $tournaments = $this->tournamentModel->orderBy('created_at', 'DESC')->findAll();
        $pots = $this->potModel
            ->orderBy('tournament_id', 'DESC')
            ->orderBy('stage', 'ASC')
            ->orderBy('sort_order', 'ASC')
            ->findAll();

        return view('imports/raw_csv', [
            'pageTitle' => 'Smart CSV & Spreadsheet Import Engine',
            'tournaments' => $tournaments,
            'pots' => $pots,
        ]);
    }

    public function previewMappedCsv()
    {
        $rawRows = [];
        $file = $this->request->getFile('team_file') ?? $this->request->getFile('csv_file');
        $rawText = trim((string) ($this->request->getPost('raw_paste') ?? ''));

        if ($file !== null && $file->isValid() && !$file->hasMoved()) {
            $ext = strtolower((string) $file->getClientExtension());
            if (!in_array($ext, ['csv', 'tsv', 'txt'], true)) {
                return $this->response->setStatusCode(422)->setJSON([
                    'status' => 'error',
                    'message' => 'Untuk file di server hanya menerima .csv, .tsv, atau .txt. Untuk file .xlsx bisa dibaca langsung di browser atau Copy-Paste.',
                    'csrfTokenName' => csrf_token(),
                    'csrfHash' => csrf_hash(),
                ]);
            }

            $lines = @file($file->getTempName(), FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
            if (is_array($lines) && $lines !== []) {
                $lines[0] = preg_replace('/^\xEF\xBB\xBF/', '', (string) $lines[0]) ?? $lines[0];
                $delimiter = $this->detectCsvDelimiter((string) $lines[0]);
                foreach ($lines as $line) {
                    if (trim($line) === '') {
                        continue;
                    }
                    $parsed = str_getcsv($line, $delimiter);
                    if ($this->hasNonEmptyCell($parsed)) {
                        $rawRows[] = array_map(fn($v): string => $this->cleanRosterText((string) $v, 250), $parsed);
                    }
                }
            }
        } elseif ($rawText !== '') {
            $lines = preg_split('/\r\n|\r|\n/', $rawText) ?: [];
            if ($lines !== []) {
                $delimiter = $this->detectCsvDelimiter((string) $lines[0]);
                foreach ($lines as $line) {
                    if (trim($line) === '') {
                        continue;
                    }
                    $parsed = str_getcsv($line, $delimiter);
                    if ($this->hasNonEmptyCell($parsed)) {
                        $rawRows[] = array_map(fn($v): string => $this->cleanRosterText((string) $v, 250), $parsed);
                    }
                }
            }
        } else {
            return $this->response->setStatusCode(422)->setJSON([
                'status' => 'error',
                'message' => 'Pilih file CSV/TSV atau tempel (paste) data dari Excel/Google Sheets terlebih dahulu.',
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        if (count($rawRows) < 2) {
            return $this->response->setStatusCode(422)->setJSON([
                'status' => 'error',
                'message' => 'Data minimal harus memiliki 1 baris Header dan 1 baris Data Tim.',
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash(),
            ]);
        }

        $headers = array_shift($rawRows);
        $autoMap = $this->guessSmartColumnMapping($headers);

        return $this->response->setJSON([
            'status' => 'success',
            'headers' => $headers,
            'preview_rows' => array_slice($rawRows, 0, 10),
            'all_rows' => $rawRows,
            'total_rows' => count($rawRows),
            'auto_map' => $autoMap,
            'csrfTokenName' => csrf_token(),
            'csrfHash' => csrf_hash(),
        ]);
    }

    public function processMappedCsv()
    {
        $this->cleanupRosterData();
        $isAjax = $this->request->isAJAX();

        $payload = $this->request->getJSON(true);
        if (!is_array($payload)) {
            $payload = $this->request->getPost();
        }

        $tournamentId = $this->normalizeTournamentId($payload['tournament_id'] ?? null) ?? 0;
        if ($tournamentId <= 0) {
            return $this->teamErrorResponse('Pilih Tournament tujuan terlebih dahulu.', $isAjax);
        }

        $stage = strtolower(trim((string) ($payload['stage'] ?? 'kualifikasi')));
        if (!in_array($stage, ['kualifikasi', 'semifinal', 'grandfinal', 'sandbox'], true)) {
            $stage = 'kualifikasi';
        }

        $importMode = trim((string) ($payload['import_mode'] ?? 'smart_overflow')); // smart_overflow | specific_pot | unassigned | sandbox
        $explicitPotId = $this->normalizePotId($payload['pot_id'] ?? null);
        $rows = $payload['rows'] ?? [];
        $mapping = $payload['mapping'] ?? [];

        if (!is_array($rows) || $rows === []) {
            return $this->teamErrorResponse('Tidak ada baris data tim untuk diimport.', $isAjax);
        }

        $colTeamName = isset($mapping['team_name']) ? (int) $mapping['team_name'] : -1;
        $colPotName = isset($mapping['pot_name']) ? (int) $mapping['pot_name'] : -1;
        $colStage = isset($mapping['stage']) ? (int) $mapping['stage'] : -1;
        $colMembers = isset($mapping['members']) && is_array($mapping['members'])
            ? array_map('intval', $mapping['members'])
            : [];

        if ($colTeamName < 0) {
            return $this->teamErrorResponse('Kolom "Nama Tim" wajib dipetakan terlebih dahulu.', $isAjax);
        }

        $db = db_connect();
        $insertedCount = 0;
        $updatedCount = 0;
        $skippedCount = 0;
        $potReport = [];

        try {
            $db->transException(true)->transStart();

            foreach ($rows as $row) {
                if (!is_array($row)) {
                    continue;
                }

                $teamName = $this->cleanRosterText((string) ($row[$colTeamName] ?? ''), 150);
                if ($teamName === '') {
                    $skippedCount++;
                    continue;
                }

                $rowPotName = ($colPotName >= 0 && isset($row[$colPotName])) ? $this->cleanRosterText((string) $row[$colPotName], 100) : '';
                $rowStage = ($colStage >= 0 && isset($row[$colStage])) ? strtolower(trim((string) $row[$colStage])) : $stage;
                $rowStage = str_replace([' ', '_', '-'], '', $rowStage);
                if (!in_array($rowStage, ['kualifikasi', 'semifinal', 'grandfinal', 'sandbox'], true)) {
                    $rowStage = $stage;
                }

                // Kumpulkan daftar anggota roster dari kolom yang dicentang user
                $memberChunks = [];
                foreach ($colMembers as $mIdx) {
                    if ($mIdx >= 0 && !empty($row[$mIdx])) {
                        $memberChunks[] = (string) $row[$mIdx];
                    }
                }
                $memberText = implode(', ', $memberChunks);

                // Tentukan penempatan Pot menggunakan Smart Pot Allocator
                $targetPotId = null;
                $isSandbox = 0;

                if ($importMode === 'sandbox' || $rowStage === 'sandbox') {
                    $isSandbox = 1;
                    $potLabel = 'Sandbox';
                } elseif ($importMode === 'unassigned') {
                    $targetPotId = null;
                    $potLabel = 'Unassigned';
                } else {
                    $reqPot = ($importMode === 'specific_pot' && $explicitPotId !== null) ? $explicitPotId : null;
                    $alloc = $this->resolveTargetPotWithAutoOverflow(
                        $tournamentId,
                        $rowStage,
                        $reqPot,
                        $rowPotName,
                        null,
                        true
                    );

                    if (!$alloc['ok']) {
                        throw new \RuntimeException($alloc['message']);
                    }

                    $targetPotId = $alloc['pot_id'];
                    $isSandbox = (int) ($alloc['is_sandbox'] ?? 0);
                    $potLabel = $alloc['pot']['name'] ?? ($isSandbox ? 'Sandbox' : 'Unassigned');
                }

                $potReport[$potLabel] = ($potReport[$potLabel] ?? 0) + 1;

                // Cek apakah tim sudah ada di scope yang sama -> jika ada, sinkronisasi anggotanya tanpa duplikasi
                $duplicate = $isSandbox === 0
                    ? $this->findDuplicateTeamInScope($teamName, $targetPotId, null, $tournamentId)
                    : null;

                if ($duplicate !== null) {
                    $dupId = (int) $duplicate['id'];
                    if (trim($memberText) !== '') {
                        $this->syncMembersFromText($dupId, $memberText);
                    }
                    $updatedCount++;
                    continue;
                }

                $nextOrder = $targetPotId !== null
                    ? $this->teamModel->where('pot_id', $targetPotId)->countAllResults() + 1
                    : $this->teamModel->where('pot_id IS NULL', null, false)->countAllResults() + 1;

                $insData = [
                    'tournament_id' => $tournamentId,
                    'pot_id' => $targetPotId,
                    'name' => $teamName,
                    'sort_order' => $nextOrder,
                ];
                if ($this->hasSandboxCol) {
                    $insData['is_sandbox'] = $isSandbox;
                }

                $newTeamId = (int) $this->teamModel->insert($insData, true);
                if (trim($memberText) !== '') {
                    $this->syncMembersFromText($newTeamId, $memberText);
                }

                $insertedCount++;
            }

            $db->transComplete();
        } catch (\Throwable $e) {
            if ($db->transStatus() !== false) {
                $db->transRollback();
            }
            return $this->teamErrorResponse('Gagal mengimpor data: ' . $e->getMessage(), $isAjax);
        }

        $reportParts = [];
        foreach ($potReport as $pName => $cnt) {
            $reportParts[] = "{$pName}: {$cnt} tim";
        }
        $summaryMsg = "Import selesai! {$insertedCount} tim baru ditambahkan, {$updatedCount} tim diperbarui"
            . ($skippedCount > 0 ? ", {$skippedCount} baris kosong dilewati" : '')
            . ($reportParts !== [] ? ' (' . implode(', ', $reportParts) . ').' : '.');

        return $this->response->setJSON([
            'status' => 'success',
            'message' => $summaryMsg,
            'insertedCount' => $insertedCount,
            'updatedCount' => $updatedCount,
            'skippedCount' => $skippedCount,
            'potReport' => $potReport,
            'redirectUrl' => site_url('teams/roster?tab=roster&tournament_id=' . $tournamentId),
            'csrfTokenName' => csrf_token(),
            'csrfHash' => csrf_hash(),
        ]);
    }

    private function detectCsvDelimiter(string $sampleLine): string
    {
        $counts = [
            "\t" => substr_count($sampleLine, "\t"),
            ';' => substr_count($sampleLine, ';'),
            ',' => substr_count($sampleLine, ','),
        ];
        arsort($counts);
        return (string) key($counts);
    }

    private function hasNonEmptyCell(array $row): bool
    {
        foreach ($row as $cell) {
            if (trim((string) $cell) !== '') {
                return true;
            }
        }
        return false;
    }

    private function guessSmartColumnMapping(array $headers): array
    {
        $map = [
            'team_name' => -1,
            'pot_name' => -1,
            'stage' => -1,
            'members' => [],
        ];

        foreach ($headers as $idx => $header) {
            $norm = strtolower(trim((string) $header));
            if ($map['team_name'] === -1 && preg_match('/(nama\s*tim|nama\s*team|team\s*name|nama_team|squad|^tim$|^team$)/i', $norm)) {
                $map['team_name'] = $idx;
            } elseif ($map['pot_name'] === -1 && preg_match('/(^pot$|nama\s*pot|pot_name|grup|group|kloter)/i', $norm)) {
                $map['pot_name'] = $idx;
            } elseif ($map['stage'] === -1 && preg_match('/(stage|tahap|babak|fase)/i', $norm)) {
                $map['stage'] = $idx;
            } elseif (preg_match('/(player|pemain|anggota|member|roster|nick|ign|kapten|captain|leader)/i', $norm)) {
                $map['members'][] = $idx;
            }
        }

        return $map;
    }
}