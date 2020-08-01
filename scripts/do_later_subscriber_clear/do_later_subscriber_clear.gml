/// Destroy all operations that are subscribed to the given signal
///
/// @return N/A (undefined)
/// @param signal   Signal to clear out. This can be any datatype, but is typically a string or an enum/macro

function do_later_subscriber_clear(_signal)
{
    var _list = global.__do_later_signal_map[? _signal];
    if (_list != undefined)
    {
        ds_list_destroy(_list);
        ds_map_delete(global.__do_later_signal_map, _signal);
    }
}