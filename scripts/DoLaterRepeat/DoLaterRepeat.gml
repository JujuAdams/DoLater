// Feather disable all

/// Creates a one-shot time source that executes a function after a certain number of frames
/// for a fixed number of repeats. The time source's parent will be `DO_LATER_DEFAULT_PARENT`
/// unless overriden by `DoLaterSetParent()`.
/// 
/// N.B. DoLater presumes that if you manually stop a time source by calling `time_source_stop()`
///      you are not going to restart it.
/// 
/// @param frames
/// @param repeatCount
/// @param function
/// @param argument
/// @param ...

function DoLaterRepeat()
{
    static _system = __DoLaterSystem();
    
    var _frames      = argument[0];
    var _repeatCount = argument[1];
    var _function    = argument[2];
    
    var _arguments = array_create(argument_count-2);
    var _i = 0;
    repeat(argument_count-2)
    {
        _arguments[@ _i] = argument[_i+2];
        ++_i;
    }
    
    var _ts = time_source_create(_system.__parent, _frames, time_source_units_frames, _function, _arguments, _repeatCount);
    time_source_start(_ts);
    array_push(_system.__array, _ts);
    
    return _ts;
}