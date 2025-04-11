gpu_set_blendmode_ext(bm_one, bm_zero);

if (instance_exists(obj_settings)) {
    var _window_width = window_get_width();
    var _window_height = window_get_height();
    
    // Base game dimensions
    var _base_width = 320;
    var _base_height = 180;
    
    // Get aspect ratios
    var _game_aspect = _base_width / _base_height;
    var _window_aspect = _window_width / _window_height;
    var _is_ultrawide = (_window_aspect >= 2.0);
    
    // Check display mode
    if (obj_settings.applied_display_mode != DISPLAY_MODE.WINDOWED) {
        // First, draw black background to fill the entire screen
        draw_set_color(c_black);
        draw_rectangle(0, 0, _window_width, _window_height, false);
        draw_set_color(c_white);
        
        if (obj_settings.applied_display_mode == DISPLAY_MODE.FULLSCREEN_PRESERVE) {
            // Maintain aspect ratio
            var _scale_x = _window_width / _base_width;
            var _scale_y = _window_height / _base_height;
            var _scale = min(_scale_x, _scale_y);
            
            // Calculate position to center the game
            var _x_pos = (_window_width - (_base_width * _scale)) / 2;
            var _y_pos = (_window_height - (_base_height * _scale)) / 2;
            
            // Draw the game surface
            draw_surface_ext(application_surface, _x_pos, _y_pos, _scale, _scale, 0, c_white, 1);
        } 
        else if (obj_settings.applied_display_mode == DISPLAY_MODE.FULLSCREEN_STRETCH) {
            // Stretch to fill (will distort pixel art on non-16:9 monitors)
            draw_surface_ext(application_surface, 0, 0, 
                            _window_width / _base_width, 
                            _window_height / _base_height, 
                            0, c_white, 1);
        }
    } 
    else {
        // Windowed mode - use the predetermined scale factors
        var _scale = obj_settings.scale_factor[obj_settings.applied_resolution];
        draw_surface_ext(application_surface, 0, 0, _scale, _scale, 0, c_white, 1);
    }
} 
else {
    // Default scaling if settings don't exist
    draw_surface_ext(application_surface, 0, 0, 4, 4, 0, c_white, 1);
}

gpu_set_blendmode(bm_normal);