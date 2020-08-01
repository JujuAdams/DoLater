/// Queue a function for execution when a signal is broadcast
/// The callback function is executed with a single argument - This is the <callbackParameter> argument provided when calling do_later_publish()
/// 
/// If the defined function returns <true> then the operation *won't* be removed from Do Later's system
/// This will cause the operation to be executed every time the signal is emitted by do_later_publish() (rather than just once the first time)
///
/// @return A struct that represents the created and queued operation
/// @param signal     Signal to listen for. This can be any datatype, but is typically a string or an enum/macro
/// @param function   Function/method to execute

function do_later_subscribe(_signal, _callback)
{
    return do_later_subscribe_ext(_signal, _callback, -1);
}

/// @return A struct that represents the created and queued operation
/// @param signal            Signal to listen for. This can be any datatype, but is typically a string or an enum/macro
/// @param function          Function to execute. This function is rebound to the provided scope
/// @param struct/instance   Scope to execute the function in, which can be an instance or a struct. If scope is a numeric value less than 0 then the function will not be re-scoped
function do_later_subscribe_ext(_signal, _callback, _scope)
{
    if (!is_numeric(_scope) || (_scope >= 0)) _callback = method(_scope, _callback);
    
    var _struct = {
        signal   : _signal,
        callback : _callback,
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

/// @param signal     Signal to listen for. This can be any datatype, but is typically a string or an enum/macro
/// @param function   Scope to execute the function in, which can be an instance or a struct. If scope is a numeric value less than 0 then the function will not be re-scoped
function do_later_sub(_signal, _callback)
{
    return do_later_subscribe(_signal, _callback);
}