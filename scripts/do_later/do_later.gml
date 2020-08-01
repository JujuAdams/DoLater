/// Queue a function for execution after a certain number of frames
/// 
/// If the defined function returns <true> then the operation *won't* be removed from Do Later's system
/// This will cause the operation to be executed every n-frames continuously
///
/// @return A struct that represents the created and queued operation
/// @param frameDelay   Time to wait before executing the function, in frames. Values equal to or less than zero cause the function to be executed immediately
/// @param function     Function/method to execute

function do_later(_delay, _callback)
{
    return do_later_ext(_delay, _callback, -1);
}

/// @param delay             Time to wait before executing the function, in frames. Values equal to or less than zero cause the function to be executed immediately
/// @param function          Function to execute. This function is rebound to the provided scope
/// @param struct/instance   Scope to execute the function in, which can be an instance or a struct. If scope is a numeric value less than 0 then the function will not be re-scoped
function do_later_ext(_delay, _callback, _scope)
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
            deleted  : false
        }
        
        ds_list_add(global.__do_later_list, struct);
        return struct;
    }
}