// Feather disable all

function DoLaterGetParent()
{
    static _system = __DoLaterSystem();
    
    return _system.__parent;
}