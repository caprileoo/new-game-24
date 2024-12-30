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
    var _option_w = string_width(option[menu_level, _i]) * 0.5;
    var _option_h = font_get_size(fnt_main) * 0.5;

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
} else if (nav_up || nav_down) && !menu_locked {
    // Check if pos changed when using keyboard
    if (pos != _new_pos) {
        audio_play_sound(snd_hover, 0, false);
    }
    pos = _new_pos;
}

// Interaction (keyboard or mouse)
var _interaction_detected = (enter_key) || (enter_click && _mouse_over_bbox);

if (_interaction_detected) {
    var _sml = menu_level;

    switch (menu_level) { // pause menu
        case 0:
            switch (pos) {
                case 0:
					menu_locked = true;
                    if (!instance_exists(obj_warp) && !instance_exists(obj_tittle_trans) && !instance_exists(obj_respawn_trans)) {
                        var _inst = instance_create_depth(0, 0, -9999, obj_tittle_trans);
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
                case 0: // window size 
                    break;
                case 1: // brightness
                    break;
                case 2: // controls
                    break;
                case 3: // back
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