// obj_title/Draw_0.gml - Completely revised positioning approach
draw_set_font(fnt_main_outline_shade);

// Get screen dimensions for proper centering
var _view_width = camera_get_view_width(view_camera[0]);
var _view_height = camera_get_view_height(view_camera[0]);

// Calculate menu dimensions and position
var _new_w = 0;
for(var _i = 0; _i < op_length; _i++){
    var _display_text = option[menu_level, _i];
    
    // Get the full display text including any additional info
    if (menu_level == 1) {
        if (_i == 0) { // Display Mode
            _display_text = option[menu_level, _i] + ": " + obj_settings.display_mode_name[obj_settings.selected_display_mode];
        } else if (_i == 1) { // Resolution
            _display_text = option[menu_level, _i] + ": < " + obj_settings.resolution_name[obj_settings.selected_resolution] + " >";
        }
    }
    
    var _op_w = string_width(_display_text) * 0.5; // Account for the 0.5 scale
    _new_w = max(_new_w, _op_w);
}

width = _new_w + op_border * 2;
height = op_border * 2 + (font_get_size(fnt_main_outline) * 0.5) + (op_length - 1) * op_space;

// Center the menu on screen
x = camera_get_view_x(view_camera[0]) + (_view_width/2) - (width/2);
y = camera_get_view_y(view_camera[0]) + (_view_height/2) - (height/2) + 15;

// Draw the menu
draw_set_valign(fa_top);
draw_set_halign(fa_left);

// Draw background for debugging (uncomment to see bounds)
//draw_set_color(c_red);
//draw_set_alpha(0.2);
//draw_rectangle(x, y, x + width, y + height, false);
//draw_set_alpha(1);
//draw_set_color(c_white);

for(var _i = 0; _i < op_length; _i++){
    var _color = c_white;
    var _display_text = option[menu_level, _i];
    
    if (menu_level == 1) {
        if (_i == 0) { // Display Mode
            _display_text = option[menu_level, _i] + ": " + obj_settings.display_mode_name[obj_settings.selected_display_mode];
        } else if (_i == 1) { // Resolution
            _display_text = option[menu_level, _i] + ": < " + obj_settings.resolution_name[obj_settings.selected_resolution] + " >";
        }
    }
    
    if(pos == _i){
        draw_set_font(fnt_main_outline_shade_glow);
        _color = #48F7FF;
    } else draw_set_font(fnt_main_outline_shade);
    
    // Center text within menu
    draw_text_transformed_colour(x + op_border, y + op_border + op_space * _i, _display_text, 0.5, 0.5, 0, _color, _color, _color, _color, 1);
}