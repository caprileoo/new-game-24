draw_set_font(fnt_main_outline);

var _text_scale = 0.7;
var _sprite_scale = 3;

// Show FPS
draw_text_transformed(1, 1, "FPS: " + string(fps), _text_scale, _text_scale, 0);
draw_text_transformed(1, 16, "No. of Lights: " + string(instance_number(obj_light)), _text_scale, _text_scale, 0);

// Energy UI
if (obj_player.energy > 0)
{
    draw_sprite_ext(spr_energy, 0, 1, 32, _sprite_scale, _sprite_scale, 0, c_white, 1);
    if (obj_player.energy > 1)
    {
        draw_text_transformed(40, 40, "x" + string(obj_player.energy), _text_scale, _text_scale, 0);
    }
}