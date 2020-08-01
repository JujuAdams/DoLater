/// Broadcast a signal that executes matching operations defined with do_later_subscribe()
///
/// @return N/A (undefined)
/// @param signal                Signal to listen for. This can be any datatype, but is typically a string or an enum/macro
/// @param [callbackParameter]   Additional data to call into the subscriber's function (as argument0)

function do_later_publish()
{
    var _signal             = argument[0];
    var _callback_parameter = (argument[1] != undefined)? argument[1] : undefined;
    
    var _list = global.__do_later_signal_map[? _signal];
    if (_list != undefined)
    {
        var _i = 0;
        repeat(ds_list_size(_list))
        {
            with(_list[| _i])
            {
                //If the instance that the function is scoped to has been destroyed, delete this operation
                var _callback_self = method_get_self(callback);
                if (DO_LATER_IGNORE_DESTROYED_INSTANCES && !is_struct(_callback_self) && !is_undefined(_callback_self) && !instance_exists(_callback_self.id))
                {
                    deleted = true;
                }
                
                if (deleted)
                {
                    ds_list_delete(_list, _i);
                }
                else
                {
                    var _result = callback(_callback_parameter); //Execute the callback. If it returns <false>, remove the operation from the list
                    if (!_result && !deleted)
                    {
                        deleted = true;
                        ds_list_delete(_list, _i);
                    }
                    else
                    {
                        _i++;
                    }
                }
            }
        }
        
        //Clear up this list if it's empty to avoid a memory leak
        if (ds_list_empty(_list))
        {
            ds_list_destroy(_list);
            ds_map_delete(global.__do_later_signal_map, _signal);
        }
    }
}

/// @param signal                Signal to listen for. This can be any datatype, but is typically a string or an enum/macro
/// @param [callbackParameter]   Additional data to call into the subscriber's function (as argument0)
function do_later_pub()
{
    var _signal             = argument[0];
    var _callback_parameter = (argument[1] != undefined)? argument[1] : undefined;
    
    return do_later_publish(_signal, _callback_parameter);
}