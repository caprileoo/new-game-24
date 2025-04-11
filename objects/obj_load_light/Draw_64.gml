draw_set_font(fnt_main_outline);

var _text_scale = 0.7;
var _sprite_scale = 3;

// Debug
draw_text_transformed(1, 1, "FPS: " + string(fps), _text_scale, _text_scale, 0);
draw_text_transformed(1, 20, "No. of Lights: " + string(instance_number(obj_light)), _text_scale, _text_scale, 0);

// Cursor Render
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

if (hovering) {
    draw_sprite_ext(spr_cursor_hover, 0, _mouse_x, _mouse_y, cursor_scale_x, cursor_scale_y, 0, c_white, 1);
} else {
    draw_sprite_ext(spr_cursor_idle, 0, _mouse_x, _mouse_y, cursor_scale_x, cursor_scale_y, 0, c_white, 1);
}

// Energy UI
if (instance_exists(obj_player) && obj_player.energy > 0)
{
    draw_sprite_ext(spr_energy, 0, 1, 32, _sprite_scale, _sprite_scale, 0, c_white, 1);
    if (obj_player.energy > 1)
    {
        draw_text_transformed(40, 40, "x" + string(obj_player.energy), _text_scale, _text_scale, 0);
    }
}