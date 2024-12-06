draw_set_font(main_font_outline_shade);

var new_w = 0;
for(var i = 0; i < op_length; i++){
    var op_w = string_width(option[menu_level, i]);
    new_w = max(new_w, op_w);
}

width = new_w + op_border * 2;

height = op_border * 2 + font_get_size(main_font_outline) + (op_length - 1) * op_space;

x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2 - width / 2;
y = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2 - height / 2 + 15;

draw_set_valign(fa_top);
draw_set_halign(fa_left);

for(var i = 0; i < op_length; i++){
    var color = c_white;
    if(pos == i){
        color = #F29F58;
    }
    draw_text_transformed_colour(x + op_border, y + op_border + op_space * i, option[menu_level, i], 0.5, 0.5, 0, color, color, color, color, 1);
}