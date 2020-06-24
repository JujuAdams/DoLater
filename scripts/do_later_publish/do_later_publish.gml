//Broadcast a signal that executes associated functions defined via do_later_subscribe()

/// @param signal
/// @param callbackParameter
function do_later_publish(_signal, _callback_parameter)
{
    var list = global.__do_later_signal_map[? _signal];
    if (list != undefined)
    {
        var _i = 0;
        repeat(ds_list_size(list))
        {
            var struct = list[| _i];
            if (struct.once) ds_list_delete(list, _i) else _i++;
            struct.callback(_callback_parameter);
        }
    }
}

/// @param signal
/// @param callbackParameter
function do_later_pub(_signal, _callback_parameter)
{
    return do_later_publish(_signal, _callback_parameter);
}