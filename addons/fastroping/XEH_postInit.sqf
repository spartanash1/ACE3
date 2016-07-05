#include "script_component.hpp"

[QGVAR(deployRopes), {
    _this call FUNC(deployRopes);
}] call CBA_fnc_addEventHandler;

[QGVAR(startFastRope), {
    [FUNC(fastRopeServerPFH), 0, _this] call CBA_fnc_addPerFrameHandler;
}] call CBA_fnc_addEventHandler;

["ACE3 Vehicles", QGVAR(cutRopes), localize LSTRING(Interaction_cutRopes), {
    [vehicle ACE_player] call FUNC(cutRopes); true
}, {false}] call CBA_fnc_addKeybind;
