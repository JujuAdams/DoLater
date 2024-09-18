// Feather disable all

__DoLaterSystem();

function __DoLaterSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    show_debug_message("DoLater: Welcome to DoLater by Juju Adams! This is version " + string(DO_LATER_VERSION) + ", " + string(DO_LATER_DATE));
    
    _system = {
        __array:  [],
        __parent: DO_LATER_DEFAULT_PARENT,
    };
    
    if (GM_build_type == "run") global.DoLater = _system;
    
    try
    {
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            static _system = __DoLaterSystem();
            
            var _i = 0;
            repeat(array_length(_system.__array))
            {
                var _ts = _system.__array[_i];
            
                if (!time_source_exists(_ts))
                {
                    array_delete(_system.__array, _i, 1);
                }
                else if (time_source_get_state(_ts) == time_source_state_stopped)
                {
                    time_source_destroy(_ts, true);
                    array_delete(_system.__array, _i, 1);
                }
                else
                {
                    ++_i;
                }
            }
        }, [], -1));
    }
    catch(_error)
    {
        show_error("DoLater is only supported on GMS 2022 LTS and later\n ", true);
    }
    
    return _system;
}