// Feather disable all

/// @param parent

function DoLaterSetParent(_parent)
{
    static _system = __DoLaterSystem();
    
    _system.__parent = _parent;
}