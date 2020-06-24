//Define a function for execution when an async event is triggered
//The async event should be the name of the async event as a string
//The "conditionArrays" parameter should be a simple 2D array: [key0, expectedValue0, key1, expectedValue1...]
//The "conditionsArray" array checks against async_load that GameMaker generates in async events
//The callback function should take one argument
//The data struct specified when calling DoLaterAsyncEvent() will be passed to the callback function

/// @param eventName
/// @param conditionsArray
/// @param function
/// @param scope

function do_later_async(_event_name, _conditions, _callback, _scope)
{
    if (!is_numeric(_scope) || (_scope >= 0)) _callback = method(_scope, _callback);
    
    var struct = {
        list       : global.__do_later_async_list,
        event      : _event_name,
        conditions : _conditions,
        callback   : _callback
    }
    
    ds_list_add(global.__do_later_async_list, struct);
    return struct;
}