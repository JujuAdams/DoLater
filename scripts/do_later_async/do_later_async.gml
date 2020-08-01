/// Defines a function for execution when an async event of a specific type is received
/// do_later_async_event_receiver() must be called in the required async event for operations created with do_later_async() to be executed
/// 
/// The function passed into do_later_async() should read DO_LATER_ASYNC_LOAD instead of GM's native async_load
/// This function is also called if and when the operation times out. Check DO_LATER_ASYNC_TIMED_OUT to determine if the operation has timed out
/// The function should also return <true> if the operation should be deleted from Do Later's list of pending async operations
/// Make sure that the function returns <true> when an operation has completed otherwise you'll receive erroneous timeouts
///
/// @return A struct that represents the created and queued operation
/// @param eventCode   Async event to target. Use values from the DO_LATER_EVENT enum
/// @param timeout     Milliseconds to wait before declaring the operation as timed-out
/// @param function    Function/method to execute

enum DO_LATER_EVENT
{
    AUDIO_PLAYBACK,    //Audio Playback     ev_audio_playback
    AUDIO_RECORDING,   //Audio Recording    ev_audio_recording
    CLOUD,             //Cloud              ev_web_cloud
    DIALOG,            //Dialog             ev_dialog_async
    HTTP,              //HTTP               ev_web_async
    IN_APP_PURCHASE,   //In-App Purchase    ev_web_iap
    IMAGE_LOADED,      //Image Loaded       ev_web_image_load
    NETWORKING,        //Networking         ev_web_networking
    PUSH_NOTIFICATION, //Push Notification  ev_push_notification
    SAVE_LOAD,         //Save/Load          ev_async_save_load
    SOCIAL,            //Social             ev_social
    STEAM,             //Steam              ev_web_steam
    SYSTEM             //System             ev_system_event
}

function do_later_async(_event_code, _timeout, _callback)
{
    return do_later_async_ext(_event_code, _timeout, _callback, -1);
}

/// @return A struct that represents the created and queued operation
/// @param eventCode         Async event to target. Use values from the DO_LATER_EVENT enum
/// @param timeout           Milliseconds to wait before declaring the operation as timed-out
/// @param function          Function to execute. This function is rebound to the provided scope
/// @param struct/instance   Scope to execute the function in, which can be an instance or a struct. If scope is a numeric value less than 0 then the function will not be re-scoped
function do_later_async_ext(_event_code, _timeout, _callback, _scope)
{
    if (!is_numeric(_scope) || (_scope >= 0)) _callback = method(_scope, _callback);
    
    var _struct = {
        list        : global.__do_later_async_list,
        event_typ   : undefined,
        event_num   : undefined,
        callback    : _callback,
        timeout     : _timeout,
        start_time  : current_time,
        deleted     : false
    }
    
    with(_struct)
    {
        switch(_event_code)
        {
            case DO_LATER_EVENT.AUDIO_PLAYBACK:    event_typ = ev_other; event_num = ev_audio_playback;    break;
            case DO_LATER_EVENT.AUDIO_RECORDING:   event_typ = ev_other; event_num = ev_audio_recording;   break;
            case DO_LATER_EVENT.CLOUD:             event_typ = ev_other; event_num = ev_web_cloud;         break;
            case DO_LATER_EVENT.DIALOG:            event_typ = ev_other; event_num = ev_dialog_async;      break;
            case DO_LATER_EVENT.HTTP:              event_typ = ev_other; event_num = ev_web_async;         break;
            case DO_LATER_EVENT.IN_APP_PURCHASE:   event_typ = ev_other; event_num = ev_web_iap;           break;
            case DO_LATER_EVENT.IMAGE_LOADED:      event_typ = ev_other; event_num = ev_web_async;         break;
            case DO_LATER_EVENT.NETWORKING:        event_typ = ev_other; event_num = ev_web_image_load;    break;
            case DO_LATER_EVENT.PUSH_NOTIFICATION: event_typ = ev_other; event_num = ev_push_notification; break;
            case DO_LATER_EVENT.SAVE_LOAD:         event_typ = ev_other; event_num = ev_async_save_load;   break;
            case DO_LATER_EVENT.SOCIAL:            event_typ = ev_other; event_num = ev_social;            break;
            case DO_LATER_EVENT.STEAM:             event_typ = ev_other; event_num = ev_web_steam;         break;
            case DO_LATER_EVENT.SYSTEM:            event_typ = ev_other; event_num = ev_system_event;      break;
            
            default:
                show_error("do_later_async():\nEvent code \"" + string(_event_code) + "\" not recognised, please use enum DO_LATER_EVENT\n ", false);
                return undefined;
            break;
        }
    }
    
    ds_list_add(global.__do_later_async_list, _struct);
    return _struct;
}