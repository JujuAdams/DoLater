/// Queue a function for execution after a certain number of frames
///
/// @return A struct that represents the created and queued operation
/// @param delay      Time to wait before executing the function, in frames. Values equal to or less than zero cause the function to be executed immediately
/// @param scope      Scope to execute the function in, which can be an instance or a struct. If scope is a numeric value less than 0 then the function will not be re-scoped
/// @param function   Function to execute. This function is rebound to the provided scope
/// @param once       Whether to call the function once only. Setting this to <false> will execute the function indefinitely (use do_later_delete() to delete the operation)

function do_later(_delay, _scope, _callback, _once)
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
            once     : _once,
            deleted  : false
        }
        
        ds_list_add(global.__do_later_list, struct);
        return struct;
    }
}