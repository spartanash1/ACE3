/*
 * Author: jaynus
 * Remove a synced event handler
 *
 * Arguments:
 * 0: Name <STRING>
 *
 * Return Value:
 * Boolean of success
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_name"];

if (!HASH_HASKEY(GVAR(syncedEvents),_name)) exitWith {
    ACE_LOGERROR_1("Synced event key [%1] not found (removeSyncedEventHandler).", _name);
    false
};

private _data = HASH_GET(GVAR(syncedEvents),_name);
_data params ["", "", "", "_eventId"];

[_eventId] call CBA_fnc_removeEventHandler;
HASH_REM(GVAR(syncedEvents),_name);
