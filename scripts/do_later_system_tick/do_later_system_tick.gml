#macro __DO_LATER_VERSION            "2.0.0"
#macro __DO_LATER_DATE               "2020/06/24"
#macro __DO_LATER_APPROX_FRAME_TIME  floor(game_get_speed(gamespeed_microseconds)/1000)

show_debug_message("Do Later: " + __DO_LATER_VERSION + " @jujuadams " + __DO_LATER_DATE);

global.__do_later_list          = ds_list_create();
global.__do_later_realtime_list = ds_list_create();
global.__do_later_trigger_list  = ds_list_create();
global.__do_later_signal_map    = ds_map_create();
global.__do_later_async_list    = ds_list_create();
global.__do_later_last_tick     = -1;

function do_later_system_tick()
{
    //Ensure that this is only ticked once a frame (give or take)
    if ((global.__do_later_last_tick < 0) || (current_time - global.__do_later_last_tick > __DO_LATER_APPROX_FRAME_TIME))
    {
        global.__do_later_last_tick = current_time;
        
        var i = 0;
        repeat(ds_list_size(global.__do_later_list))
        {
            var struct = global.__do_later_list[| i];
            struct.ticks++;
            if (struct.ticks >= struct.delay)
            {
                if (struct.once)
                {
                    ds_list_delete(global.__do_later_list, i);
                }
                else
                {
                    struct.ticks -= struct.delay;
                    i++;
                }
                
                struct.callback();
            }
            else
            {
                i++;
            }
        }
        
        var i = 0;
        repeat(ds_list_size(global.__do_later_realtime_list))
        {
            var struct = global.__do_later_realtime_list[| i];
            if (current_time - struct.start_time >= struct.delay)
            {
                if (struct.once)
                {
                    ds_list_delete(global.__do_later_realtime_list, i);
                }
                else
                {
                    struct.start_time += struct.delay;
                    i++;
                }
                
                struct.callback();
            }
            else
            {
                i++;
            }
        }
        
        var i = 0;
        repeat(ds_list_size(global.__do_later_trigger_list))
        {
            var struct = global.__do_later_trigger_list[| i];
            if (struct.trigger())
            {
                if (struct.once) ds_list_delete(global.__do_later_trigger_list, i) else i++;
                struct.callback();
            }
            else
            {
                i++;
            }
        }
    }
}