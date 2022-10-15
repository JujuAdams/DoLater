if (keyboard_check_pressed(vk_escape))
{
    //Test stopping
    time_source_stop(framesLoop);
    
    //Test early destruction
    time_source_destroy(msLoop);
}