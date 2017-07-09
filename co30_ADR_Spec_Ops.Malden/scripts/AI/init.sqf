//Parameters
PublicScript = compileFinal "[] call (_this select 0);";
ServerAsk = compileFinal "if (isServer) then {publicvariable (_this select 0);};";

if (isServer) then {
	VCOMAI_Func = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_DefaultSettings.sqf";
	[] call VCOMAI_Func;
	[VCOMAI_Func] remoteExec ["PublicScript",0,false];
} else {
	["VCOMAI_Func"] remoteExec ["ServerAsk",0,false];
	waitUntil {!(isNil "VCOMAI_Func")};
	[] call VCOMAI_Func;
};

waitUntil {!(isNil "VCOM_SideBasedExecution")};
 
//Compile all scripts that might be used
VcomAI_UnitInit = compile preprocessFileLineNumbers "scripts\AI\Functions\VcomAI_UnitInit.sqf";
VCOMAI_DetermineLeader = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_DetermineLeader.sqf";
VcomAI_QueueHandle = compile preprocessFileLineNumbers "scripts\AI\Functions\VcomAI_QueueHandle.sqf";
VcomAI_DetermineRank = compile preprocessFileLineNumbers "scripts\AI\Functions\VcomAI_DetermineRank.sqf";
VcomAI_DefaultSetup = compile preprocessFileLineNumbers "scripts\AI\Functions\VcomAI_DefaultSetup.sqf";
VcomAI_FormationChange = compile preprocessFileLineNumbers "scripts\AI\Functions\VcomAI_FormationChange.sqf";
VCOMAI_DriverCheck = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_DriverCheck.sqf";
VCOMAI_ClosestAllyWarn = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_ClosestAllyWarn.sqf";
VCOMAI_ClosestEnemy = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_ClosestEnemy.sqf";
VCOMAI_MoveToCover = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_MoveToCover.sqf";
VCOMAI_FlankManeuver = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_FlankManeuver.sqf";
VCOMAI_MoveInCombat = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_MoveInCombat.sqf";
VCOMAI_ThrowGrenade = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_ThrowGrenade.sqf";
VCOMAI_Garrison = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_Garrison.sqf";
VCOMAI_SuppressingShots = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_SuppressingShots.sqf";
VCOMAI_HearingAids = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_HearingAids.sqf";
VCOMAI_LightGarrison = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_LightGarrison.sqf";
VCOMAI_CheckBag = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_CheckBag.sqf";
VCOMAI_HasMine = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_HasMine.sqf";
VCOMAI_Classvehicle = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_Classvehicle.sqf";
VCOMAI_UnpackStatic = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_UnpackStatic.sqf";
VCOMAI_PackStatic = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_PackStatic.sqf";
VCOMAI_DestroyBuilding = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_DestroyBuilding.sqf";
VCOMAI_ArtilleryCalled = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_ArtilleryCalled.sqf";
VCOMAI_Artillery = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_Artillery.sqf";
VCOMAI_RankAndSkill = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_RankAndSkill.sqf";
VCOMAI_FocusedAccuracy = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_FocusedAccuracy.sqf";
VCOMAI_ArmEmptyStatic = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_ArmEmptyStatic.sqf";
VCOMAI_AIHit = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_AIHit.sqf";
VCOMAI_PlaceMine = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_PlaceMine.sqf";
VCOMAI_MapMarkers = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_MapMarkers.sqf";
VCOM_EraseMarkers = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOM_EraseMarkers.sqf";
VCOMAI_EnemyArray = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_EnemyArray.sqf";
VCOMAI_FriendlyArray = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_FriendlyArray.sqf";
VCOMAI_CheckStatic = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_CheckStatic.sqf";
VCOMAI_DeployUAV = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_DeployUAV.sqf";
VCOMAI_VehicleHandle = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_VehicleHandle.sqf";
VCOMAI_GarrisonClear = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_GarrisonClear.sqf";
VCOMAI_BuildingCheck = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_BuildingCheck.sqf";
VCOMAI_GarrisonClearPatrol = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_GarrisonClearPatrol.sqf";
VCOMAI_StanceModifier = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_StanceModifier.sqf";
VCOMAI_BuildingSpawnCheck = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_BuildingSpawnCheck.sqf";
VCOMAI_CombatMode = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_CombatMode.sqf";
VCOMAI_ReGroup = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_ReGroup.sqf";
VCOMAI_ClosestObject = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_Closestobject.sqf";
VCOMAI_GroupLoiter = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_GroupLoiter.sqf";
VCOMAI_LoiterAction = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_LoiterAction.sqf";
VCOMAI_FragmentMove = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_FragmentMove.sqf";
VCOMAI_FindCoverPos = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_FindCoverPos.sqf";
VCOMAI_Waypointcheck = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_Waypointcheck.sqf";
VCOMAI_WepSupCheck = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_WepSupCheck.sqf";
VCOMAI_ForceHeal = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_ForceHeal.sqf";
VCOMAI_DebugText = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_DebugText.sqf";
VCOMAI_RearmSelf = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_RearmSelf.sqf";
VCOMAI_RearmGo = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_RearmGo.sqf";
VCOMAI_SuppressedEffect = compile preprocessFileLineNumbers "scripts\AI\Functions\VCOMAI_SuppressedEffect.sqf";

//Danger FSM
VCOMAI_RecentEnemyDetected = compile preprocessFileLineNumbers "scripts\AI\functions\DangerCauses\VCOMAI_RecentEnemyDetected.sqf";
VCOMAI_CurrentStance = compile preprocessFileLineNumbers "scripts\AI\functions\DangerCauses\VCOMAI_CurrentStance.sqf";
VCOMAI_SetCombatStance = compile preprocessFileLineNumbers "scripts\AI\functions\DangerCauses\VCOMAI_SetCombatStance.sqf";
VCOMAI_MoveToCoverGroup = compile preprocessFileLineNumbers "scripts\AI\functions\DangerCauses\VCOMAI_MoveToCoverGroup.sqf";
VCOMAI_DeadBodyDetection = compile preprocessFileLineNumbers "scripts\AI\functions\DangerCauses\VCOMAI_DeadBodyDetection.sqf";
VCOMAI_CombatMovement = compile preprocessFileLineNumbers "scripts\AI\functions\DangerCauses\VCOMAI_CombatMovement.sqf";
VCOMAI_Explosiondetection = compile preprocessFileLineNumbers "scripts\AI\functions\DangerCauses\VCOMAI_Explosiondetection.sqf";
VCOMAI_VehicleHandleDanger = compile preprocessFileLineNumbers "scripts\AI\functions\DangerCauses\VCOMAI_VehicleHandle.sqf";

//Global actions compiles
playMoveEverywhere = compileFinal "(_this select 0) playMoveNow (_this select 1);";
switchMoveEverywhere = compileFinal "(_this select 0) switchMove (_this select 1);";
playActionNowEverywhere = compileFinal "(_this select 0) playActionNow (_this select 1);";
DisableCollisionALL = compileFinal "(_this select 0) disableCollisionWith player";
3DText = compile "[_this select 0,_this select 1,_this select 2,_this select 3] call VCOMAI_DebugText;";
PSup = compile "[] spawn VCOMAI_SuppressedEffect;";

//Below is loop to check for new AI spawning in to be added to the list
if !(isDedicated) then {
	waitUntil {!isNil "BIS_fnc_init"};
	waitUntil {!(isnull (findDisplay 46))};
};

//Lets gets the queue handler going
[] spawn VcomAI_QueueHandle;

VcomAI_UnitQueue = [];
VcomAI_ActiveList = [];
Vcom_ActivateAI = true;
VCOM_CurrentlyMoving = 0;
VCOM_CurrentlySuppressing = 0;

while {true} do {
	if (Vcom_ActivateAI) then {
		{
			if (local _x && simulationEnabled _x) then {
				if (!(_x in VcomAI_ActiveList) && {!(_x in VcomAI_UnitQueue)}) then {
					VcomAI_UnitQueue pushback _x;
				};
			};
		} forEach allUnits;
	};
	sleep 10;
};
