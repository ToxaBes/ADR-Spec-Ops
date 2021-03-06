private ["_activeTimer", "_inactiveTimer"];

// Variables
_activeTimer = 600;										// How long will it remain active for, in seconds. 300 = 5 minutes
_inactiveTimer = 600;									// Shortest time between activations, in seconds. 900 = 15 minutes

_null = [] spawn {
    _pos = getPosASL loudspeaker;
    _z = (_pos select 2) + 5;
    _pos set [2, _z];
	for "_i" from 0 to 6 do {
        playSound3D ["A3\Sounds_F\sfx\alarm_BLUFOR.wss", loudspeaker, false, _pos, 10, 1, 300];
        sleep 4;
	};
};

// Restrict use of this action while procedure is in progress
BASEDEFENSE_SWITCH = true; publicVariable "BASEDEFENSE_SWITCH";

hqSideChat = "Защита базы включена, турели активированы!"; publicVariable "hqSideChat"; [WEST, "HQ"] sideChat hqSideChat;
sleep 1;

// put turrets on correct places
baseTurret1 setPos [6926.12,7280.07,4.34];
baseTurret2 setPos [6848.06,7205.3,4.34];
baseTurret3 setPos [6760.31,7360.26,10.08];
baseTurret4 setPos [6768.26,7352.23,10.12];
baseTurret5 setPos [6880.16,7296.58,2.22];
baseTurret6 setPos [6959.57,7111.08,4.34];
baseTurret7 setPos [6994.47,7165.98,4.62];
baseTurret8 setPos [6733.68,7345.93,0];
baseTurret9 setPos [6924.81,7298,4.36];
baseTurret10 setPos [6924.15,7300.74,4.35];
baseTurret11 setPos [6846.32,7207.59,4.32];
baseTurret12 setPos [6988.93,7133.72,10.17];
baseTurret13 setPos [6689.41,6964.37,4.44];
baseTurret14 setPos [6712.04,7313.16,4.26];
baseTurret15 setPos [6710.25,7315.67,4.39];

_turrets = [baseTurret1, baseTurret2, baseTurret3, baseTurret4, baseTurret5, baseTurret6, baseTurret7, baseTurret8, baseTurret9, baseTurret10, 
baseTurret11, baseTurret12, baseTurret13, baseTurret14, baseTurret15];

_grpTurret = createGroup west;
{
    _x setvehicleammo 1;
    deleteVehicle (gunner _x);   
    "B_support_MG_F" createUnit [getposATL _x, _grpTurret, "currentGunner = this"];
    currentGunner moveInGunner _x;
} foreach _turrets;
_grpTurret setBehaviour "COMBAT";
_grpTurret setCombatMode "RED";
[(units _grpTurret)] call QS_fnc_setSkill4;

//---------- Active time
sleep _activeTimer;

//---------- Delete after use
{
    deleteVehicle _x;
} forEach (units _grpTurret);
deleteGroup _grpTurret;
sleep 2;
_grpTurret = createGroup west;
_number = 1;
{
    _x setvehicleammo 1;
    deleteVehicle (gunner _x);   
    if (_number % 2 == 0) then {
    	"B_support_MG_F" createUnit [getposATL _x, _grpTurret, "currentGunner = this"];
        currentGunner moveInGunner _x;
    };    
    _number = _number + 1;
} foreach _turrets;
_grpTurret setBehaviour "COMBAT";
_grpTurret setCombatMode "RED";
[(units _grpTurret)] call QS_fnc_setSkill4;

if (BLUFOR_BASE_SCORE > 27) then {
    _posSpawn = [6845, 7295, (random 15) + 15];
    _uavData = [_posSpawn, 90, "B_UAV_01_F", WEST] call BIS_fnc_spawnVehicle;
    base_darter2 = _uavData select 0;
    _uavGroup = _uavData select 2;
    base_darter2 addEventHandler ['incomingMissile', {_this spawn QS_fnc_HandleIncomingMissile}];
    base_darter2 addWeapon ("LMG_Mk200_F");
    base_darter2 addMagazine ("200Rnd_65x39_cased_Box_Tracer");
    base_darter2 setVariable ["VCOM_NOAI", true];
    _uavGroup setVariable ["zbe_cacheDisabled", true];
    _uavGroup setBehaviour "SAFE";
    _uavGroup setCombatMode "RED";
    [(units _uavGroup)] call QS_fnc_setSkill3;
    [_uavGroup, _posSpawn, (40 + (random 80))] call BIS_fnc_taskPatrol;
    _uavGroup deleteGroupWhenEmpty true;
    [base_darter2] spawn {
        _u = _this select 0;
        while {alive _u} do {
            _u setFuel 1;
            _u setVehicleAmmo 1;
            sleep 600;
        };        
    };
    [base_darter2] spawn {
        _u = _this select 0;
        while {alive _u} do {
            waitUntil {isUAVConnected _u};
            _ctrl = UAVControl _u;
            _unit = _ctrl select 0;
            _unit connectTerminalToUAV objNull;
            "Доступ к автоматической системе охраны запрещен!" remoteExec ["hint", _unit];                 
        };
    };
};

sleep 5;
_enemies = nearestObjects [(getMarkerPos "respawn_west"), ["SoldierGB", "SoldierEB"], 250];
if (count _enemies > 0) then {
    {
        _grpTurret reveal [_x, 1.5];
    } forEach _enemies;
};

//---------- Cool-off period before next use
sleep _inactiveTimer;
if (alive base_darter2) then {
    {
        deleteVehicle _x;
    } forEach (crew base_darter2);
    deleteVehicle base_darter2;
};
BASEDEFENSE_SWITCH = nil; publicVariable "BASEDEFENSE_SWITCH";
hqSideChat = "Защита базы доступна."; publicVariable "hqSideChat"; [WEST, "HQ"] sideChat hqSideChat;