var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

if (hovering) {
    draw_sprite_ext(spr_cursor_hover, 0, _mouse_x, _mouse_y, cursor_scale_x, cursor_scale_y, 0, c_white, 1);
} else {
    draw_sprite_ext(spr_cursor_idle, 0, _mouse_x, _mouse_y, cursor_scale_x, cursor_scale_y, 0, c_white, 1);
}