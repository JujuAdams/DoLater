/*
    "DoLater"
    A tiny library to allow for deferred code execution, either dependent on time or some sort of trigger.
    This can be used as a more convenient alternative to GameMaker's internal alarm system.
    Call DoLaterTick() in a Step event of a persistent object!
    
    Usage:
    
    DoLaterTick(delta_time / game_get_speed(gamespeed_microseconds))
    
    DoLater(120,
            function(data)
            {
                show_message(data.text);
            },
            {
                text : "This text appears once after waiting 120 ticks (usually 120 frames)"
            },
            true);
    
    DoLaterRealtime(2000,
                    function(data)
                    {
                        show_message(data.text);
                    },
                    {
                        text : "This text appears after waiting 2000ms, and will continue to appear every 2000ms"
                    },
                    false);
    
    DoLaterTrigger(function(data)
                   {
                      return (mouse_x > data.limit);
                   },
                   function(data)
                   {
                       show_message(data.text);
                   },
                   {
                       limit : 1300,
                       text : "This text appears once when the mouse moves 1300px to the right"
                   },
                   true);
    
    DoLaterListen("bingbong",
                  function(listenerData, broadcastData)
                  {
                      show_message(listenerData.text + "\n\n" + broadcastData);
                  },
                  {
                      text : "This text appears every time the \"bingbong\" event is broadcast"
                  },
                  false);
    
    DoLaterBroadcast("bingbong", "The shop is now closing.");
    
    DoLaterAsync("HTTP",
                 ["id", http_get("http://www.google.com/")],
                 function(data)
                 {
                     show_debug_message(data);
                     show_debug_message(json_encode(async_load));
                 },
                 "Google says:");
    
    DoLaterAsyncEvent("HTTP");
*/

#macro __DO_LATER_VERSION  "1.2.0"
#macro __DO_LATER_DATE     "2020/02/13"

show_debug_message("Do Later: " + __DO_LATER_VERSION + " @jujuadams " + __DO_LATER_DATE);

global.__DoLater         = ds_list_create();
global.__DoLaterRealtime = ds_list_create();
global.__DoLaterTrigger  = ds_list_create();
global.__DoLaterListen   = ds_map_create();
global.__DoLaterAsync    = ds_list_create();

//Queue a function for execution after a period of time
//The "delay" parameter is in frames (though DoLaterTick() allows for delta timing)
//The function should take one argument, a struct
//The data struct specified when calling DoLater() will be passed to the function
function DoLater(delay, callbackFunction, callbackData, once)
{
    if (delay <= 0)
    {
        callbackFunction(callbackData);
        return undefined;
    }
    else
    {
        var struct =
        {
            callback : callbackFunction,
            data     : callbackData,
            delay    : delay,
            ticks    : 0,
            once     : once
        }
        
        ds_list_add(global.__DoLater, struct);
        return struct;
    }
}

//Call this update function in a step event. Use 1 for the tick size if you don't want to use delta timing
function DoLaterTick(tickSize)
{
    var i = 0;
    repeat(ds_list_size(global.__DoLater))
    {
        var struct = global.__DoLater[| i];
        struct.ticks += tickSize;
        if (struct.ticks >= struct.delay)
        {
            if (struct.once)
            {
                ds_list_delete(global.__DoLater, i);
            }
            else
            {
                struct.ticks -= struct.delay;
                i++;
            }
            
            struct.callback(struct.data);
        }
        else
        {
            i++;
        }
    }
    
    var i = 0;
    repeat(ds_list_size(global.__DoLaterRealtime))
    {
        var struct = global.__DoLaterRealtime[| i];
        if (struct.end_time <= current_time)
        {
            if (struct.once)
            {
                ds_list_delete(global.__DoLaterRealtime, i);
            }
            else
            {
                struct.end_time += struct.delay;
                i++;
            }
            
            struct.callback(struct.data);
        }
        else
        {
            i++;
        }
    }
    
    var i = 0;
    repeat(ds_list_size(global.__DoLaterTrigger))
    {
        var struct = global.__DoLaterTrigger[| i];
        if (struct.trigger(struct.data))
        {
            if (struct.once) ds_list_delete(global.__DoLaterTrigger, i) else i++;
            struct.callback(struct.data);
        }
        else
        {
            i++;
        }
    }
}

//Queue a function for execution after a period of time
//The "delay" parameter is in realtime milliseconds
//The callback function should take one argument, a struct
//The callback data specified when calling DoLaterRealtime() will be passed to the callback function
function DoLaterRealtime(delayMS, callbackFunction, callbackData, once)
{
    if (delayMS <= 0)
    {
        callbackFunction(callbackData);
        return undefined;
    }
    else
    {
        var struct =
        {
            callback : callbackFunction,
            data     : callbackData,
            delay    : delayMS,
            end_time : (current_time + delayMS),
            once     : once
        }
        
        ds_list_add(global.__DoLaterRealtime, struct);
        return struct;
    }
}

//Queue a function for execution when another function returns true
//Both the trigger and callback functions should take one argument, a struct
//The data struct specified when calling DoLaterTrigger() will be passed to both functions
function DoLaterTrigger(triggerFunction, callbackFunction, callbackData, once)
{
    if (triggerFunction(callbackData))
    {
        callbackFunction(callbackData)
        return undefined;
    }
    else
    {
        var struct =
        {
            trigger  : triggerFunction,
            callback : callbackFunction,
            data     : callbackData,
            once     : once
        }
        
        ds_list_add(global.__DoLaterTrigger, struct);
        return struct;
    }
}

//Queue a function for execution when a message is broadcast
//The callback functions should take two arguments
function DoLaterListen(message, callbackFunction, callbackData, once)
{
    var struct =
    {
        message  : message,
        callback : callbackFunction,
        data     : callbackData,
        once     : once
    }
    
    var list = global.__DoLaterListen[? message];
    if (list == undefined)
    {
        list = ds_list_create();
        ds_map_add_list(global.__DoLaterListen, message, list);
    }
    
    ds_list_add(list, struct);
    return struct;
}

//Broadcast a message that is picked up by functions defined via DoLaterListen()
function DoLaterBroadcast(message, broadcastData)
{
    var list = global.__DoLaterListen[? message];
    if (list != undefined)
    {
        var i = 0;
        repeat(ds_list_size(list))
        {
            var struct = list[| i];
            if (struct.once) ds_list_delete(list, i) else i++;
            struct.callback(struct.data, broadcastData);
        }
    }
}

//Define a function for execution when an async event is triggered
//The async event should be the name of the async event as a string
//The "conditionArrays" parameter should be a simple 2D array: [key0, expectedValue0, key1, expectedValue1...]
//The "conditionsArray" array checks against async_load that GameMaker generates in async events
//The callback function should take one argument
//The data struct specified when calling DoLaterAsyncEvent() will be passed to the callback function
function DoLaterAsync(asyncEventName, conditionsArray, callbackFunction, callbackData)
{
    var struct =
    {
        event      : asyncEventName,
        conditions : conditionsArray,
        callback   : callbackFunction,
        data       : callbackData
    }
    
    ds_list_add(global.__DoLaterAsync, struct);
    return struct;
}

//Calls any suitable function defined by DoLaterAsyncEvent()
//The async event should be the name of the async event as a string
function DoLaterAsyncWatcher(asyncEventName)
{
    var i = 0;
    repeat(ds_list_size(global.__DoLaterAsync))
    {
        var struct = global.__DoLaterAsync[| i];
        if (struct.event != asyncEventName)
        {
            i++;
            continue;
        }
        
        var pass = true;
        var conditions = struct.conditions;
        
        var j = 0;
        repeat(array_length(conditions) div 2)
        {
            if (async_load[? conditions[j]] != conditions[j+1])
            {
                pass = false;
                break;
            }
            
            j += 2;
        }
        
        if (pass)
        {
            struct.callback(struct.data);
            ds_list_delete(global.__DoLaterAsync, i);
        }
        else
        {
            i++;
        }
    }
}
