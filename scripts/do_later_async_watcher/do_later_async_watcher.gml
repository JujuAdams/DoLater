//Calls any suitable function defined by do_later_async()
//The async event should be the name of the async event as a string

/// @param eventName

function do_later_async_watcher(_event_name)
{
    var _i = 0;
    repeat(ds_list_size(global.__do_later_async_list))
    {
        var _struct = global.__do_later_async_list[| _i];
        if (_struct.event != _event_name)
        {
            _i++;
            continue;
        }
        
        var _pass = true;
        var _conditions = _struct.conditions;
        
        var _j = 0;
        repeat(array_length(_conditions) div 2)
        {
            if (async_load[? _conditions[_j]] != _conditions[_j+1])
            {
                _pass = false;
                break;
            }
            
            _j += 2;
        }
        
        if (_pass)
        {
            _struct.callback();
            ds_list_delete(global.__do_later_async_list, _i);
        }
        else
        {
            _i++;
        }
    }
}