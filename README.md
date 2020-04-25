<p align="center"><img src="https://raw.githubusercontent.com/JujuAdams/DoLater/master/LOGO.png" style="display:block; margin:auto; width:300px"></p>
<h1 align="center">1.2.0</h1>

<p align="center">Deferred code execution for GameMaker Studio 2.3.0</p>

&nbsp;

DoLater is a small library to make it easier to execute code after a certain amount of time has passed, a trigger condition has been met, and an async event has fired. Traditionally these tasks have required a lot of boilerplate code but, thanks to GMS2.3.0's new GML features, it's easier than ever to keep code clean and organised.

&nbsp;

DoLater functions all share the same basic behaviour: the `callbackFunction` will be executed once some required conditions are met. The `callbackData` value (which can be any datatype, including an array or a struct) is passed into `callbackFunction` when it is executed as `argument0`. Some DoLater functions have a `once` argument; if `once` is set to `false`, the timer/trigger for the queued function will be reset and the function will be able to fire again repeatedly.

**Tip:** As mentioned, `callbackFunction` can be passed data via `callbackData`. Take advantage of this by passing in crucial information, such as which instance queued the callback function and any other contextual information you might need.

&nbsp;

## Functions ##

### DoLaterTick(tickSize) ###

**`DoLaterTick()` must be called in a Step event to update the library.** `tickSize` controls how quickly `DoLater()` frame timers are counted down. This feature is intended to be used to accomplish delta timing. Use a `tickSize` of `1` if you don't want to use delta timing.

&nbsp;

### DoLater(delayFrames, callbackFunction, callbackData, once) ###

Sets up a function to be executed after a certain number of frames, as defined by `delayFrames`. `DoLaterTick()` must be called in an instance's Step event for a `DoLater()` function to be executed.

_Example:_
```GML
DoLater(60, //After 60 frames
        function(data) {
            show_message(data); //Show a message
        },
        "Hello world!", //Set our message to "Hello world!"
        true); //Do it once
```

&nbsp;

### DoLaterRealtime(delayMS, callbackFunction, callbackData, once) ###

Sets up a function to be executed after a certain number of realtime milliseconds, as defined by `delayMS`. `DoLaterTick()` must be called in an instance's Step event for a `DoLater()` function to be executed.

_Example:_
```GML
DoLaterRealtime(1000, //After 1 second
                function(data) {
                    show_message(data); //Show a message
                },
                "Hello world!", //Set our message to "Hello world!"
                false); //Show the message again and again for maximum annoyance
```

&nbsp;

### DoLaterTrigger(triggerFunction, callbackFunction, callbackData, once) ###

Sets up a function to be executed once the `triggerFunction` returns `true`. `DoLaterTick()` must be called in an instance's Step event for a `DoLater()` function to be executed. `triggerFunction` is executed in the scope of the instance that calls `DoLaterTick()`, and is passed `callbackData` as `argument0`.

_Example:_
```GML
DoLaterTrigger(function(data) { //Trigger Function
                   //Trigger the callback function if our instance doesn't exist
                   if (!instance_exists(data.instance)) return true;
                   return false;
               },
               function(data) { //Callback Function
                   show_message("dead :("); //Show a message
               },
               { instance : id }, //Pass the instance id into the trigger and callback function
               true); //Do it once
```

&nbsp;

### DoLaterListen(message, callbackFunction, callbackData, once) ###

Sets up a function to be executed once the global message `message` is broadcast by `DoLaterBroadcast()`. In addition to `callbackData`, the callback function is passed `broadcastData` from `DoLaterBroadcast()` as `argument1`.

_Example:_
```GML
DoLaterListen("yell", //When we received the "yell" message
              function(callbackData, broadcastData) {
                  show_message(string(callbackData.name) + ": " + broadcastData); //Show a message
              },
              { name : "Lunacharsky" }, //Pass our name into the callback function when it's executed
              false); //Always listen for the "yell" message
```

&nbsp;

### DoLaterBroadcast(message, broadcastData) ###

Executes functions associated with the global message `message` (see above). `broadcastData1` is passed into the callback function as `argument1`.

_Example:_
```GML
DoLaterBroadcast("yell", //Send out the "yell" message
                 "LOUD NOISES"); //Get every "yell" listener to say "LOUD NOISES"
```

&nbsp;

### DoLaterAsync(asyncEventName, conditionsArray, callbackFunction, callbackData) ###

Sets up a function to be executed when an async event is returned, provided that the async event matches `asyncEventName` and matches `conditionsArray`. Call `DoLasterAsyncWatcher()` in the associated async event to execute functions queued via `DoLaterAsync()`.

The `conditionArray` is an array made of key:value pairs, stored sequentially, that are checked against GameMaker's native `async_load` ds_map when `DoLaterAsyncWatcher()` is called. The first value in each pair is the key that should be found in `async_load`, the second value is the expected value to be found by reading `async_load[? <key>]`.

For example if we expect `async_load[? "id"] == 20` then our `conditionsArray` will be `["id", 20]`. If we expect `async_load[? "id"] == 20) && (async_load[? "status"] == true)` then our `conditionsArray` will be `["id", 20, "status", true]`.

_Example:_
```GML
var _id = buffer_save_async(_buffer, _filename, 0, buffer_get_size(_buffer));
DoLaterAsync("save/load", //Wait for a "save/load" reponse from DoLaterAsyncWatcher()
             ["id", _id], //Set our condition to async_load[? "id"] == _id
             function(data) {
                 if (async_load[? "status"]) //Show a message based on the save status
                 {
                     show_message(data + " saved successfully);
                 }
                 else
                 {
                     show_message(data + " didn't save :(");
                 }
             },
             _filename); //Set the callback function's argument0 to the filename
```

&nbsp;

### DoLaterAsyncWatcher(asyncEventName) ###

Executes all `DoLaterAsync()` functions that match `asyncEventName` and have their `conditionsArray` satisfied (see above).

_Example:_
```GML
///Save/Load Async Event
DoLaterAsyncWatcher("save/load"); //Trigger any DoLastAsync() functions waiting for a Save/Load async event
```
