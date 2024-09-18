// Feather disable all

/// Helper function to create an inert time source. This time source can be used as a parent
/// allowing you to pause or stop groups of time sources.
/// 
/// The `parent` optional parameter for the function allows you to specify a parent for the newly
/// created time source. This allows for complex chains of parenting which is usually unnecessary
/// but the option is there if you need it.
/// 
/// @param [parent=DO_LATER_DEFAULT_PARENT]

function DoLaterCreateParent(_parent = DO_LATER_DEFAULT_PARENT)
{
    return time_source_create(_parent, -1, time_source_units_seconds, function() {}, [], -1);
}