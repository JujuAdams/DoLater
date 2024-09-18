// Feather disable all

/// Sets the global parent for newly created DoLater time sources. The global parent can be reset
/// to `DO_LATER_DEFAULT_PARENT` by calling `DoLaterResetParent()`.
/// 
/// @param parent

function DoLaterSetParent(_parent)
{
    static _system = __DoLaterSystem();
    
    _system.__parent = _parent;
}