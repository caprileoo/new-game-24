// Load Controls
get_controls();

// Mouse input checks
var _mouse_x_pos = device_mouse_x(0);
var _mouse_y_pos = device_mouse_y(0);

op_length = array_length(option[menu_level]);

// Keyboard navigation
var _new_pos = pos + nav_down - nav_up;
if(_new_pos >= op_length){
    _new_pos = 0;
}
if(_new_pos < 0){
    _new_pos = op_length - 1;
}

// Mouse hover detection
var _mouse_over_option = -1;
var _mouse_over_bbox = false;

for (var _i = 0; _i < op_length; _i++) {
    var _option_x = x + op_border;
    var _option_y = y + op_border + op_space * _i;
    var _display_text = option[menu_level, _i];
    
    // Determine the width based on the menu level and option
    if (menu_level == 1) {
        if (_i == 0) { // Display Mode
            _display_text = option[menu_level, _i] + ": " + obj_settings.display_mode_name[obj_settings.selected_display_mode];
        } else if (_i == 1) { // Resolution
            _display_text = option[menu_level, _i] + ": < " + obj_settings.resolution_name[obj_settings.selected_resolution] + " >";
        }
    }
    
    var _option_w = string_width(_display_text) * 0.5; // Scale by 0.5 as in draw
    var _option_h = font_get_size(fnt_main_outline_shade) * 0.5;

    // Check if mouse is within the bounding box of this option
    if (_mouse_x_pos >= _option_x && 
        _mouse_x_pos <= _option_x + _option_w && 
        _mouse_y_pos >= _option_y && 
        _mouse_y_pos <= _option_y + _option_h) {
        _mouse_over_option = _i;
        _mouse_over_bbox = true;
        hovering = true;
        break;
    } else hovering = false;
}

// Update pos based on latest action
if (_mouse_over_option != -1 && !menu_locked) {
    // Check if pos changed when using mouse
    if (pos != _mouse_over_option) {
        audio_play_sound(snd_hover, 0, false);
    }
    pos = _mouse_over_option;
} else if ((nav_up || nav_down) && !menu_locked) {
    // Check if pos changed when using keyboard
    if (pos != _new_pos) {
        audio_play_sound(snd_hover, 0, false);
    }
    pos = _new_pos;
}

// Interaction (keyboard or mouse)
var _interaction_detected = (enter_key) || (left_click && _mouse_over_bbox);

if (_interaction_detected) {
    var _sml = menu_level;

    switch (menu_level) { // pause menu
        case 0:
            switch (pos) {
                case 0:
                    menu_locked = true;
                    if (!instance_exists(obj_warp) && !instance_exists(obj_title_trans) && !instance_exists(obj_respawn_trans)) {
                        var _inst = instance_create_depth(0, 0, -9999, obj_title_trans);
                        _inst.target_rm = target_rm;
                        _inst.final_rm = final_rm;
                    }
                    break; // start game
                case 1: menu_level = 1; break; // settings
                case 2: game_end(); break; // Quit
            }
            break;
        case 1:
            switch (pos) {
                case 0: // Display Mode
                    // Cycle through display modes
                    obj_settings.selected_display_mode = (obj_settings.selected_display_mode + 1) % 3;
                    audio_play_sound(snd_hover, 0, false);
                    break;
                case 1: // Resolution
                    var _changed = false;
                    
                    // Handle mouse click interaction
                    if (left_click && _mouse_over_bbox) {
                        var _option_x = x + op_border;
                        var _display_text = option[menu_level, pos] + ": < " + obj_settings.resolution_name[obj_settings.selected_resolution] + " >";
                        var _text_width = string_width(_display_text) * 0.5;
                        var _arrow_pos = string_pos("<", _display_text);
                        var _left_arrow_width = string_width(string_copy(_display_text, 1, _arrow_pos)) * 0.5;
                        var _right_arrow_pos = string_pos(">", _display_text);
                        
                        // Determine if clicked on left or right arrow
                        if (_mouse_x_pos < _option_x + _left_arrow_width + 10) {
                            // Decrease resolution (left arrow)
                            var _prev_res = obj_settings.selected_resolution - 1;
                            while (_prev_res >= RESOLUTION.RES_720P) {
                                if (obj_settings.resolution_available[_prev_res]) {
                                    obj_settings.selected_resolution = _prev_res;
                                    _changed = true;
                                    break;
                                }
                                _prev_res--;
                            }
                        } else if (_mouse_x_pos > _option_x + string_width(_display_text) * 0.5 - 20) {
                            // Increase resolution (right arrow)
                            var _next_res = obj_settings.selected_resolution + 1;
                            while (_next_res <= RESOLUTION.RES_1440P) {
                                if (obj_settings.resolution_available[_next_res]) {
                                    obj_settings.selected_resolution = _next_res;
                                    _changed = true;
                                    break;
                                }
                                _next_res++;
                            }
                        }
                    } else {
                        // Handle keyboard navigation for resolution
                        if (right_key) {
                            // Increase resolution, but skip unavailable ones
                            var _next_res = obj_settings.selected_resolution + 1;
                            while (_next_res <= RESOLUTION.RES_1440P) {
                                if (obj_settings.resolution_available[_next_res]) {
                                    obj_settings.selected_resolution = _next_res;
                                    _changed = true;
                                    break;
                                }
                                _next_res++;
                            }
                        } else if (left_key) {
                            // Decrease resolution, but skip unavailable ones
                            var _prev_res = obj_settings.selected_resolution - 1;
                            while (_prev_res >= RESOLUTION.RES_720P) {
                                if (obj_settings.resolution_available[_prev_res]) {
                                    obj_settings.selected_resolution = _prev_res;
                                    _changed = true;
                                    break;
                                }
                                _prev_res--;
                            }
                        }
                    }
                    
                    // Only play sound if the resolution actually changed
                    if (_changed) {
                        audio_play_sound(snd_hover, 0, false);
                    }
                    break;
                case 2: // Apply
                    // Apply the selected settings
                    obj_settings.applied_resolution = obj_settings.selected_resolution;
                    obj_settings.applied_display_mode = obj_settings.selected_display_mode;
                    
                    // Update window
                    window_set_size(
                        obj_settings.resolution_width[obj_settings.applied_resolution],
                        obj_settings.resolution_height[obj_settings.applied_resolution]
                    );
                    window_set_fullscreen(obj_settings.applied_display_mode != DISPLAY_MODE.WINDOWED);
                    
                    // Center the window if not in fullscreen
                    if (obj_settings.applied_display_mode == DISPLAY_MODE.WINDOWED) {
                        window_center();
                    }
                    
                    // Play confirmation sound
                    audio_play_sound(snd_hover, 0, false);
                    break;
                case 3: // Brightness
                    break;
                case 4: // Controls
                    break;
                case 5: // Back
                    menu_level = 0;
                    break;
            }
            break;
    }

    if (_sml != menu_level) { // reset position
        pos = 0;
    }

    op_length = array_length(option[menu_level]); // correct option length
}