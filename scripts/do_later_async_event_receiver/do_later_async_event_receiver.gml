/// Calls any suitable function defined by do_later_async()
/// This function should be called in all relevant async events by an instance (typically a persistent instance)
///
/// @return N/A (0)

function do_later_async_event_receiver()
{
    var _i = 0;
    repeat(ds_list_size(global.__do_later_async_list))
    {
        with(global.__do_later_async_list[| _i])
        {
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
                
                //Execute the callback. If it returns true, remove the operation from the list
                if (callback(false))
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