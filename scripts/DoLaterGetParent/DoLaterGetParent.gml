// Feather disable all

function DoLaterGetParent()
{
    static _global = __DoLaterInitialize();
    
    return _global.__parent;
}