draw_set_font(fnt_main_outline);

var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);

for (var _i = 0 ; _i < array_length(inv) ; _i++)
{
	var _xx = _cam_x + screen_bord;
	var _yy = _cam_y + screen_bord;
	var _sep = sep;
	var _color = c_white;
	
	// Draw Icon
	draw_sprite( inv[_i].icon, 0, _xx, _yy + _sep * _i );
	
	// Get Selected Color
	if selected_item == _i { _color = c_yellow; };
	draw_set_color(_color);
	
	// Draw Item Name
	draw_text_transformed( _xx + 16, _yy + _sep * _i, inv[_i].item_name, 0.3, 0.3, 0 );
	
	// Draw Description
	if selected_item == _i
	{
		draw_text_ext_transformed( _xx + 16, _yy + _sep * array_length(inv), inv[_i].description, 20, 260, 0.3, 0.3, 0 );
	}
	
	// Reset Color
	draw_set_color(c_white);
}

// Show FPS
draw_text_transformed(_cam_x, _cam_y, "FPS = " + string(fps), 0.2, 0.2, 0);