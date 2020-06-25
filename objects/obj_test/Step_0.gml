do_later_system_tick();

if (keyboard_check_pressed(vk_space)) do_later_publish("announce", "Hello world!");