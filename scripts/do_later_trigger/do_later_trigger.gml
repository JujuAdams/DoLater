//Queue a function for execution when another function returns true

function do_later_trigger(_trigger_function, _trigger_scope, _callback_function, _callback_scope, _once)
{
    if (!is_numeric(_trigger_scope ) || (_trigger_scope  >= 0)) _trigger_function  = method(_trigger_scope , _trigger_function );
    if (!is_numeric(_callback_scope) || (_callback_scope >= 0)) _callback_function = method(_callback_scope, _callback_function);
    
    if (_trigger_function(_trigger_scope))
    {
        _callback_function();
        return undefined;
    }
    else
    {
        var struct = {
            list     : global.__do_later_trigger_list,
            trigger  : _trigger_function,
            callback : _callback_function,
            once     : _once
        }
        
        ds_list_add(global.__do_later_trigger_list, struct);
        return struct;
    }
}