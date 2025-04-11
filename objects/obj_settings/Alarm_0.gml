// This gets called after settings are applied to update the surface
if (instance_exists(obj_load_light)) {
    with (obj_load_light) {
        // If calculate_adaptive_scaling() function exists in obj_load_light, call it
        if (variable_instance_exists(id, "calculate_adaptive_scaling")) {
            calculate_adaptive_scaling();
        }
    }
}

// Also update the application surface based on current resolution
if (room != rm_title && room != rm_first_loading_phase && room != rm_second_loading_phase) {
    var _base_width = 320;
    var _base_height = 180;
    
    // If in fullscreen mode, adapt to the display
    if (applied_display_mode != DISPLAY_MODE.WINDOWED) {
        var _display_width = display_get_width();
        var _display_height = display_get_height();
        var _scale_x = _display_width / _base_width;
        var _scale_y = _display_height / _base_height;
        
        // For preserve mode, use min scale to maintain aspect ratio
        if (applied_display_mode == DISPLAY_MODE.FULLSCREEN_PRESERVE) {
            var _scale = min(_scale_x, _scale_y);
            surface_resize(application_surface, _base_width, _base_height);
        }
        // For stretch mode, adapt surface to fill entire screen
        else if (applied_display_mode == DISPLAY_MODE.FULLSCREEN_STRETCH) {
            // For stretch mode, we need to adjust the internal resolution
            // while keeping it proportional to maintain crisp pixels
            var _scale = min(_scale_x, _scale_y);
            var _new_width = round(_display_width / _scale);
            var _new_height = round(_display_height / _scale);
            surface_resize(application_surface, _new_width, _new_height);
        }
    }
    // In windowed mode, use base resolution
    else {
        surface_resize(application_surface, _base_width, _base_height);
    }
}