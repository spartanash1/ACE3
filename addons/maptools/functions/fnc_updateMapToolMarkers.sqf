/*
 * Author: esteldunedain
 * Update the map tool markers, position, size, rotation and visibility.
 *
 * Arguments:
 * 0: The Map <CONTROL>
 *
 * Return Value:
 * Nothing
 *
 * Public: No
 */
#include "script_component.hpp"

#define TEXTURE_WIDTH_IN_M    6205
#define CENTER_OFFSET_Y_PERC  0.1606
#define CONSTANT_SCALE        0.2

params ["_theMap"];




#define TEXTURE_WIDTH_IN_M           6205
#define DIST_BOTTOM_TO_CENTER_PERC  -0.33
#define DIST_TOP_TO_CENTER_PERC      0.65
#define DIST_LEFT_TO_CENTER_PERC     0.30

private _posCenter = +GVAR(mapTool_pos);
_posCenter set [2, 0];

private _posTopRight = [
(GVAR(mapTool_pos) select 0) + (cos GVAR(mapTool_angle)) * DIST_LEFT_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5 + (sin GVAR(mapTool_angle)) * DIST_TOP_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5,
(GVAR(mapTool_pos) select 1) + (-sin GVAR(mapTool_angle)) * DIST_LEFT_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5 + (cos GVAR(mapTool_angle)) * DIST_TOP_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5,
0];
_theMap drawIcon ['iconStaticMG',[1,0,0,1],_posTopRight,24,24,getDir player,'1,1',1,0.03,'TahomaB','right'];

private _posTopLeft = [
(GVAR(mapTool_pos) select 0) + (-cos GVAR(mapTool_angle)) * DIST_LEFT_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5 + (sin GVAR(mapTool_angle)) * DIST_TOP_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5,
(GVAR(mapTool_pos) select 1) + (sin GVAR(mapTool_angle)) * DIST_LEFT_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5 + (cos GVAR(mapTool_angle)) * DIST_TOP_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5,
0];
_theMap drawIcon ['iconStaticMG',[1,0,0,1],_posTopLeft,24,24,getDir player,'-1,1',1,0.03,'TahomaB','right'];

private _posBottomLeft = [
(GVAR(mapTool_pos) select 0) + (-cos GVAR(mapTool_angle)) * DIST_LEFT_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5 + (sin GVAR(mapTool_angle)) * DIST_BOTTOM_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5,
(GVAR(mapTool_pos) select 1) + (sin GVAR(mapTool_angle)) * DIST_LEFT_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5 + (cos GVAR(mapTool_angle)) * DIST_BOTTOM_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5,
0];
_theMap drawIcon ['iconStaticMG',[1,0,0,1],_posBottomLeft,24,24,getDir player,'-1,-1',1,0.03,'TahomaB','right'];

private _posBottomRight = [
(GVAR(mapTool_pos) select 0) + (cos GVAR(mapTool_angle)) * DIST_LEFT_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5 + (sin GVAR(mapTool_angle)) * DIST_BOTTOM_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5,
(GVAR(mapTool_pos) select 1) + (-sin GVAR(mapTool_angle)) * DIST_LEFT_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5 + (cos GVAR(mapTool_angle)) * DIST_BOTTOM_TO_CENTER_PERC * TEXTURE_WIDTH_IN_M * 0.5,
0];
_theMap drawIcon ['iconStaticMG',[1,0,0,1],_posBottomRight,24,24,getDir player,'1,-1',1,0.03,'TahomaB','right'];

_fnc_Distance = {
    params ["_a", "_b", "_p"];
    _n = _b vectorDiff _a;
    _pa = _a vectorDiff _p;
    _c = _n vectorMultiply ((_pa vectorDotProduct _n) / (_n vectorDotProduct _n));
    _d = _pa vectorDiff _c;
    sqrt (_d vectorDotProduct _d);
};


if (GVAR(freedrawing)) then {
    _pos = _theMap ctrlMapScreenToWorld getMousePosition;
    _pos set [2, 0];

    switch (true) do {
    case (_pos inPolygon [_posCenter, _posTopLeft, _posBottomLeft]): {
            systemChat "Left";
            _dist = ([_posTopLeft, _posBottomLeft, _pos] call _fnc_Distance);
            _pos = _pos vectorAdd ([_dist, (GVAR(mapTool_angle) - 90) ,0] call CBA_fnc_polar2vect);
            _screen = _theMap ctrlMapWorldToScreen _pos;
            setMousePosition _screen;
        };
    case (_pos inPolygon [_posCenter, _posTopLeft, _posTopRight]): {
            systemChat "Top";
            _dist = ([_posTopLeft, _posTopRight, _pos] call _fnc_Distance);
            _pos = _pos vectorAdd ([_dist, (GVAR(mapTool_angle) + 0) ,0] call CBA_fnc_polar2vect);
            _screen = _theMap ctrlMapWorldToScreen _pos;
            setMousePosition _screen;
        };
        ///
    };
};


if ((GVAR(mapTool_Shown) == 0) || {!("ACE_MapTools" in items ACE_player)}) exitWith {};

private _rotatingTexture = "";
private _textureWidth = 0;
if (GVAR(mapTool_Shown) == 1) then {
    _rotatingTexture = QPATHTOF(data\mapToolRotatingNormal.paa);
    _textureWidth = TEXTURE_WIDTH_IN_M;
} else {
    _rotatingTexture = QPATHTOF(data\mapToolRotatingSmall.paa);
    _textureWidth = TEXTURE_WIDTH_IN_M / 2;
};

// Update scale of both parts
getResolution params ["_resWidth", "_resHeight", "", "", "_aspectRatio"];
private _scaleX = 32 * _textureWidth * CONSTANT_SCALE * (call FUNC(calculateMapScale));
private _scaleY = _scaleX * ((_resWidth / _resHeight) / _aspectRatio); //handle bad aspect ratios

// Position of the fixed part
private _xPos = GVAR(mapTool_pos) select 0;
private _yPos = (GVAR(mapTool_pos) select 1) + _textureWidth * CENTER_OFFSET_Y_PERC;

_theMap drawIcon [QPATHTOF(data\mapToolFixed.paa), [1,1,1,1], [_xPos,_yPos], _scaleX, _scaleY, 0, "", 0];

// Position and rotation of the rotating part
_xPos = (GVAR(mapTool_pos) select 0) + sin(GVAR(mapTool_angle)) * _textureWidth * CENTER_OFFSET_Y_PERC;
_yPos = (GVAR(mapTool_pos) select 1) + cos(GVAR(mapTool_angle)) * _textureWidth * CENTER_OFFSET_Y_PERC;

_theMap drawIcon [_rotatingTexture, [1,1,1,1], [_xPos,_yPos], _scaleX, _scaleY, GVAR(mapTool_angle), "", 0];
