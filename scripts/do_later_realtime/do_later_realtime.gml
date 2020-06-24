//Queue a function for execution after a period of time
//The "delay" parameter is in realtime milliseconds

/// @param delay
/// @param function
/// @param scope
/// @param once

function do_later_realtime(_delay, _callback, _scope, _once)
{
    if (!is_numeric(_scope) || (_scope >= 0)) _callback = method(_scope, _callback);
    
    if (_delay <= 0)
    {
        _callback();
        return undefined;
    }
    else
    {
        var struct = {
            list       : global.__do_later_realtime_list,
            callback   : _callback,
            delay      : _delay,
            start_time : current_time,
            once       : _once
        }
        
        ds_list_add(global.__do_later_realtime_list, struct);
        return struct;
    }
}