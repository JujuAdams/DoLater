<h1 align="center">DoLater 1.0.0</h1>

<p align="center">Deferred code execution for GameMaker Studio 2.3.0 by <b>@jujuadams</b></p>

&nbsp;

**DoLater** functions all share the same basic behaviour: the `callbackFunction` will be executed once the required conditions are met. The `callbackData` value (which can be any datatype, including an array or a struct) is passed into `callbackFunction` when it is executed. Some **DoLater** functions have a `once` argument; if `once` is set to `false`, `callbackFunction` will be called repeatedly.

&nbsp;

### DoLaterTick(tickSize) ###

Call in a Step event to update the library. `tickSize` affects how quickly `DoLater()` timers are counted down; a `tickSize` of `0.5` for example will cause `DoLater()` functions to be called after twice the defined number of frames. Use a `tickSize` of `1` if you don't want to use delta timing.

&nbsp;

### DoLater(delayFrames, callbackFunction, callbackData, once) ###

Sets up a function to be executed after a certain number of frames, as defined by `delayFrames`. `DoLaterTick()` must be called in an instance's Step event for a `DoLater()` function to be executed.

&nbsp;

### DoLaterRealtime(delayMS, callbackFunction, callbackData, once) ###

Sets up a function to be executed after a certain number of realtime milliseconds, as defined by `delayMS`. `DoLaterTick()` must be called in an instance's Step event for a `DoLater()` function to be executed.

&nbsp;

### DoLaterTrigger(triggerFunction, callbackFunction, callbackData, once) ###

Sets up a function to be executed once the `triggerFunction` returns `true`. `DoLaterTick()` must be called in an instance's Step event for a `DoLater()` function to be executed. `triggerFunction` is executed in the scope of the instance that calls `DoLaterTick()`.

&nbsp;

### DoLaterListen(message, callbackFunction, callbackData, once) ###

Sets up a function to be executed once the global message `message` is broadcast by `DoLaterBroadcast()`. The `callbackFunction` will be executed in the scope of the instance that calls `DoLaterBroadcast()`. The callback function is passed `callbackData` as `argument0` from `DoLaterListen()` **and is also** passed `broadcastData` from `DoLaterBroadcast()` as `argument1`.

&nbsp;

### DoLaterBroadcast(message, broadcastData) ###

Executes functions associated with the global message `message` (see above). `broadcastData1` is passed into the callback function as `argument1`.

&nbsp;

### DoLaterAsync(asyncEventName, conditionsArray, callbackFunction, callbackData) ###

Sets up a function to be executed when an async event is returned, provided that the async event matches `asyncEventName` and matches `conditionsArray`.

&nbsp;

### DoLaterAsyncWatcher(asyncEventName) ###

&nbsp;
