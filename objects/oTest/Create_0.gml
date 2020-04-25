var _id = http_get("http://www.google.com/");
DoLaterAsync("HTTP", ["id", _id], function() { show_message(json_encode(async_load)) }, undefined);