<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

service('auth')->routes($routes);

$routes->setDefaultNamespace('App\Controllers');
$routes->setDefaultController('Dashboard');
$routes->setDefaultMethod('index');

$routes->setAutoRoute(false);

$sessionFilters = ['filter' => ['session', 'idle']];
$adminFilters = ['filter' => ['session', 'idle', 'group:admin']];

/*
|--------------------------------------------------------------------------
| Dashboard
|--------------------------------------------------------------------------
*/

$routes->get('/', 'Dashboard::index', $sessionFilters);
$routes->get('dashboard', 'Dashboard::index', $sessionFilters);
$routes->get('keep-alive', 'Dashboard::keepAlive', $sessionFilters);
$routes->get('session/keep-alive', 'Dashboard::keepAlive', $sessionFilters);

/*
|--------------------------------------------------------------------------
| Tournament (Mendukung pola /store dan RESTful)
|--------------------------------------------------------------------------
*/

$routes->get('tournaments', 'TournamentController::index', $sessionFilters);
$routes->get('tournaments/create', 'TournamentController::create', $adminFilters);

$routes->post('tournaments', 'TournamentController::store', $adminFilters);
$routes->post('tournaments/store', 'TournamentController::store', $adminFilters);
$routes->post('tournaments/create', 'TournamentController::store', $adminFilters);

$routes->get('tournaments/edit/(:num)', 'TournamentController::edit/$1', $adminFilters);
$routes->get('tournaments/(:num)/edit', 'TournamentController::edit/$1', $adminFilters);

$routes->post('tournaments/update/(:num)', 'TournamentController::update/$1', $adminFilters);
$routes->post('tournaments/(:num)/update', 'TournamentController::update/$1', $adminFilters);

$routes->post('tournaments/update-status/(:num)', 'TournamentController::updateStatus/$1', $adminFilters);
$routes->post('tournaments/(:num)/update-status', 'TournamentController::updateStatus/$1', $adminFilters);

$routes->post('tournaments/delete/(:num)', 'TournamentController::delete/$1', $adminFilters);
$routes->post('tournaments/(:num)/delete', 'TournamentController::delete/$1', $adminFilters);

/*
|--------------------------------------------------------------------------
| Pot (Mendukung pola /store dan RESTful)
|--------------------------------------------------------------------------
*/

$routes->get('tournaments/(:num)/pots', 'PotController::index/$1', $sessionFilters);

$routes->post('pots', 'PotController::store', $adminFilters);
$routes->post('pots/store', 'PotController::store', $adminFilters);
$routes->post('pots/create', 'PotController::store', $adminFilters);

$routes->post('pots/update/(:num)', 'PotController::update/$1', $adminFilters);
$routes->post('pots/(:num)/update', 'PotController::update/$1', $adminFilters);

$routes->post('pots/update-images/(:num)', 'PotController::updateImages/$1', $adminFilters);
$routes->post('pots/(:num)/update-images', 'PotController::updateImages/$1', $adminFilters);

$routes->post('pots/advance/(:num)', 'PotController::advanceSelected/$1', $adminFilters);
$routes->post('pots/(:num)/advance', 'PotController::advanceSelected/$1', $adminFilters);
$routes->post('pots/advance-selected', 'PotController::advanceSelected', $adminFilters);

$routes->post('pots/delete/(:num)', 'PotController::delete/$1', $adminFilters);
$routes->post('pots/(:num)/delete', 'PotController::delete/$1', $adminFilters);

/*
|--------------------------------------------------------------------------
| Scores
|--------------------------------------------------------------------------
*/

$routes->get('pots/(:num)/scores', 'ScoreController::index/$1', $sessionFilters);

$routes->post('scores/save-bulk', 'ScoreController::saveBulk', $adminFilters);
$routes->post('index.php/scores/save-bulk', 'ScoreController::saveBulk', $adminFilters);

$routes->post('scores/save', 'ScoreController::save', $adminFilters);
$routes->post('index.php/scores/save', 'ScoreController::save', $adminFilters);

/*
|--------------------------------------------------------------------------
| Teams & Drag Manager (Mendukung semua variasi endpoint form & AJAX)
|--------------------------------------------------------------------------
*/

// --- Teams & Roster Hub ---
$routes->get('teams', 'TeamController::rosterIndex', $sessionFilters);
$routes->get('teams/roster', 'TeamController::rosterIndex', $sessionFilters);

$routes->get('teams/export-template', 'TeamController::exportTemplate', $sessionFilters);
$routes->get('teams/template/export', 'TeamController::exportTemplate', $sessionFilters);

$routes->get('teams/export-template/csv/(:num)', 'TeamController::downloadTemplateCsv/$1', $sessionFilters);
$routes->get('teams/template/csv/(:num)', 'TeamController::downloadTemplateCsv/$1', $sessionFilters);

$routes->get('teams/manager-data', 'TeamController::managerData', $sessionFilters);

$routes->get('teams/drag-manager', 'TeamController::dragManager', $adminFilters);
$routes->post('teams/drag-manager/save', 'TeamController::saveDragManager', $adminFilters);
$routes->post('index.php/teams/drag-manager/save', 'TeamController::saveDragManager', $adminFilters);

$routes->get('teams/pot/(:num)', 'TeamController::index/$1', $sessionFilters);

// Create Team
$routes->post('teams', 'TeamController::store', $adminFilters);
$routes->post('teams/store', 'TeamController::store', $adminFilters);
$routes->post('teams/create', 'TeamController::store', $adminFilters);
$routes->post('teams/roster', 'TeamController::store', $adminFilters);

// Update Team (Single & Bulk)
$routes->post('teams/update/(:num)', 'TeamController::update/$1', $adminFilters);
$routes->post('teams/(:num)/update', 'TeamController::update/$1', $adminFilters);
$routes->post('teams/bulk-update', 'TeamController::bulkUpdate', $adminFilters);
$routes->post('teams/roster/bulk-update', 'TeamController::bulkUpdate', $adminFilters);
$routes->post('teams/bulk-action', 'TeamController::bulkAction', $adminFilters);

// Delete & Detach Team
$routes->post('teams/delete/(:num)', 'TeamController::delete/$1', $adminFilters);
$routes->post('teams/(:num)/delete', 'TeamController::delete/$1', $adminFilters);
$routes->post('teams/detach/(:num)', 'TeamController::detach/$1', $adminFilters);
$routes->post('teams/(:num)/detach', 'TeamController::detach/$1', $adminFilters);

/*
|--------------------------------------------------------------------------
| Import
|--------------------------------------------------------------------------
*/

// --- 1. Smart CSV & Spreadsheet Import Engine ---
$routes->get('imports/raw-csv', 'TeamController::rawCsvView', $adminFilters);
$routes->post('imports/raw-csv/preview', 'TeamController::previewMappedCsv', $adminFilters);
$routes->post('imports/raw-csv/process', 'TeamController::processMappedCsv', $adminFilters);

// --- 2. Standard Spreadsheet / Google Forms Import ---
$routes->get('imports/teams', 'ImportController::teams', $adminFilters);
$routes->post('imports/teams', 'ImportController::storeTeams', $adminFilters);
$routes->get('import/teams', 'ImportController::teams', $adminFilters);
$routes->post('import/teams', 'ImportController::storeTeams', $adminFilters);

/*
|--------------------------------------------------------------------------
| Leaderboard
|--------------------------------------------------------------------------
*/

$routes->get('leaderboard/pot/(:num)', 'LeaderboardController::pot/$1', $sessionFilters);
$routes->get('leaderboard/(:num)', 'LeaderboardController::pot/$1', $sessionFilters);

/*
|--------------------------------------------------------------------------
| Home & API
|--------------------------------------------------------------------------
*/

$routes->get('home', 'Home::index');

$routes->group('api', ['namespace' => 'App\Controllers\Api', 'filter' => ['session']], static function ($routes) {
    $routes->get('leaderboard/(:segment)', 'LeaderboardController::show/$1');
});

$routes->set404Override();