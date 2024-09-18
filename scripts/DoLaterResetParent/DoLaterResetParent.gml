// Feather disable all

function DoLaterResetParent()
{
    static _system = __DoLaterSystem();
    
    DoLaterSetParent(DO_LATER_DEFAULT_PARENT);
}