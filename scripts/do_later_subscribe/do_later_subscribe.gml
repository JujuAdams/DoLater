//Queue a function for execution when a signal is broadcast
//The callback functions should take an argument

/// @param signal
/// @param function
/// @param scope
/// @param once

function do_later_subscribe(_signal, _callback, _scope, _once)
{
    if (!is_numeric(_scope) || (_scope >= 0)) _callback = method(_scope, _callback);
    
    var _struct = {
        signal   : _signal,
        callback : _callback,
        once     : _once
    }
    
    var _list = global.__do_later_signal_map[? _signal];
    if (_list == undefined)
    {
        _list = ds_list_create();
        ds_map_add_list(global.__do_later_signal_map, _signal, _list);
    }
    
    ds_list_add(_list, _struct);
    return _struct;
}

/// @param signal
/// @param function
/// @param scope
/// @param once
function do_later_sub(_signal, _callback, _scope, _once)
{
    return do_later_subscribe(_signal, _callback, _scope, _once);
}