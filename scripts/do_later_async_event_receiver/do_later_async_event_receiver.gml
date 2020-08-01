/// Calls any suitable function defined by do_later_async()
/// This function should be called in all relevant async events by an instance (typically a persistent instance)
///
/// @return N/A (undefined)

function do_later_async_event_receiver()
{
    var _i = 0;
    repeat(ds_list_size(global.__do_later_async_list))
    {
        with(global.__do_later_async_list[| _i])
        {
            var _callback_self = method_get_self(callback);
            if (DO_LATER_IGNORE_DESTROYED_INSTANCES
            && (!is_struct(_callback_self) && !is_undefined(_callback_self) && !instance_exists(_callback_self.id)))
            {
                deleted = true;
            }
            
            if (deleted)
            {
                ds_list_delete(global.__do_later_list, _i);
            }
            else
            {
                if ((event_typ != event_type) || (event_num != event_number))
                {
                    _i++;
                    continue;
                }
                
                //Execute the callback. If it returns <true>, remove the operation from the list
                var _delete = callback(false); //(Also we haven't timed out yet)
                
                if (!deleted)
                {
                    if (_delete)
                    {
                        deleted = true;
                        ds_list_delete(global.__do_later_async_list, _i);
                    }
                    else
                    {
                        _i++;
                    }
                }
            }
        }
    }
}