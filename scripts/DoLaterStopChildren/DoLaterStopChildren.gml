// Feather disable all

/// Stops all child time sources for a parent time source. This will not stop the parent time
/// source so is useful for reseting scheduled function execution e.g. when changing rooms.
/// 
/// @param parent

function DoLaterStopChildren(_parent)
{
    var _childArray = time_source_get_children(_parent);
    
    var _i = 0;
    repeat(array_length(_childArray))
    {
        time_source_destroy(_childArray[_i]);
        ++_i;
    }
}