/// Updates Do Later's internal systems, executing any appropriate functions
/// This function should be called one per frame in an instance (typically a persistent instance)
///
/// @return N/A (undefined)

function do_later_system_tick()
{
    //Ensure that this is only ticked once a frame (give or take)
    if ((global.__do_later_last_tick < 0) || (current_time - global.__do_later_last_tick > __DO_LATER_APPROX_FRAME_TIME))
    {
        global.__do_later_last_tick = current_time;
        
        //Check for per-frame operations elapsing
        var _i = 0;
        repeat(ds_list_size(global.__do_later_list))
        {
            with(global.__do_later_list[| _i])
            {
                //If the instance that the function is scoped to has been destroyed, delete this operation
                var _callback_self = method_get_self(callback);
                if (DO_LATER_IGNORE_DESTROYED_INSTANCES && !is_struct(_callback_self) && !is_undefined(_callback_self) && !instance_exists(_callback_self.id))
                {
                    deleted = true;
                }
                
                if (deleted)
                {
                    ds_list_delete(global.__do_later_list, _i);
                }
                else
                {
                    ticks++;
                    if (ticks >= delay)
                    {
                        var _result = callback(); //Execute the callback. If it returns <false>, remove the operation from the list
                        if (!_result && !deleted)
                        {
                            deleted = true;
                            ds_list_delete(global.__do_later_list, _i);
                        }
                        else
                        {
                            ticks -= delay;
                            _i++;
                        }
                    }
                    else
                    {
                        _i++;
                    }
                }
            }
        }
        
        //Check for realtime operations elapsing
        var _i = 0;
        repeat(ds_list_size(global.__do_later_realtime_list))
        {
            with(global.__do_later_realtime_list[| _i])
            {
                //If the instance that the function is scoped to has been destroyed, delete this operation
                var _callback_self = method_get_self(callback);
                if (DO_LATER_IGNORE_DESTROYED_INSTANCES && !is_struct(_callback_self) && !is_undefined(_callback_self) && !instance_exists(_callback_self.id))
                {
                    deleted = true;
                }
                
                if (deleted)
                {
                    ds_list_delete(global.__do_later_realtime_list, _i);
                }
                else
                {
                    if (current_time - start_time >= delay)
                    {
                        var _result = callback(); //Execute the callback. If it returns <false>, remove the operation from the list
                        if (!_result && !deleted)
                        {
                            deleted = true;
                            ds_list_delete(global.__do_later_realtime_list, _i);
                        }
                        else
                        {
                            start_time += delay;
                            _i++;
                        }
                    }
                    else
                    {
                        _i++;
                    }
                }
            }
        }
        
        //Check for trigger operations having fired
        var _i = 0;
        repeat(ds_list_size(global.__do_later_trigger_list))
        {
            with(global.__do_later_trigger_list[| _i])
            {
                var _trigger_self  = method_get_self(trigger );
                var _callback_self = method_get_self(callback);
                
                //If either instance scoped to our functions has been destroyed, delete this operation
                if (DO_LATER_IGNORE_DESTROYED_INSTANCES
                && ((!is_struct(_trigger_self ) && !is_undefined(_trigger_self ) && !instance_exists(_trigger_self.id ))
                ||  (!is_struct(_callback_self) && !is_undefined(_callback_self) && !instance_exists(_callback_self.id))))
                {
                    deleted = true;
                }
                
                if (deleted)
                {
                    ds_list_delete(global.__do_later_trigger_list, _i);
                }
                else
                {
                    if (trigger())
                    {
                        var _result = callback(); //Execute the callback. If it returns <false>, remove the operation from the list
                        if (!_result && !deleted)
                        {
                            deleted = true;
                            ds_list_delete(global.__do_later_trigger_list, _i);
                        }
                        else
                        {
                            _i++;
                        }
                    }
                    else
                    {
                        _i++;
                    }
                }
            }
        }
        
        //Check for async operations timing out
        DO_LATER_ASYNC_TIMED_OUT = true;
        
        var _i = 0;
        repeat(ds_list_size(global.__do_later_async_list))
        {
            with(global.__do_later_async_list[| _i])
            {
                //If the instance that the function is scoped to has been destroyed, delete this operation
                var _callback_self = method_get_self(callback);
                if (DO_LATER_IGNORE_DESTROYED_INSTANCES && !is_struct(_callback_self) && !is_undefined(_callback_self) && !instance_exists(_callback_self.id))
                {
                    deleted = true;
                }
                
                if (deleted)
                {
                    ds_list_delete(global.__do_later_async_list, _i);
                }
                else if (current_time - start_time >= timeout) //If this operation has timed out
                {
                    //Execute the callback and remove the reference from the async operation list
                    callback();
                    
                    if (!deleted)
                    {
                        deleted = true;
                        ds_list_delete(global.__do_later_async_list, _i);
                    }
                }
                else
                {
                    _i++;
                }
            }
        }
        
        //Reset the timeout state
        DO_LATER_ASYNC_TIMED_OUT = undefined;
    }
}

#macro __DO_LATER_VERSION            "3.0.1"
#macro __DO_LATER_DATE               "2020/08/01"
#macro __DO_LATER_APPROX_FRAME_TIME  floor(game_get_speed(gamespeed_microseconds)/1000)
#macro DO_LATER_ASYNC_TIMED_OUT      global.__do_later_async_timed_out
#macro DO_LATER_ASYNC_LOAD           global.__do_later_async_load

show_debug_message("Do Later: " + __DO_LATER_VERSION + " @jujuadams " + __DO_LATER_DATE);

global.__do_later_list            = ds_list_create();
global.__do_later_realtime_list   = ds_list_create();
global.__do_later_trigger_list    = ds_list_create();
global.__do_later_signal_map      = ds_map_create();
global.__do_later_async_list      = ds_list_create();
global.__do_later_last_tick       = -1;
global.__do_later_async_timed_out = undefined;
global.__do_later_async_load      = ds_map_create();