// Feather disable all

/// Returns the current global parent for DoLater time sources created in the future. This function
/// will return `DO_LATER_DEFAULT_PARENT` unless `DoLaterSetParent()` has been called.

function DoLaterGetParent()
{
    static _system = __DoLaterSystem();
    
    return _system.__parent;
}