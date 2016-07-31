/*
Author: Quiksilver
Description: Get radar telemetry from enemy radar site, then destroy it.
*/
#define OUR_SIDE WEST
#define ENEMY_SIDE EAST

private ["_objPos", "_flatPos", "_accepted", "_position", "_randomDir", "_hangar", "_x", "_enemiesArray", "_briefing", "_fuzzyPos", "_unitsArray", "_dummy", "_object", "_tower1", "_tower2", "_tower3"];

_c4Message = selectRandom [
	"Радиолокационные данные захвачены. C-4 активирован! 30 секунд до детонации.",
	"Телеметрические данные радара получены. Взрывчатка установлена! 30 секунд до взрыва.",
	"Данные радара считаны. Заряд установлен! 30 секунд до взрыва."
];

// FIND SAFE POSITION FOR OBJECTIVE
_flatPos = [0, 0, 0];
_accepted = false;
while {!_accepted} do {
	_position = [] call QS_fnc_randomPos;
	_flatPos = _position isFlatEmpty [5, 0, 0.1, sizeOf "Land_Radar_Small_F", 0, false];

	while {(count _flatPos) < 2} do {
		_position = [] call QS_fnc_randomPos;
		_flatPos = _position isFlatEmpty [5, 0, 0.1, sizeOf "Land_Radar_Small_F", 0, false];
	};

	if ((_flatPos distance (getMarkerPos "respawn_west")) > 1000) then {
		if !(getMarkerColor "currentAO" == "") then {
			if ((_flatPos distance (getMarkerPos currentAO)) > 500) then {
				_accepted = true;
			};
		} else {
			_accepted = true;
		};
	};
};

_objPos = [_flatPos, 15, 30, 10, 0, 0.5, 0, [], [_flatPos]] call QS_fnc_findSafePos;

// SPAWN OBJECTIVE
sideObj = "Land_Radar_Small_F" createVehicle _flatPos;
waitUntil {!isNull sideObj};
sideObj setDir random 360;

house = "Land_Cargo_House_V4_F" createVehicle _objPos;
house setDir random 360;
house allowDamage false;

_dummy = selectRandom [explosivesDummy1,explosivesDummy2];
sleep 0.3;
_object = selectRandom [research1,research2];
sleep 0.3;
{ _x enableSimulation true; } forEach [researchTable, _object];
sleep 0.3;
researchTable setPos [(getPos house select 0), (getPos house select 1), ((getPos house select 2) + 1)];
sleep 1;
[researchTable, _object, [0, 0, 0.9]] call BIS_fnc_relPosObject;
sleep 0.3;
_tower1 = [sideObj, 50, 0] call BIS_fnc_relPos;
_tower2 = [sideObj, 50, 120] call BIS_fnc_relPos;
_tower3 = [sideObj, 50, 240] call BIS_fnc_relPos;
sleep 0.3;
tower1 = "Land_Cargo_Patrol_V4_F" createVehicle _tower1;
tower2 = "Land_Cargo_Patrol_V4_F" createVehicle _tower2;
tower3 = "Land_Cargo_Patrol_V4_F" createVehicle _tower3;
sleep 0.3;
tower1 setDir 180;
tower2 setDir 300;
tower3 setDir 60;

{ _x allowDamage false } forEach [tower1, tower2, tower3];
sleep 0.3;

// SPAWN FORCE PROTECTION
_enemiesArray = [sideObj] call QS_fnc_SMenemyEAST;
_fuzzyPos = [((_flatPos select 0) - 300) + (random 600), ((_flatPos select 1) - 300) + (random 600), 0];
_guardsGroup = [_fuzzyPos, 400, 50, ENEMY_SIDE] call QS_fnc_FillBots;

// BRIEF
{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
sideMarkerText = "Радар"; publicVariable "sideMarkerText";
"sideMarker" setMarkerText "Допзадание: Радар"; publicVariable "sideMarker";
publicVariable "sideObj";
_briefing = "<t align='center'><t size='2.2'>Допзадание</t><br/><t size='1.5' color='#FFC107'>Радар</t><br/>____________________<br/>В целях поддержки своей авиации вражеские силы захватили небольшую радиостанцию.<br/><br/>Ваша задача — выдвинуться в указанный район, обезвредить противника, захватить радиолокационные данные, а затем уничтожить и сам радар.</t>";
GlobalHint = _briefing; hint parseText _briefing; publicVariable "GlobalHint";
showNotification = ["NewSideMission", "Радар"]; publicVariable "showNotification";
sideMarkerText = "Радар"; publicVariable "sideMarkerText";

sideMissionUp = true; publicVariable "sideMissionUp";
SM_SUCCESS = false; publicVariable "SM_SUCCESS";

while { sideMissionUp } do {
	if (!alive sideObj) exitWith {
		// DE-BRIEFING
		hqSideChat = "Данные радара утеряны. Задание провалено!"; publicVariable "hqSideChat"; [WEST, "HQ"] sideChat hqSideChat;
		[false] spawn QS_fnc_SMhintFAIL;
		{ _x setMarkerPos [-10000, -10000, -10000]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";
		sideMissionUp = false; publicVariable "sideMissionUp";

		// DELETE
		{ _x setPos [-10000, -10000, 0]; } forEach [_object, researchTable, _dummy];
		sleep 120;
		{ deleteVehicle _x } forEach [sideObj, house, tower1, tower2, tower3];
		deleteVehicle nearestObject [getPos sideObj, "Land_Radar_Small_ruins_F"];
		{ [_x] call QS_fnc_TBdeleteObjects; } forEach [_enemiesArray, _guardsGroup];
		[_fuzzyPos, 500] call QS_fnc_DeleteEnemyEAST;
	};

	if (SM_SUCCESS) exitWith {
		// BOOM!
		hqSideChat = _c4Message; publicVariable "hqSideChat"; [WEST, "HQ"] sideChat hqSideChat;

		_dummy setPos [(getPos sideObj select 0), ((getPos sideObj select 1) +5), ((getPos sideObj select 2) + 0.5)];
		sleep 0.1;
		_object setPos [-10000, -10000, 0];
		sleep 30;
		"Bo_Mk82" createVehicle getPos _dummy;
		_dummy setPos [-10000, -10000, 1];
		researchTable setPos [-10000, -10000, 1];
		sleep 0.1;

		// DE-BRIEFING

		[false] call QS_fnc_SMhintSUCCESS;
		{ _x setMarkerPos [-10000, -10000, -10000]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";
		sideMissionUp = false; publicVariable "sideMissionUp";

		// DELETE
		sleep 120;
		{ deleteVehicle _x } forEach [sideObj, house, tower1, tower2, tower3];
		deleteVehicle nearestObject [getPos sideObj, "Land_Radar_Small_ruins_F"];
		{ [_x] call QS_fnc_TBdeleteObjects; } forEach [_enemiesArray, _guardsGroup];
		[_fuzzyPos, 500] call QS_fnc_DeleteEnemyEAST;
	};
};
