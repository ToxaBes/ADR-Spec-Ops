/*
Author:	Quiksilver
Description: Anti-Air Battery. Two stationary IFV-6a Cheetah spawn with an H-barrier ring, at a random position near the AO. To make them more dangerous, they have buffed skill and unlimited ammo.
*/
#define OUR_SIDE WEST
#define ENEMY_SIDE EAST
private ["_basepos", "_loopVar", "_dir", "_PTdir", "_pos", "_barrier", "_unitsArray", "_flatPos", "_accepted", "_position", "_enemiesArray", "_targetList", "_fuzzyPos", "_x", "_briefing", "_enemiesArray", "_unitsArray", "_flatPos1", "_flatPos2", "_flatPos3", "_doTargets", "_targetSelect", "_targetListEnemy"];

// 1. FIND POSITION FOR OBJECTIVE
_basepos = getMarkerPos "respawn_west";
_flatPos = [0, 0, 0];
if (isNil "currentAO") then {
   currentAO = "aoMarker";
};
_accepted = false;
while {!_accepted} do {
	_position = [[[_basepos, 2500]], ["water", "out"]] call QS_fnc_randomPos;
	_flatPos = _position isFlatEmpty [10, 0, 0.2, 5, 0, false];
	while {(count _flatPos) < 2} do {
		_position = [[[_basepos, 2500]], ["water", "out"]] call QS_fnc_randomPos;
		_flatPos = _position isFlatEmpty [10, 0, 0.2, 5, 0, false];
	};
	if ((_flatPos distance _basepos) > 2000) then {
		if ((_flatPos distance _basepos) < 3750) then {
			if ((_flatPos distance (getMarkerPos currentAO)) > 500) then {
				_accepted = true;
			};
		};
	};
};
_flatPos1 = [(_flatPos select 0) - 4, (_flatPos select 1) - 4, 1];
_flatPos2 = [(_flatPos select 0) + 4, (_flatPos select 1) + 4, 1];
_flatPos3 = [(_flatPos select 0) + 24, (_flatPos select 1) + 24, 1];

// 2. SPAWN OBJECTIVES
_PTdir = random 360;
sleep 1;
priorityObj1 = "O_APC_Tracked_02_AA_F" createVehicle [0,0,100];
waitUntil {!isNull priorityObj1};
priorityObj1 allowDamage false;
priorityObj1 setPos _flatPos1;
priorityObj1 setDir _PTdir;
sleep 1;
priorityObj2 = "O_APC_Tracked_02_AA_F" createVehicle [0,0,120];
waitUntil {!isNull priorityObj2};
priorityObj2 allowDamage false;
priorityObj2 setPos _flatPos2;
priorityObj2 setDir _PTdir;
sleep 1;

// SPAWN AMMO TRUCK (for ambiance and plausibiliy of unlimited ammo)
ammoTruck = "O_Truck_03_ammo_F" createVehicle [0,0,140];
waitUntil {!isNull ammoTruck};
ammoTruck allowDamage false;
ammoTruck setPos _flatPos3;
ammoTruck addEventHandler ['incomingMissile', {_this spawn QS_fnc_HandleIncomingMissile}];
ammoTruck setDir random 360;
{_x lock 0;} forEach [priorityObj1, priorityObj2, ammoTruck];

// 3. SPAWN CREW
_unitsArray = [objNull];
_priorityGroup = createGroup ENEMY_SIDE;
"O_officer_F" createUnit [_flatPos, _priorityGroup];
"O_officer_F" createUnit [_flatPos, _priorityGroup];
"O_engineer_F" createUnit [_flatPos, _priorityGroup];
"O_engineer_F" createUnit [_flatPos, _priorityGroup];
((units _priorityGroup) select 0) assignAsCommander priorityObj1;
((units _priorityGroup) select 0) moveInCommander priorityObj1;
((units _priorityGroup) select 1) assignAsCommander priorityObj2;
((units _priorityGroup) select 1) moveInCommander priorityObj2;
((units _priorityGroup) select 2) assignAsGunner priorityObj1;
((units _priorityGroup) select 2) moveInGunner priorityObj1;
((units _priorityGroup) select 3) assignAsGunner priorityObj2;
((units _priorityGroup) select 3) moveInGunner priorityObj2;
_unitsArray = _unitsArray + [_priorityGroup];

// Engines on baby
sleep 0.1;
priorityObj1 engineOn true;
sleep 0.1;
priorityObj2 engineOn true;
priorityObj1 doWatch _basepos;
priorityObj2 doWatch _basepos;

// 4. SPAWN H-BARRIER RING
sleep 1;
_distance = 18;
_dir = 0;
for "_c" from 0 to 7 do {
	_pos = [_flatPos, _distance, _dir] call BIS_fnc_relPos;
	_barrier = "Land_HBarrierBig_F" createVehicle _pos;
	waitUntil {alive _barrier};
	_barrier setDir _dir;
	_dir = _dir + 45;
	_barrier allowDamage false;
	_barrier enableSimulation false;
	_unitsArray = _unitsArray + [_barrier];
};

// 5. SPAWN FORCE PROTECTION
_enemiesArray = [priorityObj1] call QS_fnc_PTenemyEAST;

// fill bots in radius
_fuzzyPos = [((_flatPos select 0) - 300) + (random 600),((_flatPos select 1) - 300) + (random 600), 0];
_guardsGroup = [_fuzzyPos, 300, 15, ENEMY_SIDE] call QS_fnc_FillBots;

// 6. THAT GIRL IS SO DANGEROUS!
[(units _priorityGroup)] call QS_fnc_setSkill4;
_priorityGroup setBehaviour "COMBAT";
_priorityGroup setCombatMode "RED";
_priorityGroup allowFleeing 0;
_priorityGroup setVariable ["zbe_cacheDisabled", true];

// 6a. UNLIMITED AMMO
priorityObj1 addEventHandler ["Fired", { priorityObj1 setVehicleAmmo 1 }];
priorityObj2 addEventHandler ["Fired", { priorityObj2 setVehicleAmmo 1 }];

// 6b. ABIT OF EXTRA HEALTH
// OBJ 1
priorityObj1 setVariable ["selections", []];
priorityObj1 setVariable ["gethit", []];
priorityObj1 addEventHandler
[
	"HandleDamage",
		{
			_unit = _this select 0;
			_selections = _unit getVariable ["selections", []];
			_gethit = _unit getVariable ["gethit", []];
			_selection = _this select 1;

			if !(_selection in _selections) then {
				_selections set [count _selections, _selection];
				_gethit set [count _gethit, 0];
			};

			_i = _selections find _selection;
			_olddamage = _gethit select _i;
			_damage = _olddamage + ((_this select 2) - _olddamage) * 0.25;
			_gethit set [_i, _damage];
			_damage;
		}
];

// OBJ 2
priorityObj2 setVariable ["selections", []];
priorityObj2 setVariable ["gethit", []];
priorityObj2 addEventHandler
[
	"HandleDamage",
		{
			_unit = _this select 0;
			_selections = _unit getVariable ["selections", []];
			_gethit = _unit getVariable ["gethit", []];
			_selection = _this select 1;

			if !(_selection in _selections) then {
				_selections set [count _selections, _selection];
				_gethit set [count _gethit, 0];
			};

			_i = _selections find _selection;
			_olddamage = _gethit select _i;
			_damage = _olddamage + ((_this select 2) - _olddamage) * 0.25;
			_gethit set [_i, _damage];
			_damage;
		}
];

// 7. BRIEFING
{ _x setMarkerPos _fuzzyPos; } forEach ["priorityMarker", "priorityCircle"];
priorityTargetText = "Зенитная батарея"; publicVariable "priorityTargetText";
"priorityMarker" setMarkerText "Приоритетная цель: Зенитная батарея"; publicVariable "priorityMarker";
_briefing = "<t align='center' size='2.2'>Внимание</t><br/><t size='1.5' color='#F44336'>Зенитная батарея</t><br/>____________________<br/>Обнаружена точка укрепления зенитных орудий противника. Её близлежащее расположение грозит как группам десантирования, так и всей нашей авиации в целом.";
GlobalHint = _briefing; hint parseText _briefing; publicVariable "GlobalHint";
showNotification = ["NewPriorityTarget", ["Зенитная батарея", "\a3\ui_f\data\gui\cfg\hints\target_ca.paa"]]; publicVariable "showNotification";

priorityObj1 allowDamage true;
priorityObj2 allowDamage true;
ammoTruck allowDamage true;

// start Red Queen
_txid = [_flatPos, 400] call QS_fnc_startRQ;

// save info in DB
try {
    _position = format ["%1,%2", floor (_fuzzyPos select 0), floor (_fuzzyPos select 1)];
    ["setInfo",["prio_name", "Зенитная Батарея"], 0] remoteExec ["sqlServerCall", 2];
    ["setInfo",["prio_position", _position], 0] remoteExec ["sqlServerCall", 2];
} catch {};

if !(isNil "PARTIZAN_BASE_SCORE") then {
    if (PARTIZAN_BASE_SCORE > 33) then {
        _taskMarker = createMarker ["TASK_MARKER1", [0,0]];
        _taskMarker setMarkerColor "ColorRed";
        _taskMarker setMarkerType "mil_dot";
        [_taskMarker, 0] remoteExec ["setMarkerAlphaLocal", west, true];
        [_taskMarker, 1] remoteExec ["setMarkerAlphaLocal", resistance, true];
        _taskMarker setMarkerPos (getPos priorityObj1);
    };
};

// 8. CORE LOOP
waitUntil{sleep 1; !isNil "currentAOUp"};
_loopVar = TRUE;
_doTargets = [];
_targetSelect = objNull;
sleep 180;
while {_loopVar} do {

	// Small targeting system routine
	_doTargets = [];
	_targetSelect = objNull;
	_targetList = _flatPos nearEntities [["Air"], 7500];
	if ((count _targetList) > 0) then {
		{_priorityGroup reveal [_x,4];} forEach _targetList;
		_targetListEnemy = [];
		{
			if ((side _x) == west) then {
				if !((typeOf _x) == "B_UAV_01_F") then {
				    0 = _targetListEnemy pushBack _x;
				};				
			};
		} count _targetList;
		if ((count _targetListEnemy) > 0) then {
			{
				if ((getPos _x select 2) > 25) then {
					0 = _doTargets pushBack _x;
				};
			} count _targetListEnemy;

			if ((count _doTargets) > 0) then {
				_targetSelect = _doTargets select (floor (random (count _doTargets)));
				if (canFire priorityObj1) then {
					priorityObj1 doWatch [(getPos _targetSelect select 0), (getPos _targetSelect select 1), 2000];
					priorityObj1 doTarget _targetSelect;
					sleep 2;
					priorityObj1 fireAtTarget [_targetSelect, "missiles_titan"];
					sleep 2;
					if (canFire priorityObj2) then {
						_targetSelect = _doTargets select (floor (random (count _doTargets)));
						priorityObj2 doWatch [(getPos _targetSelect select 0), (getPos _targetSelect select 1), 2000];
						priorityObj2 doTarget _targetSelect;
						sleep 2;
						priorityObj2 fireAtTarget [_targetSelect, "missiles_titan"];
						sleep 2;
					};
				} else {
					if (canFire priorityObj2) then {
						priorityObj2 doTarget _targetSelect;
						sleep 2;
						priorityObj2 doFire _targetSelect;
						sleep 2;
					};
				};
			};
		};
	};

	// Exit strategy
	if ((!alive priorityObj1 && !alive priorityObj2) || !currentAOUp) then {
			_loopVar = FALSE;

			// 9. DE-BRIEF
			sleep 5;
			_completeText = "<t align='center' size='2.2'>Внимание</t><br/><t size='1.5' color='#C6FF00'>Зенитная батарея уничтожена!</t><br/>____________________<br/>Противник лишился основных средств ПВО.<br/><br/>Возвращайтесь к выполнению основной задачи.";
			GlobalHint = _completeText; hint parseText _completeText; publicVariable "GlobalHint";
			showNotification = ["CompletedPriorityTarget", ["Зенитная батарея нейтрализована", "\a3\ui_f\data\gui\cfg\hints\target_ca.paa"]]; publicVariable "showNotification";
			{_x setMarkerPos [-10000, -10000, -10000];} forEach ["priorityMarker","priorityCircle"]; publicVariable "priorityMarker";

            // stop Red Queen
            [_txid] call QS_fnc_stopRQ;

			// 10. DELETE
			{
                if (side _x == east || side _x == sideEmpty) then {
                    deleteVehicle _x;
                };			   
		    } forEach [priorityObj1, priorityObj2, ammoTruck];
			{_x removeEventHandler ["Fired", 0];} forEach [priorityObj1, priorityObj2];
			{_x removeEventHandler ["HandleDamage",1];} forEach [priorityObj1, priorityObj2];
			sleep 60;
			{[_x] call QS_fnc_TBdeleteObjects;} forEach [_enemiesArray, _unitsArray];
			[_guardsGroup] call QS_fnc_TBdeleteObjects;
	};
	sleep 5;
};
deleteMarker "TASK_MARKER1";
[_fuzzyPos, 500] call QS_fnc_DeleteEnemyEAST;
