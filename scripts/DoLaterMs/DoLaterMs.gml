// Feather disable all

/// @param milliseconds
/// @param function
/// @param argument
/// @param ...

function DoLaterMs()
{
    static _system = __DoLaterSystem();
    
    var _milliseconds = argument[0];
    var _function     = argument[1];
    
    var _arguments = array_create(argument_count-2);
    var _i = 0;
    repeat(argument_count-2)
    {
        _arguments[@ _i] = argument[_i+2];
        ++_i;
    }
    
    var _ts = time_source_create(_system.__parent, _milliseconds/1000, time_source_units_seconds, _function, _arguments);
    time_source_start(_ts);
    array_push(_system.__array, _ts);
    
    return _ts;
}