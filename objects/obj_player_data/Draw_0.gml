draw_set_font(main_font_outline);

var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);

for (var i = 0 ; i < array_length(inv) ; i++)
{
	var _xx = cam_x + screen_bord;
	var _yy = cam_y + screen_bord;
	var _sep = sep;
	draw_sprite( inv[i].icon, 0, _xx, _yy + _sep * i );
	draw_text_transformed( _xx + 16, _yy + _sep * i, inv[i].item_name, 0.3, 0.3, 0 );
}
// Show FPS
draw_text_transformed(cam_x, cam_y, "FPS = " + string(fps), 0.2, 0.2, 0);