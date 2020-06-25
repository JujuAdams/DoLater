/// Updates Do Later's internal systems, executing any appropriate functions
/// This function should be called one per frame in an instance (typically a persistent instance)
///
/// @return N/A (0)

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
                if (deleted)
                {
                    ds_list_delete(global.__do_later_list, _i);
                }
                else
                {
                    ticks++;
                    if (ticks >= delay)
                    {
                        callback();
                        
                        if (once || deleted)
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
                if (deleted)
                {
                    ds_list_delete(global.__do_later_realtime_list, _i);
                }
                else
                {
                    if (current_time - start_time >= delay)
                    {
                        callback();
                        
                        if (once || deleted)
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
                if (deleted)
                {
                    ds_list_delete(global.__do_later_trigger_list, _i);
                }
                else
                {
                    if (trigger())
                    {
                        callback();
                        
                        if (once || deleted)
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
        var _i = 0;
        repeat(ds_list_size(global.__do_later_async_list))
        {
            with(global.__do_later_async_list[| _i])
            {
                if (deleted)
                {
                    ds_list_delete(global.__do_later_async_list, _i);
                }
                else
                {
                    if (current_time - start_time >= timeout)
                    {
                        //Execute the callback, but with argument0 set <true> to indicate the operation has timed out
                        callback(true);
                        
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

#macro __DO_LATER_VERSION            "2.0.0"
#macro __DO_LATER_DATE               "2020/06/25"
#macro __DO_LATER_APPROX_FRAME_TIME  floor(game_get_speed(gamespeed_microseconds)/1000)

show_debug_message("Do Later: " + __DO_LATER_VERSION + " @jujuadams " + __DO_LATER_DATE);

global.__do_later_list          = ds_list_create();
global.__do_later_realtime_list = ds_list_create();
global.__do_later_trigger_list  = ds_list_create();
global.__do_later_signal_map    = ds_map_create();
global.__do_later_async_list    = ds_list_create();
global.__do_later_last_tick     = -1;