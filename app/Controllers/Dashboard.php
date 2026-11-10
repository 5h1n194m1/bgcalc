<?php

namespace App\Controllers;

use CodeIgniter\HTTP\ResponseInterface;
use App\Models\TournamentModel;

class Dashboard extends BaseController
{
    public function index(): string
    {
        $tournaments = (new TournamentModel())
            ->select('tournaments.*, 
                (SELECT COUNT(*) FROM pots WHERE pots.tournament_id = tournaments.id) AS pot_count, 
                (SELECT COUNT(*) FROM teams WHERE teams.tournament_id = tournaments.id) AS team_count')
            ->orderBy('tournaments.created_at', 'DESC')
            ->findAll();

        return view('dashboard/index', [
            'pageTitle'     => 'Dashboard',
            'tournaments'   => $tournaments,
            'statusOptions' => TournamentModel::statusOptions(),
        ]);
    }

    public function keepAlive(): ResponseInterface
    {
        if (! auth()->loggedIn()) {
            return $this->response->setStatusCode(401)->setJSON([
                'status' => 'error',
                'message' => 'Sesi sudah berakhir.',
            ]);
        }

        session()->set('lastActivityAt', time());

        return $this->response->setJSON([
            'status' => 'success',
            'message' => 'Sesi diperpanjang.',
            'csrfTokenName' => csrf_token(),
            'csrfHash' => csrf_hash(),
        ]);
    }
}
