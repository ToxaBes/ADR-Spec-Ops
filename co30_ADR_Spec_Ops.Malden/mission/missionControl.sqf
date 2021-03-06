/*
Author: ToxaBes (based on mission control made by Quiksilver)
Description: Main AO and side objective mission control
*/
private ["_mission", "_script", "_missionList", "_prioList", "_loopTimeout", "_chance", "_prio", "_null"];
_loopTimeout = 20;
sleep _loopTimeout;
_prioList = [
	"priorityAA",
	"priorityArty",
	"priorityPower",
	"priorityMortar"
];
_missionList = [
    "convoy",
	"HQside",
	"rescueHostages",
	"heliCrash",
	"grapeswrath",
	"destroyUrban",
	"secureSide",
	"rescueHostages", 
	"heliCrash",  
	"grapeswrath", 
	"swordfish",
	"snatch",
	"convoy",
	"heliCrash",
	"rescueHostages",
	"yellowfog",
	"convoy",	
	"heliCrash",
	"grapeswrath",
	"oilmama",
	"heliCrash"
];
AVANPOST_COORDS = false; publicVariable "AVANPOST_COORDS";
AVANPOST_RESPAWN = false; publicVariable "AVANPOST_RESPAWN";
while { true } do {	
    if (PARAMS_SideObjectives == 1) then {
    	[] spawn QS_fnc_clearInfo;
        hqSideChat = "Вторичная цель выявлена, ждите указаний!"; publicVariable "hqSideChat"; [WEST, "HQ"] sideChat hqSideChat;
	    _mission = selectRandom _missionList;
	    if !(isNil "LAST_SIDE_MISSION") then {
            while {_mission == LAST_SIDE_MISSION} do {
                _mission = selectRandom _missionList;
            };
	    };
	    LAST_SIDE_MISSION = _mission;
	    publicVariable "LAST_SIDE_MISSION";
	    WIN_WEST = 0; publicVariable "WIN_WEST";
        WIN_GUER = 0; publicVariable "WIN_GUER";
        MISSION_START_TIME = time; publicVariable "MISSION_START_TIME";
	    currentMission = [_mission] spawn {_this call compile preProcessFileLineNumbers format ["mission\side\missions\%1.sqf", _this select 0]};
	    _side = selectRandom [west, resistance];
	    [_side] spawn QS_fnc_assaultBase;
	    [] spawn QS_fnc_convoyAir;
	    waitUntil {
	    	sleep _loopTimeout;
	    	scriptDone currentMission;
	    };
	    if !(isNil "AID_TRIGGER1") then {
	        if !(isNull AID_TRIGGER1) then {
    	        deleteVehicle AID_TRIGGER1;
            };
        };
        if !(isNil "AID_TRIGGER2") then {
	        if !(isNull AID_TRIGGER2) then {
    	        deleteVehicle AID_TRIGGER2;
            };
        };
	};
	if (PARAMS_AO == 1) then {
		[] spawn QS_fnc_clearInfo;
	    currentMission = [] spawn {_this call compile preProcessFileLineNumbers "mission\main\missions\AOattack.sqf"};
	    _side = selectRandom [west, resistance];
	    [_side] spawn QS_fnc_assaultBase;
	    [] spawn QS_fnc_convoyGround;
	    _chance = random 10;
        if (_chance < PARAMS_PriorityObjectivesChance) then {
        	sleep (_loopTimeout * 3);
        	_prio = selectRandom _prioList;
	        if !(isNil "LAST_PRIO_MISSION") then {
                while {_prio == LAST_PRIO_MISSION} do {
                    _prio = selectRandom _prioList;
                };
	        };
	        LAST_PRIO_MISSION = _prio;
	        publicVariable "LAST_PRIO_MISSION";
            _null = [_prio] spawn {_this call compile preProcessFileLineNumbers format ["mission\priority\missions\%1.sqf", _this select 0]};
        };
	    waitUntil {
	    	sleep _loopTimeout;
	    	scriptDone currentMission;
	    };
    };
};
