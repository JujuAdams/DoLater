/// Calls any suitable function defined by do_later_async()
/// This function should be called in all relevant async events by an instance (typically a persistent instance)
///
/// @return N/A (undefined)

function do_later_async_event_receiver()
{
    //Anything that gets executed in this function hasn't timed out
    DO_LATER_ASYNC_TIMED_OUT = false;
    
    //Copy async_load to our own internal ds_map
    ds_map_copy(DO_LATER_ASYNC_LOAD, async_load);
    
    //Report this async event to all relevant callbacks
    var _i = 0;
    repeat(ds_list_size(global.__do_later_async_list))
    {
        with(global.__do_later_async_list[| _i])
        {
            //If the instance that the function is scoped to has been destroyed, delete this operation
            var _callback_self = method_get_self(callback);
            if (DO_LATER_IGNORE_DESTROYED_INSTANCES && (!is_struct(_callback_self) && !is_undefined(_callback_self) && !instance_exists(_callback_self.id)))
            {
                ds_list_delete(global.__do_later_list, _i);
            }
            else if ((event_typ != event_type) || (event_num != event_number)) //If this operation isn't for this specific event, skip over it
            {
                _i++;
            }
            else if (callback()) //Execute the callback. If it returns <true>, remove the operation from the list
            {
                ds_list_delete(global.__do_later_async_list, _i);
            }
            else
            {
                _i++;
            }
        }
    }
    
    //Reset our state
    ds_map_clear(DO_LATER_ASYNC_LOAD);
    DO_LATER_ASYNC_TIMED_OUT = undefined;
}