// Keyboard input checks
var up_key = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var down_key = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var ini_key = keyboard_check_pressed(vk_enter);

// Mouse input checks
var mouse_x_pos = device_mouse_x(0);
var mouse_y_pos = device_mouse_y(0);
var mouse_left_pressed = mouse_check_button_pressed(mb_left);

op_length = array_length(option[menu_level]);

// Keyboard navigation
var new_pos = pos + down_key - up_key;
if(new_pos >= op_length){
    new_pos = 0;
}
if(new_pos < 0){
    new_pos = op_length - 1;
}

// Mouse hover detection
var mouse_over_option = -1;
var mouse_over_bbox = false;

for (var i = 0; i < op_length; i++) {
    var option_x = x + op_border;
    var option_y = y + op_border + op_space * i;
    var option_w = string_width(option[menu_level, i]) * 0.5;
    var option_h = font_get_size(main_font) * 0.5;

    // Check if mouse is within the bounding box of this option
    if (mouse_x_pos >= option_x && 
        mouse_x_pos <= option_x + option_w && 
        mouse_y_pos >= option_y && 
        mouse_y_pos <= option_y + option_h) {
        mouse_over_option = i;
        mouse_over_bbox = true;
        break;
    }
}

// Update pos based on latest action
if (mouse_over_option != -1) {
    pos = mouse_over_option;
} else if (up_key || down_key) {
    pos = new_pos;
}

// Interaction (keyboard or mouse)
var interaction_detected = (ini_key) || (mouse_left_pressed && mouse_over_bbox);

if (interaction_detected) {
    var sml = menu_level;

    switch (menu_level) { // pause menu
        case 0:
            switch (pos) {
                case 0:
                    if (!instance_exists(obj_warp) && !instance_exists(obj_tittle_trans) && !instance_exists(obj_respawn_trans)) {
                        var inst = instance_create_depth(0, 0, -9999, obj_tittle_trans);
                        inst.target_rm = target_rm;
                        inst.final_rm = final_rm;
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

    if (sml != menu_level) { // reset position
        pos = 0;
    }

    op_length = array_length(option[menu_level]); // correct option length
}