// Feather disable all

__DoLaterInitialize();

function __DoLaterInitialize()
{
    static _global = undefined;
    if (_global != undefined) return _global;
    
    show_debug_message("DoLater: Welcome to DoLater by @jujuadams! This is version " + string(__DO_LATER_VERSION) + ", " + string(__DO_LATER_DATE));
    
    _global = {
        __array:  [],
        __parent: DO_LATER_DEFAULT_PARENT,
    };
    
    if (GM_build_type == "run") global.DoLater = _global;
    
    try
    {
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            static _global = __DoLaterInitialize();
            
            var _i = 0;
            repeat(array_length(_global.__array))
            {
                var _ts = _global.__array[_i];
            
                if (!time_source_exists(_ts))
                {
                    array_delete(_global.__array, _i, 1);
                }
                else if (time_source_get_state(_ts) == time_source_state_stopped)
                {
                    time_source_destroy(_ts, true);
                    array_delete(_global.__array, _i, 1);
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
    
    return _global;
}