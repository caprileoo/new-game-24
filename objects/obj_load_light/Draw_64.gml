draw_set_font(fnt_main_outline);

// Track position for left-side items
var _left_items = 0;
var _cam_width = camera_get_view_width(view_camera[0]);
var _text_scale = 0.7;

// First pass - Draw non-energy items on the left
for (var _i = 0 ; _i < array_length(obj_player_data.inv) ; _i++)
{
    if (obj_player_data.inv[_i].item_name != "Energy")
    {
        var _xx = obj_player_data.screen_bord;
        var _yy = obj_player_data.screen_bord;
        var _sep = obj_player_data.sep;
        var _color = c_white;
        var _spr_height = sprite_get_height(obj_player_data.inv[_i].icon);
        
        // Draw Icon
        draw_sprite(obj_player_data.inv[_i].icon, 0, _xx, _yy + _sep * _left_items);
        
        // Get Selected Color
        if obj_player_data.selected_item == _i { _color = c_yellow; };
        draw_set_color(_color);
        
        // Draw quantity
        draw_text_transformed(
            _xx + 12, 
            _yy + _sep * _left_items + ( _spr_height / 5 ), 
            string(obj_player_data.inv[_i].quantity), 
            _text_scale, _text_scale, 0
        );
        
        // Draw Description
        if obj_player_data.selected_item == _i
        {
            draw_text_ext_transformed(_xx + 16, _yy + _sep * array_length(obj_player_data.inv), obj_player_data.inv[_i].item_name, 20, 260, _text_scale, _text_scale, 0);
        }
        
        _left_items++;
    }
}

// Second pass - Draw energy items on the right
for (var _i = 0 ; _i < array_length(obj_player_data.inv) ; _i++)
{
    if (obj_player_data.inv[_i].item_name == "Energy")
    {
        var _xx = _cam_width - obj_player_data.screen_bord - 8;
        var _yy = obj_player_data.screen_bord;
        var _sep = obj_player_data.sep;
        var _color = c_white;
        var _spr_height = sprite_get_height(obj_player_data.inv[_i].icon);
        
        // Draw Icon
        draw_sprite(obj_player_data.inv[_i].icon, 0, _xx, _yy);
        
        // Get Selected Color
        if obj_player_data.selected_item == _i { _color = c_yellow; };
        draw_set_color(_color);
        
        // Draw quantity
        draw_text_transformed(
            _xx - 8, 
            _yy + ( _spr_height / 5 ), 
            string(obj_player_data.inv[_i].quantity), 
            _text_scale, _text_scale, 0
        );
        
        // Draw Description
        if obj_player_data.selected_item == _i
        {
            draw_text_ext_transformed(_xx - 100, _yy + obj_player_data.sep, obj_player_data.inv[_i].item_name, 20, 260, _text_scale, _text_scale, 0);
        }
    }
    
    draw_set_color(c_white);
}

// Show FPS
draw_text_transformed(1, 1, "FPS: " + string(fps), _text_scale, _text_scale, 0);
draw_text_transformed(1, 16, "No. of Lights: " + string(instance_number(obj_light)), _text_scale, _text_scale, 0);
