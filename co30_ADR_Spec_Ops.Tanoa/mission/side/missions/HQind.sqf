/*
Author:	Quiksilver
Description: Secure HQ supplies before destroying it.
*/
#define OUR_SIDE WEST
#define ENEMY_SIDE EAST

private ["_flatPos", "_accepted", "_position", "_enemiesArray", "_fuzzyPos", "_x", "_briefing", "_object", "_SMveh", "_SMaa", "_tower1", "_tower2", "_tower3", "_flatPos1", "_flatPos2"];

_c4Message = selectRandom [
	"Перехват оружия завершён. Заряд установлен! 30 секунд до взрыва.",
	"Пусковая установка захвачена. Взрывчатка установлена! 30 секунд до взрыва.",
	"Оружие врага захвачено. C-4 активирован! 30 секунд до детонации."
];

// FIND POSITION FOR OBJECTIVE
_flatPos = [0, 0, 0];
_accepted = false;
while {!_accepted} do {
	_position = [] call QS_fnc_randomPos;
	_flatPos = _position isFlatEmpty [10, 1, 0.2, sizeOf "Land_Cargo_House_V2_F", 0, false];

	while {(count _flatPos) < 2} do {
		_position = [] call QS_fnc_randomPos;
		_flatPos = _position isFlatEmpty [10, 1, 0.2, sizeOf "Land_Cargo_House_V2_F", 0, false];
	};

	if ((_flatPos distance (getMarkerPos "respawn_west")) > 1700) then {
		_accepted = true;
	};
};

_flatPos1 = [_flatPos, 15, 50] call BIS_fnc_relPos;
_flatPos2 = [_flatPos, 15, 80] call BIS_fnc_relPos;

// SPAWN OBJECTIVE
_objDir = random 360;

sideObj = "Land_Cargo_House_V2_F" createVehicle _flatPos;
waitUntil {alive sideObj};
sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), (getPos sideObj select 2)];
sideObj setVectorUp [0, 0, 1];
sideObj setDir _objDir;

_object = selectRandom [indCrate1,indCrate2];
_object setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) + 2)];

truck1 = "B_Truck_01_ammo_F" createVehicle _flatPos1;
truck2 = "I_Truck_02_ammo_F" createVehicle _flatPos2;
truck1 addEventHandler ['incomingMissile', {_this spawn QS_fnc_HandleIncomingMissile}];
truck2 addEventHandler ['incomingMissile', {_this spawn QS_fnc_HandleIncomingMissile}];
{ _x setDir random 360 } forEach [truck1, truck2];
{ _x lock 0 } forEach [truck1, truck2];

// SPAWN FORCE PROTECTION
_enemiesArray = [sideObj] call QS_fnc_SMenemyIND;
_fuzzyPos = [((_flatPos select 0) - 300) + (random 600), ((_flatPos select 1) - 300) + (random 600), 0];
_guardsGroup = [_fuzzyPos, 400, 50, ENEMY_SIDE] call QS_fnc_FillBots;

// SPAWN BRIEFING
{ _x setMarkerPos _fuzzyPos;} forEach ["sideMarker", "sideCircle"];
sideMarkerText = "Пусковые установки"; publicVariable "sideMarkerText";
"sideMarker" setMarkerText "Допзадание: Пусковые установки"; publicVariable "sideMarker";
publicVariable "sideObj";
_briefing = "<t align='center'><t size='2.2'>Новое допзадание</t><br/><t size='1.5' color='#FFC107'>Пусковые установки</t><br/>____________________<br/>Предатель в рядах союзных войск передаёт вражеским силам новейшие вооружение и пусковые установки.<br/><br/>Ваша задача — выдвинуться в указанный район, найти и захватить пусковые установки, ликвидируя группировки врага по ходу операции.</t>";
GlobalHint = _briefing; hint parseText GlobalHint; publicVariable "GlobalHint";
showNotification = ["NewSideMission", "Пусковые установки"]; publicVariable "showNotification";
sideMarkerText = "Система ПВО"; publicVariable "sideMarkerText";

// [ CORE LOOPS ]
sideMissionUp = true; publicVariable "sideMissionUp";
SM_SUCCESS = false; publicVariable "SM_SUCCESS";

// start Red Queen
_txid = [_flatPos, 400] call QS_fnc_startRQ;

// save info in DB
try {
    _position = format ["%1,%2", floor (_fuzzyPos select 0), floor (_fuzzyPos select 1)];
    ["setInfo",["side_name", "Пусковые установки"], 0] remoteExec ["sqlServerCall", 2];
    ["setInfo",["side_position", _position], 0] remoteExec ["sqlServerCall", 2];
} catch {};

if !(isNil "PARTIZAN_BASE_SCORE") then {
    if (PARTIZAN_BASE_SCORE > 33) then {
        _taskMarker = createMarker ["TASK_MARKER1", [0,0]];
        _taskMarker setMarkerColor "ColorRed";
        _taskMarker setMarkerType "mil_dot";
        [_taskMarker, 0] remoteExec ["setMarkerAlphaLocal", west, true];
        [_taskMarker, 1] remoteExec ["setMarkerAlphaLocal", resistance, true];
        _taskMarker setMarkerPos (getPos sideObj);
    };
};

while { sideMissionUp } do {

	// IF PACKAGE DESTROYED [FAIL]
	if (!alive sideObj) exitWith {

		// DE-BRIEFING
		sideMissionUp = false; publicVariable "sideMissionUp";
		hqSideChat = "Цель уничтожена преждевременно. Задание провалено!"; publicVariable "hqSideChat"; [WEST, "HQ"] sideChat hqSideChat;
		[false] spawn QS_fnc_SMhintFAIL;
		{ _x setMarkerPos [-10000, -10000, -10000]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";

		// DELETE
		_object setPos [-10000, -10000, 0];
		sleep 120;
		{ deleteVehicle _x } forEach [sideObj, truck1, truck2];
		deleteVehicle nearestObject [getPos sideObj, "Land_Cargo_House_V2_ruins_F"];
		{ [_x] call QS_fnc_TBdeleteObjects; } forEach [_enemiesArray, _guardsGroup];
		[_fuzzyPos, 500] call QS_fnc_DeleteEnemyEAST;
	};

	// IF PACKAGE SECURED [SUCCESS]
	if (SM_SUCCESS) exitWith {

		// BOOM!
		hqSideChat = _c4Message; publicVariable "hqSideChat"; [WEST, "HQ"] sideChat hqSideChat;
		sleep 30;
		"Bo_Mk82" createVehicle getPos _object;
		sleep 0.1;
		_object setPos [-10000, -10000, 0];

		// DE-BRIEFING
		sideMissionUp = false; publicVariable "sideMissionUp";
		if (WIN_WEST > WIN_GUER) then {
            [3] spawn QS_fnc_bluforSUCCESS;
        } else {
            [3] spawn QS_fnc_partizanSUCCESS;
        };
		{ _x setMarkerPos [-10000, -10000, -10000]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";

		// stop Red Queen
        [_txid] call QS_fnc_stopRQ;

		// DELETE
		deleteMarker "TASK_MARKER1";
		sleep 120;
		{ deleteVehicle _x } forEach [sideObj, truck1, truck2];
		deleteVehicle nearestObject [getPos sideObj, "Land_Cargo_House_V2_ruins_F"];
		{ [_x] call QS_fnc_TBdeleteObjects; } forEach [_enemiesArray, _guardsGroup];
		[_fuzzyPos, 500] call QS_fnc_DeleteEnemyEAST;
	};
};
