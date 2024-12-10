var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);

selected_item = -1;
for (var _i = 0 ; _i < array_length(inv) ; _i++)
{
	var _xx = _cam_x + screen_bord;
	var _yy = _cam_y + screen_bord + sep * _i;
	
	if mouse_x > _xx && mouse_x < _xx + 8 && mouse_y > _yy && mouse_y < _yy + 8
	{
		selected_item = _i;
	}
}

if selected_item != -1
{
	// Use an item
	if mouse_check_button_pressed(mb_left)
	{
		inv[selected_item].effect();
	}
}