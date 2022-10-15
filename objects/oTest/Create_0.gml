var _funcPopUp = function(_message)
{
    show_message(_message);
}

var _funcDebugMessage = function(_message)
{
    show_debug_message(_message);
}

DoLater(75, _funcPopUp, "This will pop up after 90 frames (1.5 seconds)");
DoLaterMs(1000, _funcPopUp, "This will pop up after 1000ms (1 seconds)");
msLoop = DoLaterMsLoop(1000, _funcDebugMessage, "This will appear in the debug log every 1500ms (1.5 seconds)");
framesLoop = DoLaterLoop(40, _funcDebugMessage, "This will appear in the debug log every 40 frames");