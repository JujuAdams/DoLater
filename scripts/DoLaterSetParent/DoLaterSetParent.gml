// Feather disable all

/// @param parent

function DoLaterSetParent(_parent)
{
    static _global = __DoLaterInitialize();
    
    _global.__parent = _parent;
}