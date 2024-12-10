// Keyboard input checks
var _up_key = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down_key = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _ini_key = keyboard_check_pressed(vk_enter);

// Mouse input checks
var _mouse_x_pos = device_mouse_x(0);
var _mouse_y_pos = device_mouse_y(0);
var _mouse_left_pressed = mouse_check_button_pressed(mb_left);

op_length = array_length(option[menu_level]);

// Keyboard navigation
var _new_pos = pos + _down_key - _up_key;
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
        break;
    }
}

// Update pos based on latest action
if (_mouse_over_option != -1) {
    // Check if pos changed when using mouse
    if (pos != _mouse_over_option) {
        audio_play_sound(snd_hover, 0, false);
    }
    pos = _mouse_over_option;
} else if (_up_key || _down_key) {
    // Check if pos changed when using keyboard
    if (pos != _new_pos) {
        audio_play_sound(snd_hover, 0, false);
    }
    pos = _new_pos;
}

// Interaction (keyboard or mouse)
var _interaction_detected = (_ini_key) || (_mouse_left_pressed && _mouse_over_bbox);

if (_interaction_detected) {
    var _sml = menu_level;

    switch (menu_level) { // pause menu
        case 0:
            switch (pos) {
                case 0:
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