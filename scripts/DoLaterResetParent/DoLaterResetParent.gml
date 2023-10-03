// Feather disable all

function DoLaterResetParent()
{
    static _global = __DoLaterInitialize();
    
    DoLaterSetParent(DO_LATER_DEFAULT_PARENT);
}