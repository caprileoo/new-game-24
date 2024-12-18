// Load Controls
get_controls();

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


// Use energy
if use_energy_key_pressed
{
    // Check if energy exists in inventory first
    var _has_energy = false;
    for (var _i = 0; _i < array_length(inv); _i++)
    {
        if (inv[_i].item_name == "Energy" && inv[_i].quantity > 0)
        {
            _has_energy = true;
            break;
        }
    }
    
    if (_has_energy)
    {
        global.item_list.energy.effect();
    }
}