var _id = http_get("http://www.google.com/");
do_later_async(DO_LATER_EVENT.HTTP,
               {
                   async_id : _id
               },
               function(_timeout) {
                   if (!_timeout && (async_load[? "id"] == async_id) && (async_load[? "status"] == 0))
                   {
                       show_message(json_encode(async_load));
                       return true;
                   }
               },
               1000);