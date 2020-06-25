/// Queue a function for execution when a signal is broadcast
/// The callback function is executed with a single argument - This is the <callbackParameter> argument provided when calling do_later_publish()
///
/// @return A struct that represents the created and queued operation
/// @param signal    Signal to listen for. This can be any datatype, but is typically a string or an enum/macro
/// @param scope     Scope to execute the function in, which can be an instance or a struct. If scope is a numeric value less than 0 then the function will not be re-scoped
/// @param function  Function to execute. This function is rebound to the provided scope
/// @param once      Whether to call the function once only. Setting this to <false> will execute the function indefinitely (use do_later_delete() to delete the operation)

function do_later_subscribe(_signal, _scope, _callback, _once)
{
    if (!is_numeric(_scope) || (_scope >= 0)) _callback = method(_scope, _callback);
    
    var _struct = {
        signal   : _signal,
        callback : _callback,
        once     : _once,
        deleted  : false
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