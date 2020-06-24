//Queue a function for execution after a period of time
//The "delay" parameter is in frames

/// @param delay
/// @param function
/// @param scope
/// @param once

function do_later(_delay, _callback, _scope, _once)
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
            list     : global.__do_later_list,
            callback : _callback,
            delay    : _delay,
            ticks    : 0,
            once     : _once
        }
        
        ds_list_add(global.__do_later_list, struct);
        return struct;
    }
}