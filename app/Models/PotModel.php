<?php



namespace App\Models;



use CodeIgniter\Model;



class PotModel extends Model
{
    protected $table         = 'pots';
    protected $primaryKey    = 'id';
    protected $returnType    = 'array';
    protected $allowedFields =['tournament_id',
                                'name',
                                'sort_order',
                                'reference_image_1',
                                'reference_image_2' ,
                                'stage' ,
                                'game_count' ,
                                'max_teams'];
    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';
}
