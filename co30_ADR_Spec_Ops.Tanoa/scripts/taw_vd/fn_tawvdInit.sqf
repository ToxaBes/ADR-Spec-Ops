/*
  File:
  fn_tawvdInit.sqf
  Author:
  Bryan "Tonic" Boardwine
  Description:
  Master init for TAW View Distance (addon version).
  If the script verson is present it will exit.
*/

if(!isMultiplayer) exitWith {};
tawvd_foot = viewDistance;
tawvd_car = viewDistance;
tawvd_air = viewDistance;
if (tawvd_foot > 3000) then {
    tawvd_foot = 3000;
};
if (tawvd_car > 5000) then {
    tawvd_car = 5000;
};
if (tawvd_air > 6000) then {
    tawvd_air = 6000;
};
tawvd_syncObject = true; //Enable the automatic syncing of Object View rendering with the current view distance.
tawvd_object = tawvd_foot;

tawvd_addon_disable = true;
//The hacky method... Apparently if you stall (sleep or waitUntil) with CfgFunctions you stall the mission initialization process... Good job BIS, why wouldn't you spawn it via preInit or postInit?
[] spawn
{
  waitUntil {!isNull player && player == player};
  waitUntil{!isNil "BIS_fnc_init"};
  waitUntil {!(isNull (findDisplay 46))};

  tawvd_action = player addAction["<t color='#d63333'><img image='\a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_intel_ca.paa' size='1.0'/> Прорисовка</t>",TAWVD_fnc_openTAWVD,[],-98,false,false,"",''];

  [] spawn TAWVD_fnc_trackViewDistance;
};
