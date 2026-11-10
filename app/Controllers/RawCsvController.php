<?php

namespace App\Controllers;

use App\Models\TeamModel;
use App\Models\TeamMemberModel;
use App\Models\TournamentModel;
use App\Models\PotModel;

class RawCsvController extends BaseController
{
    public function index()
    {
        $tournamentModel = new TournamentModel();
        $potModel = new PotModel();

        $data = [
            'pageTitle'   => 'Raw Google Forms CSV Importer',
            'tournaments' => $tournamentModel->orderBy('id', 'DESC')->findAll(),
            'pots'        => $potModel->findAll()
        ];

        return view('imports/raw_csv', $data);
    }

    public function process()
    {
        if (!$this->request->isAJAX()) {
            return $this->response->setJSON(['status' => 'error', 'message' => 'Invalid request']);
        }

        $json = $this->request->getJSON();
        if (!$json || empty($json->data)) {
            return $this->response->setJSON([
                'status' => 'error', 
                'message' => 'No data received',
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash()
            ]);
        }

        $tournamentId = $json->tournament_id ?? null;
        $potId = $json->pot_id ?? null;

        if (empty($tournamentId)) {
            return $this->response->setJSON([
                'status' => 'error',
                'message' => 'Tournament is required',
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash()
            ]);
        }

        $teamModel = new TeamModel();
        $teamMemberModel = new TeamMemberModel();

        $db = db_connect();
        
        try {
            $db->transException(true)->transStart();

            $nextSortOrder = 1;
            if ($potId) {
                $nextSortOrder = $teamModel->where('pot_id', $potId)->countAllResults() + 1;
            } else {
                $nextSortOrder = $teamModel->where('pot_id IS NULL', null, false)->countAllResults() + 1;
            }

            foreach ($json->data as $item) {
                $teamName = trim($item->team_name ?? '');
                if (empty($teamName)) continue;

                $teamId = $teamModel->insert([
                    'tournament_id' => $tournamentId,
                    'pot_id'        => $potId ?: null,
                    'name'          => $teamName,
                    'sort_order'    => $nextSortOrder++
                ], true);

                if (!empty($item->players) && is_array($item->players)) {
                    foreach ($item->players as $player) {
                        $playerName = trim($player ?? '');
                        if (empty($playerName)) continue;

                        $teamMemberModel->insert([
                            'team_id'     => $teamId,
                            'player_name' => mb_substr($playerName, 0, 80),
                            'player_role' => null
                        ]);
                    }
                }
            }

            $db->transComplete();

            return $this->response->setJSON([
                'status' => 'success',
                'message' => 'Bulk insert successful',
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash()
            ]);
        } catch (\Throwable $e) {
            if ($db->transStatus() !== false) {
                $db->transRollback();
            }
            return $this->response->setJSON([
                'status' => 'error',
                'message' => 'Database error: ' . $e->getMessage(),
                'csrfTokenName' => csrf_token(),
                'csrfHash' => csrf_hash()
            ]);
        }
    }
}
