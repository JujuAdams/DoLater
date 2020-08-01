do_later(45,
         function() {
             show_message("Executed every 45 frames continuously!");
             return true; //Repeat this forever
         });

with({ message : "You can use structs as temporary containers for callbacks (effectively a closure)" })
{
    do_later_realtime(200,
                      function() {
                          show_message(message);
                          return false; //Don't repeat this - only execute it once
                      });
}

hello_count = 0;
do_later_trigger(function() { return (hello_count == 3) },
                 function() { show_message("You said hello three times"); });

do_later_subscribe("announce",
                   function(_data) {
                       hello_count++;
                       show_debug_message(_data);
                       return true; //Keep this subscriber alive forever
                   });

var _id = http_get("http://www.google.com/");
with({ async_id : _id })
{
    do_later_async(DO_LATER_EVENT.HTTP,
                   5000,
                   function(_timeout) {
                       if (_timeout)
                       {
                           show_message("HTTP request timed out");
                       }
                       else if ((async_load[? "id"] == async_id) && (async_load[? "status"] == 0))
                       {
                           show_message("Got an HTTP response ;)");
                           //return true;
                       }
                   });
}