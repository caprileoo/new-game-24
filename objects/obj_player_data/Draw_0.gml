draw_set_font(fnt_main_outline);

var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_width = camera_get_view_width(view_camera[0]);

// Track position for left-side items
var _left_items = 0;

// First pass - Draw non-energy items on the left
for (var _i = 0 ; _i < array_length(inv) ; _i++)
{
    if (inv[_i].item_name != "Energy")
    {
        var _xx = _cam_x + screen_bord;
        var _yy = _cam_y + screen_bord;
        var _sep = sep;
        var _color = c_white;
		var _spr_height = sprite_get_height(inv[_i].icon);
        
        // Draw Icon
        draw_sprite(inv[_i].icon, 0, _xx, _yy + _sep * _left_items);
        
        // Get Selected Color
        if selected_item == _i { _color = c_yellow; };
        draw_set_color(_color);
        
        // Draw quantity
        draw_text_transformed(
            _xx + 12, 
            _yy + _sep * _left_items + ( _spr_height / 5 ), 
            string(inv[_i].quantity), 
            0.3, 0.3, 0
        );
        
        // Draw Description
        if selected_item == _i
        {
            draw_text_ext_transformed(_xx + 16, _yy + _sep * array_length(inv), inv[_i].item_name, 20, 260, 0.3, 0.3, 0);
        }
        
        _left_items++;
    }
}

// Second pass - Draw energy items on the right
for (var _i = 0 ; _i < array_length(inv) ; _i++)
{
    if (inv[_i].item_name == "Energy")
    {
        var _xx = _cam_x + _cam_width - screen_bord - 8;
        var _yy = _cam_y + screen_bord;
		var _sep = sep;
        var _color = c_white;
		var _spr_height = sprite_get_height(inv[_i].icon);
        
        // Draw Icon
        draw_sprite(inv[_i].icon, 0, _xx, _yy);
        
        // Get Selected Color
        if selected_item == _i { _color = c_yellow; };
        draw_set_color(_color);
        
        // Draw quantity
		draw_text_transformed(
            _xx - 8, 
            _yy + ( _spr_height / 5 ), 
            string(inv[_i].quantity), 
            0.3, 0.3, 0
        );
        
        // Draw Description
        if selected_item == _i
        {
            draw_text_ext_transformed(_xx - 100, _yy + sep, inv[_i].item_name, 20, 260, 0.3, 0.3, 0);
        }
    }
    
    draw_set_color(c_white);
}

// Show FPS
draw_text_transformed(_cam_x, _cam_y, "FPS = " + string(fps), 0.2, 0.2, 0);