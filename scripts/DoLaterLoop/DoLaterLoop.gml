// Feather disable all

/// Creates a one-shot time source that executes a function after a certain number of frames
/// repeatedly until stoppped with `time_source_stop()`. The time source's parent will be
/// `DO_LATER_DEFAULT_PARENT` unless overriden by `DoLaterSetParent()`.
/// 
/// @param frames
/// @param function
/// @param argument
/// @param ...

function DoLaterLoop()
{
    static _system = __DoLaterSystem();
    
    var _frames   = argument[0];
    var _function = argument[1];
    
    var _arguments = array_create(argument_count-2);
    var _i = 0;
    repeat(argument_count-2)
    {
        _arguments[@ _i] = argument[_i+2];
        ++_i;
    }
    
    var _ts = time_source_create(_system.__parent, _frames, time_source_units_frames, _function, _arguments, -1);
    time_source_start(_ts);
    array_push(_system.__array, _ts);
    
    return _ts;
}