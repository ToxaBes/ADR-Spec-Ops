/*
Author:	ToxaBes
Description: Snatch helicopter and return it to the base.
*/

// define some keywords
#define INFANTRY_MISSION "Спецоперация: Угон (техника запрещена)"
#define OUR_SIDE WEST
#define ENEMY_SIDE EAST
#define INFANTRY_FUEL_VEHICLE "O_T_Truck_03_fuel_ghex_F"
#define INFANTRY_AA_VEHICLE "O_T_APC_Tracked_02_AA_ghex_F"
#define INFANTRY_CAMONET_BIG "CamoNet_ghex_big_F"
#define INFANTRY_CAMONET_SMALL "CamoNet_ghex_F"
#define INFANTRY_CAMONET_OPEN "CamoNet_ghex_open_F"
#define INFANTRY_HELI_PILOT "O_T_Helipilot_F"
#define INFANTRY_HELI_CREW "O_T_Helicrew_F"
#define INFANTRY_STATIC "O_HMG_01_high_F"
#define INFANTRY_GUNNERS "O_T_Support_MG_F", "O_T_Support_GMG_F", "O_T_Support_AMG_F"
#define INFANTRY_SOLDIERS "O_T_Engineer_F","O_T_Medic_F","O_T_Recon_Exp_F","O_T_Recon_F","O_T_Recon_JTAC_F","O_T_Recon_LAT_F","O_T_Recon_M_F","O_T_Recon_Medic_F","O_T_Recon_TL_F","O_T_Soldier_AA_F","O_T_Soldier_AR_F","O_T_Soldier_AT_F","O_T_Soldier_Exp_F","O_T_Soldier_F","O_T_Soldier_GL_F","O_T_Soldier_LAT_F","O_T_Soldier_M_F","O_T_Soldier_Repair_F","O_T_Soldier_SL_F","O_T_Soldier_TL_F"

// define private variables
private ["_enemiesArray", "_unitsArray", "_arr", "_cnt", "_targets", "_helicopters", "_position", "_flatPos", "_startPoint", "_briefing", "_campPos", "_camp", "_campFires", "_tentDome", "_campGroup", "_sleepingBags", "_sleepingPositions", "_sleepingPos", "_i", "_bagPos", "_heliPos", "_heliDir", "_heliLand", "_heliData", "_heliType", "_trig", "_boxes", "_n", "_height", "_posInit", "_posSpawn", "_uavData", "_uav", "_uavGroup", "_fuelPos", "_fuelDir", "_fuelNet", "_fuelVeh", "_aaGroup", "_aaPos", "_aaDir", "_aaVeh", "_aa", "_staticGroup", "_bunkers", "_bunkerPos", "_bunkerDir", "_bunkerBag", "_posBlock", "_block", "_bunkerCamonet", "_posATL", "_static", "_singlePositions", "_heliGroup", "_pilotPositions", "_pilotPos", "_crewPos", "_patrolGroup", "_viperGroup", "_dirSign", "_vehMineDir", "_apMineDir", "_c", "_posSign", "_sign", "_mine", "_minePos", "_nearestMines"];

_enemiesArray = [grpNull];
_unitsArray = [];

// Thanks KK for fastest shuffle alghoritm
KK_fnc_arrayShufflePlus = {
    private ["_arr","_cnt"];
    _arr = _this select 0;
    _cnt = count _arr;
    for "_i" from 1 to (_this select 1) do {
        _arr pushBack (_arr deleteAt floor random _cnt);
    };
    _arr
};

// format:
//  [[coords x,y],     [drones], [camp x,y,z],    [heli x,y,dir],     [fuel x,y,dir],     [AA x,y,dir],         [bunkers x,y,dir],
//  [guards x,y,z,dir],                                                                                                                               [pilots x,y,z,dir]]
_targets = [
    [[4126,11691],     [1,2],    [4042,11638,0],  [4160,11721,241],   [3978,11592,145],   [4037,11727,152],     [[3958,11718.7,238],[4076.9,11867.5,351],[4181.9,11683.8,143]],
    [[4120.3,11664.1,0,287],[4066.1,11749,0.1,258],[4253.4,11773.6,0,340],[4141.5,11849.6,0.1,22],[4161.4,11688.1,0.1,13],[4218.4,11774.7,0.1,277]],  [[4178,11697,0.1,0],[4187.6,11695.7,0.1,227]]],

    [[3869,13919],     [1,2],    [3828,13880,0],  [4005,13886,9],     [3771,14036,241],   [3790.8,14009.7,98],  [[3965.2,13770.7,127],[3784.6,13843.5,227],[3950.5,13941,29]],
    [[3990.5,13867.7,0.1,199],[3899.1,13872,0.1,179],[3842.3,13911,0.1,281],[3761.7,14013.1,0.1,281],[3802,14045.8,0.1,98],[3889.7,13894.7,0.1,78]],  [[3984.2,13893.6,0.1,78],[3783.9,14000.5,0.1,145]]],

    [[2653,9298],      [1,2],    [2702,9333,0],   [2697,9266,233],    [2628,9276.4,357],  [2665,9342.4,0],      [[2643.8,9201.7,203],[2691.9,9223.8,136],[2658,9361.4,16]],
    [[2635.5,9358.9,0.1,319],[2626.4,9298.2,0.1,209],[2666,9225,0.1,179],[2673.5,9267.2,0.1,72],[2684.7,9341.7,0.1,35],[2653.3,9259.5,0.1,0]],        [[2649.3,9328.4,0.1,108],[2672,9341,0.1,252]]]
];

// format: ["heli name",                 "removed weapon1",           "removed magazine1",                       "added weapon1",                "added magazine1",                       "removed weapon2",            "removed magazine2",              "added weapon2",                "added magazine2"]
_helicopters = [
           ["O_Heli_Attack_02_black_F",   "rockets_Skyfire",           "38Rnd_80mm_rockets",                      "missiles_ASRAAM",              "2Rnd_AAA_missiles"],
           ["B_Heli_Light_01_armed_F",    "M134_minigun",              "5000Rnd_762x51_Belt",                     "missiles_ASRAAM",              "2Rnd_AAA_missiles"],
           ["B_Heli_Light_01_armed_F",    "M134_minigun",              "5000Rnd_762x51_Belt",                     "missiles_ASRAAM",              "2Rnd_AAA_missiles",                    "missiles_DAR",              "24Rnd_missiles",                 "Gatling_30mm_Plane_CAS_01_F",  "1000Rnd_Gatling_30mm_Plane_CAS_01_F"],
           ["B_Heli_Attack_01_F",         "missiles_DAGR",             "4Rnd_AAA_missiles",                       "missiles_ASRAAM",              "2Rnd_AAA_missiles",                    "gatling_20mm",              "1000Rnd_20mm_shells",            "Gatling_30mm_Plane_CAS_01_F",  "1000Rnd_Gatling_30mm_Plane_CAS_01_F"],
           ["I_Heli_light_03_F",          "M134_minigun",              "5000Rnd_762x51_Yellow_Belt",              "missiles_ASRAAM",              "2Rnd_AAA_missiles",                    "missiles_DAR",              "24Rnd_missiles",                 "missiles_DAGR",                "12Rnd_PG_missiles"],
           ["B_Heli_Transport_01_camo_F", "LMG_Minigun_Transport",     "2000Rnd_65x39_Belt_Tracer_Red",           "Gatling_30mm_Plane_CAS_01_F",  "1000Rnd_Gatling_30mm_Plane_CAS_01_F",  "LMG_Minigun_Transport2",    "2000Rnd_65x39_Belt_Tracer_Red",  "Gatling_30mm_Plane_CAS_01_F",  "1000Rnd_Gatling_30mm_Plane_CAS_01_F"],
           ["B_Heli_Transport_01_F",      "LMG_Minigun_Transport",     "2000Rnd_65x39_Belt_Tracer_Red",           "autocannon_35mm",              "680Rnd_35mm_AA_shells_Tracer_Yellow",  "LMG_Minigun_Transport2",    "2000Rnd_65x39_Belt_Tracer_Red",  "autocannon_35mm",  "680Rnd_35mm_AA_shells_Tracer_Yellow"],
           ["O_Heli_Light_02_F",          "LMG_Minigun_heli",          "2000Rnd_65x39_Belt_Tracer_Green_Splash",  "Cannon_30mm_Plane_CAS_02_F",   "500Rnd_Cannon_30mm_Plane_CAS_02_F"],
           ["O_Heli_Light_02_v2_F",       "LMG_Minigun_heli",          "2000Rnd_65x39_Belt_Tracer_Green_Splash",  "Gatling_30mm_Plane_CAS_01_F",  "1000Rnd_Gatling_30mm_Plane_CAS_01_F"]
];
_helicopters = [_helicopters, 7] call KK_fnc_arrayShufflePlus;

// select correct place for mission
_position = selectRandom _targets;
_flatPos  = _position select 0;

// set zone area
_startPoint = [(_flatPos select 0),(_flatPos select 1),1];
{ _x setMarkerPos _flatPos; } forEach ["sideMarker", "sideCircle"];
"sideCircle" setMarkerSize [200, 200]; publicVariable "sideCircle";
sideMarkerText = [INFANTRY_MISSION, true]; publicVariable "sideMarkerText";
"sideMarker" setMarkerText INFANTRY_MISSION; publicVariable "sideMarker";
SM_SNATCH_FAIL = false; publicVariable "SM_SNATCH_FAIL";
SM_SNATCH_SUCCESS = false; publicVariable "SM_SNATCH_SUCCESS";

// show brief information
_briefing = "<t align='center'><t size='2.2'>Спецоперация</t><br/><t size='1.5' color='#FFC107'>Угон</t><br/>____________________<br/>Неделю назад противник атаковал один из наших складов и захватил экспериментальный вертолет. Сегодня наша разведка обнаружила его на одной из замаскированных баз противника. Командование назначило пехотную спецоперацию.<br/><br/>Ваша задача — выдвинуться в указанный район, захватить вертолет и вернуть его на базу.</t>";
GlobalHint = _briefing; hint parseText GlobalHint; publicVariable "GlobalHint";
showNotification = ["NewSpecMission", "Угон"]; publicVariable "showNotification";
sideMissionUp = true; publicVariable "sideMissionUp";

// spawn camp
_campPos = _position select 2;
_camp = [_campPos, ENEMY_SIDE, (configfile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "Camps" >> "CampC")] call BIS_fnc_spawnGroup;
_campFires = nearestObjects [_campPos, ["Land_Campfire_F", "Campfire_burning_F"], 5];
{
    _x inflame true;
} forEach _campFires;
_unitsArray pushBack _camp;
for "_x" from 1 to 6 do {
    _tentDome = createVehicle ["Land_TentDome_F", _campPos, [], 10, "NONE"];
    _unitsArray pushBack _tentDome;
    _tentDome = nil;
};

// camp guards
_campGroup = createGroup ENEMY_SIDE;
_sleepingBags = nearestObjects [_campPos, ["Land_Sleeping_bag_F", "Land_Sleeping_bag_brown_F"], 10];
_sleepingPositions = [_sleepingBags, 7] call KK_fnc_arrayShufflePlus;
for "_i" from 0 to 2 do {
    _sleepingPos = _sleepingPositions select _i;
    _bagPos = [(getPos _sleepingPos) select 0, (getPos _sleepingPos) select 1, 0.1];
    "O_T_Soldier_F" createUnit [[10,10,10], _campGroup, "currentGuard = this"];
    currentGuard allowDamage false;
    currentGuard setPos _bagPos;
    currentGuard setDir ([currentGuard, _campPos] call BIS_fnc_dirTo);
    currentGuard allowDamage true;
    [currentGuard, "SIT_LOW", "FULL", {!isNull (currentGuard findNearestEnemy (getPos currentGuard)) || lifestate currentGuard == "INJURED"}, "COMBAT"] call BIS_fnc_ambientAnimCombat;
};
_campGroup setBehaviour "SAFE";
_campGroup setCombatMode "RED";
_enemiesArray pushBack _campGroup;

// spawn heli
_heliPos =  [(_position select 3) select 0, (_position select 3) select 1, 0];
_heliDir = (_position select 3) select 2;
_heliLand = createVehicle ["Land_HelipadSquare_F", _heliPos, [], 0, "CAN_COLLIDE"];
_heliLand setDir (_heliDir + 180);
_unitsArray pushBack _heliLand;
_heliData = selectRandom _helicopters;
_heliType = _heliData select 0;
heliSnatch = createVehicle [_heliType, _heliPos, [], 0, "NONE"];
heliSnatch setDir _heliDir;
heliSnatch addMPEventHandler ["MPKilled",
    {
        if (isServer) then {
            SM_SNATCH_FAIL = true; publicVariable "SM_SNATCH_FAIL";
        };
    }
];

// make heli a bit special
heliSnatch setFuel 0.005;
heliSnatch setVehicleAmmo 0;
clearMagazineCargo heliSnatch;
heliSnatch removeWeapon (_heliData select 1);
heliSnatch removeMagazine (_heliData select 2);
heliSnatch addweapon (_heliData select 3);
heliSnatch addMagazine (_heliData select 4);
if (count (_heliData) > 8) then {
    heliSnatch removeWeapon (_heliData select 5);
    heliSnatch removeMagazine (_heliData select 6);
    heliSnatch addweapon (_heliData select 7);
    heliSnatch addMagazine (_heliData select 8);
    if (_heliType == "B_Heli_Transport_01_camo_F" || _heliType == "B_Heli_Transport_01_F") then {
       heliSnatch removeWeaponTurret [_heliData select 5, [2]];
       heliSnatch removeMagazinesTurret [_heliData select 6, [2]];
       heliSnatch addWeaponTurret [_heliData select 7, [2]];
       heliSnatch addMagazineTurret [_heliData select 8, [2]];
    };
};
if (_heliType == "B_Heli_Light_01_armed_F") then {
    heliSnatch addweapon "CMFlareLauncher";
    heliSnatch addMagazine "168Rnd_CMFlare_Chaff_Magazine";
};


// set trigger for success heli out
_trig = createTrigger ["EmptyDetector", _flatPos, false];
_trig setTriggerArea [1000, 1000, 0, false];
_trig setTriggerActivation ["ANY", "PRESENT", false];
_trig setTriggerStatements ["this && ((alive heliSnatch) && !(heliSnatch in thisList))", "SM_SNATCH_SUCCESS = true; publicVariable ""SM_SNATCH_SUCCESS""; heliSnatch removeAllMPEventHandlers ""MPKilled"";", ""];

// spawn few mil boxes
for "_x" from 1 to 2 do {
    _boxes = createVehicle ["Land_Pallet_MilBoxes_F", _heliPos, [], 4, "NONE"];
    _boxes allowDamage false;
    _unitsArray pushBack _boxes;
};

// spawn patrolling drones
_n = selectRandom (_position select 1);
for "_i" from 1 to _n do {
    _height = (random 20) + 15;
    _posInit = [_campPos, 1, 100, 2, 1, 1, 0, [], [_campPos]] call BIS_fnc_findSafePos;
    _posSpawn = [_posInit select 0, _posInit select 1, _height];
    _uavData = [_posSpawn, 90, "B_UAV_01_F", ENEMY_SIDE] call BIS_fnc_spawnVehicle;
    _uav = _uavData select 0;
    _uavGroup = _uavData select 2;
    _uav addWeapon ("LMG_Mk200_F");
    _uav addMagazine ("200Rnd_65x39_cased_Box_Tracer");
    _uavGroup setBehaviour "SAFE";
    _uavGroup setCombatMode "RED";
    [(units _uavGroup)] call QS_fnc_setSkill2;
    [_uavGroup, _posSpawn, (40 + (random 80))] call BIS_fnc_taskPatrol;
    _unitsArray pushBack _uav;
    _enemiesArray pushBack _uavGroup;
};

// spawn fuel vehicle
_fuelPos =  [(_position select 4) select 0, (_position select 4) select 1, 0];
_fuelDir = (_position select 4) select 2;
_fuelNet = createVehicle [INFANTRY_CAMONET_BIG, _fuelPos, [], 0, "CAN_COLLIDE"];
_fuelNet setDir _fuelDir;
_unitsArray pushBack _fuelNet;
_fuelVeh = createVehicle [INFANTRY_FUEL_VEHICLE, _fuelPos, [], 0, "CAN_COLLIDE"];
_fuelVeh setDir _fuelDir;

_unitsArray pushBack _fuelVeh;

// spawn AA vehicle
_aaGroup =  createGroup ENEMY_SIDE;
_aaPos =  [(_position select 5) select 0, (_position select 5) select 1, 0];
_aaDir = (_position select 5) select 2;
_aaVeh = [_aaPos, _aaDir, INFANTRY_AA_VEHICLE, _aaGroup] call BIS_fnc_spawnVehicle;
_aa = _aaVeh select 0;
_aa setFuel 0;
_aa setVehicleLock "LOCKED";
_aa lock true;
_unitsArray pushBack _aa;
_aaGroup setBehaviour "SAFE";
_aaGroup setCombatMode "RED";
_enemiesArray pushBack _aaGroup;

// spawn bunkers
_staticGroup = createGroup ENEMY_SIDE;
_bunkers = _position select 6;
{

    // bunker
    _bunkerPos =  [_x select 0, _x select 1, 0];
    _bunkerDir = (_x select 2) + 180;
    _bunkerBag = createVehicle ["Land_BagBunker_01_small_green_F", _bunkerPos, [], 0, "CAN_COLLIDE"];
    _bunkerBag setDir _bunkerDir;
    _unitsArray pushBack _bunkerBag;

    // put cargo at back
    _posBlock = [_bunkerBag, 5, _bunkerDir] call BIS_fnc_relPos;
    _block = createVehicle ["Land_Cargo20_military_green_F",[1,1,1],[],0,"CAN_COLLIDE"];
    _block setPos _posBlock;
    _block setDir _bunkerDir;
    _unitsArray pushBack _block;

    // camonet for bunker
    _bunkerCamonet = createVehicle [INFANTRY_CAMONET_SMALL, _bunkerPos, [], 0, "CAN_COLLIDE"];
    _bunkerCamonet setDir _bunkerDir;
    _bunkerCamonet allowDamage false;
    _unitsArray pushBack _bunkerCamonet;

    // camonet for cargo
    _bunkerCamonet = createVehicle [INFANTRY_CAMONET_OPEN, [_posBlock select 0, _posBlock select 1, (_posBlock select 2) + 0.5], [], 0, "CAN_COLLIDE"];
    _bunkerCamonet setDir _bunkerDir;
    _bunkerCamonet allowDamage false;
    _unitsArray pushBack _bunkerCamonet;

    // static weapon
    _posATL = getPos _bunkerBag;
    _posATL = [(_posATL select 0), (_posATL select 1), (_posATL select 2) + 0.2];
    _static = INFANTRY_STATIC createVehicle [10,10,10];
    waitUntil{!isNull _static};
    _static allowDamage false;
    _static setPos _posATL;
    _static setDir _bunkerDir;
    (selectRandom [INFANTRY_GUNNERS]) createUnit [[10,10,10], _staticGroup, "currentGuard = this"];
    currentGuard allowDamage false;
    sleep 0.1;
    currentGuard assignAsGunner _static;
    currentGuard moveInGunner _static;
    _static setVectorUp [0,0,1];
    _static lock 3;
    currentGuard allowDamage true;
    _static allowDamage true;
    _unitsArray pushBack _static;
    _static = nil;
} forEach _bunkers;

// spawn single guards
_singlePositions = _position select 7;
{
    (selectRandom [INFANTRY_SOLDIERS]) createUnit [[10,10,10], _staticGroup, "currentGuard = this"];
    currentGuard setPos [_x select 0, _x select 1, _x select 2];
    currentGuard setDir (_x select 3);
    [currentGuard,"STAND","FULL", {!isNull (currentGuard findNearestEnemy (getPos currentGuard)) || lifestate currentGuard == "INJURED"}, "COMBAT"] call BIS_fnc_ambientAnimCombat;
} forEach _singlePositions;

_staticGroup setBehaviour "SAFE";
_staticGroup setCombatMode "RED";
_enemiesArray pushBack _staticGroup;

// spawn heli pilot and crew
_heliGroup = createGroup ENEMY_SIDE;
_pilotPositions = _position select 8;
_pilotPos = _pilotPositions select 0;
INFANTRY_HELI_PILOT createUnit [[10,10,10], _heliGroup, "currentGuard = this"];
currentGuard setPos [_pilotPos select 0, _pilotPos select 1, _pilotPos select 2];
currentGuard setDir (_pilotPos select 3);
[currentGuard,"STAND","FULL", {!isNull (currentGuard findNearestEnemy (getPos currentGuard)) || lifestate currentGuard == "INJURED"}, "COMBAT"] call BIS_fnc_ambientAnimCombat;
_crewPos = _pilotPositions select 1;
INFANTRY_HELI_CREW createUnit [[10,10,10], _heliGroup, "currentGuard = this"];
currentGuard setPos [_crewPos select 0, _crewPos select 1, _crewPos select 2];
currentGuard setDir (_crewPos select 3);
[currentGuard,"STAND","FULL", {!isNull (currentGuard findNearestEnemy (getPos currentGuard)) || lifestate currentGuard == "INJURED"}, "COMBAT"] call BIS_fnc_ambientAnimCombat;
_heliGroup setBehaviour "SAFE";
_heliGroup setCombatMode "RED";
_enemiesArray pushBack _heliGroup;

// spawn patrol group
_patrolGroup = [_startPoint, ENEMY_SIDE, (configfile >> "CfgGroups" >> "EAST" >> "OPF_T_F" >> "Infantry" >> "O_T_reconPatrol")] call BIS_fnc_spawnGroup;
[_patrolGroup, _startPoint, 100] call QS_fnc_taskMaxDistPatrol;
_patrolGroup setBehaviour "SAFE";
_patrolGroup setCombatMode "RED";
_enemiesArray pushBack _patrolGroup;

// spawn Viper group
if (random 1 > 0.5) then {
    _viperGroup = [_startPoint, ENEMY_SIDE, (configfile >> "CfgGroups" >> "EAST" >> "OPF_T_F" >> "SpecOps" >> "O_T_ViperTeam")] call BIS_fnc_spawnGroup;
    [_viperGroup, _startPoint, 175] call QS_fnc_taskMaxDistPatrol;
    _viperGroup setCombatMode "RED";
    _viperGroup setBehaviour "STEALTH";
    [(units _viperGroup)] call QS_fnc_setSkill4;
    _enemiesArray pushBack _viperGroup;
};

// spawn mines, mines everythere
_dirSign = 180;
_vehMineDir = 180;
_apMineDir = 180;
for "_c" from 0 to 150 do {

    // warning signs/naval bottom mines
    if (_c < 91) then {
        _posSign = [_startPoint, 190, _dirSign] call BIS_fnc_relPos;
        if (!surfaceIsWater _posSign) then {
            _sign = createVehicle ["Land_Sign_Mines_F", [70,70,70], [], 0, "CAN_COLLIDE"];
            waitUntil {alive _sign};
            _sign allowDamage false;
            _sign setDir _dirSign;
            _sign setPos [_posSign select 0, _posSign select 1, 0];
            _pos = getPosATL _sign;
            if (_pos select 2 > 0.2) then {
                _pos = [_pos select 0, _pos select 1, 0];
                _sign setPosATL _pos;
            };
            _unitsArray pushBack _sign;
            _mine = createMine ["APERSBoundingMine", [(_posSign select 0) + random 3, (_posSign select 1) + random 3, 0.1], [], 0];
            waitUntil {alive _mine};
            _pos = getPosATL _mine;
            if (_pos select 2 > 0.2) then {
                _pos = [_pos select 0, _pos select 1, 0];
                _mine setPosATL _pos;
            };
        };
        _dirSign = _dirSign + 4;
    };

    // AT/underwater mines
    _minePos = [_startPoint, 195, _vehMineDir] call BIS_fnc_relPos;
    if (surfaceIsWater _minePos) then {
        _height = random (floor ((getTerrainHeightASL _minePos) * -1));
        _pos = [(_minePos select 0) + random 3, (_minePos select 1) + random 3, (0 - _height)];
        _mine = createMine ["UnderwaterMine", _pos, [], 0];
        _vehMineDir = _vehMineDir + 6;
    } else {
        _mine = createVehicle ["ATMine", [40,40,40], [], 0, "CAN_COLLIDE"];
        _mine setPos [(_minePos select 0) + random 3, (_minePos select 1) + random 3, 0];
        _pos = getPosATL _mine;
        if (_pos select 2 > 0.2) then {
            _pos = [_pos select 0, _pos select 1, 0];
            _mine setPosATL _pos;
        };
        _vehMineDir = _vehMineDir + 3;
    };

    // AP bounding mines
    _minePos = [_startPoint, 200, _apMineDir] call BIS_fnc_relPos;
    if (surfaceIsWater _minePos) then {
        _height = random (floor ((getTerrainHeightASL _minePos) * -1));
        _pos = [(_minePos select 0) + random 3, (_minePos select 1) + random 3, (0 - _height)];
        _mine = createMine ["UnderwaterMine", _pos, [], 0];
        _apMineDir = _apMineDir + 2;
    } else {
        _mine = createMine ["APERSBoundingMine", [(_minePos select 0) + random 6, (_minePos select 1) + random 6, 0.1], [], 0];
        waitUntil {alive _mine};
        _pos = getPosATL _mine;
        if (_pos select 2 > 0.2) then {
            _pos = [_pos select 0, _pos select 1, 0];
            _mine setPosATL _pos;
        };
        _apMineDir = _apMineDir + 4;
    };

};

// set skills
[(units _campGroup)] call QS_fnc_setSkill3;
[(units _aaGroup)] call QS_fnc_setSkill3;
[(units _staticGroup)] call QS_fnc_setSkill3;
[(units _heliGroup)] call QS_fnc_setSkill3;
[(units _patrolGroup)] call QS_fnc_setSkill3;
[_startPoint, 200, ["vehicles", "fire"]] call QS_fnc_addHades;
while { sideMissionUp } do {
    sleep 2;

    // de-briefing
    if (SM_SNATCH_SUCCESS || SM_SNATCH_FAIL) exitWith {
        sideMissionUp = false; publicVariable "sideMissionUp";
        { _x setMarkerPos [-12000,-12000,-12000]; publicVariable _x; } forEach ["sideMarker", "sideCircle"];
        "sideCircle" setMarkerSize [300, 300]; publicVariable "sideCircle";
        "sideMarker" setMarkerText ""; publicVariable "sideMarker";
        if (SM_SNATCH_FAIL) then {
            [true] call QS_fnc_SMhintFAIL;
        } else {
            [true] call QS_fnc_SMhintSUCCESS;
        };

        // delete mines
        {
            if (_x distance _startPoint < 300) then {
               deleteVehicle _x;
            };
        } forEach allMines;
        _nearestMines = nearestObjects [_startPoint, ["ATMine","APERSTripMine","APERSBoundingMine","UnderwaterMinePDM","UnderwaterMine"], 300];
        {
            deleteVehicle _x;
        } forEach _nearestMines;

        sleep 120;
        {
            [_x] call QS_fnc_TBdeleteObjects;
        } forEach [_enemiesArray, _unitsArray];
        [_startPoint, 500] call QS_fnc_DeleteEnemyEAST;
    };
    sleep 3;
};
