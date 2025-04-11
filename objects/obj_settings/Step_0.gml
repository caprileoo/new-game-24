// Check if display resolution has changed
var _current_display_width = display_get_width();
var _current_display_height = display_get_height();

if (_current_display_width != display_width || _current_display_height != display_height) {
    // Update the stored dimensions
    display_width = _current_display_width;
    display_height = _current_display_height;
    is_ultrawide = (display_width / display_height) >= 2.0;
    
    // Trigger the alarm to update scaling
    alarm[0] = 1;
}

// Emergency reset - if user presses F11, reset to 720p windowed
if (keyboard_check_pressed(vk_f11)) {
    selected_resolution = RESOLUTION.RES_720P;
    selected_display_mode = DISPLAY_MODE.WINDOWED;
    applied_resolution = selected_resolution;
    applied_display_mode = selected_display_mode;
    
    window_set_size(
        resolution_width[applied_resolution],
        resolution_height[applied_resolution]
    );
    window_set_fullscreen(false);
    window_center();
    
    // Update the application surface
    alarm[0] = 1;
}