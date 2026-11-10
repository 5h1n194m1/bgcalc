<?php

namespace App\Models;

use CodeIgniter\Model;

class TournamentModel extends Model
{
    public const STATUS_BELUM_MULAI = 'belum_mulai';
    public const STATUS_START = 'start';
    public const STATUS_SELESAI = 'selesai';

    protected $table            = 'tournaments';
    protected $primaryKey       = 'id';
    protected $returnType       = 'array';
    protected $useAutoIncrement = true;
    
    // Field yang diizinkan untuk insert/update
    protected $allowedFields    = [
        'name', 
        'status', 
        'default_game_count', 
        'kill_points', 
        'max_teams_per_pot', 
        'point_system',
        'custom_placement_points' // <-- TAMBAHAN BARU
    ];
    
    protected $useTimestamps    = true;
    protected $createdField     = 'created_at';
    protected $updatedField     = 'updated_at';

    public static function statusOptions(): array
    {
        return [
            self::STATUS_BELUM_MULAI => 'Standby',
            self::STATUS_START       => 'Live',
            self::STATUS_SELESAI     => 'Finished',
        ];
    }
}