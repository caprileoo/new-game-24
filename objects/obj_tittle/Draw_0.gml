draw_set_font(fnt_main_outline_shade);

var _new_w = 0;
for(var _i = 0; _i < op_length; _i++){
    var _op_w = string_width(option[menu_level, _i]);
    _new_w = max(_new_w, _op_w);
}

width = _new_w + op_border * 2;

height = op_border * 2 + font_get_size(fnt_main_outline) + (op_length - 1) * op_space;

x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2 - width / 2;
y = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2 - height / 2 + 15;

draw_set_valign(fa_top);
draw_set_halign(fa_left);

for(var _i = 0; _i < op_length; _i++){
    var _color = c_white;
    if(pos == _i){
        _color = #F29F58;
    }
    draw_text_transformed_colour(x + op_border, y + op_border + op_space * _i, option[menu_level, _i], 0.5, 0.5, 0, _color, _color, _color, _color, 1);
}