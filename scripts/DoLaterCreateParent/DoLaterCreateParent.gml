// Feather disable all

/// @param parent

function DoLaterCreateParent(_parent)
{
    return time_source_create(_parent, -1, time_source_units_seconds, function() {}, [], -1);
}