/*
Author: ToxaBes
*/
_this addAction ["<t color='#FFFF00'>Влючить постановщик помех</t>","scripts\EW\enableEW.sqf",[],21,true,true,"","(playerSide == resistance) && (_target getVariable [""EW_ENABLED"",0]) != 1 && (vehicle _this == _this)", 5];
_this addAction ["<t color='#7F0000'>Выключить постановщик помех</t>","scripts\EW\disableEW.sqf",[],21,true,true,"","(playerSide == resistance) && (_target getVariable [""EW_ENABLED"",0]) != 0 && (vehicle _this == _this)", 5];            
