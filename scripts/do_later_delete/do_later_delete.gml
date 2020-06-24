/// @param struct

function do_later_delete(_struct)
{
    if (variable_struct_exists(_struct, "list"))
    {
        var _list = variable_struct_get(_struct, "list");
        var _index = ds_list_find_index(_list, _struct);
        if (_index >= 0) ds_list_delete(_list, _index);
    }
    else if (variable_struct_exists(_struct, "signal"))
    {
        var _signal = variable_struct_get(_struct, "signal");
        
        var _list = global.__do_later_signal_map[? _signal];
        if (_list != undefined)
        {
            var _index = ds_list_find_index(_list, _struct);
            if (_index >= 0) ds_list_delete(_list, _index);
        }
    }
}