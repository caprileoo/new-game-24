// Fullscreen toggle
if keyboard_check_pressed(vk_f11){
	window_set_fullscreen( !window_get_fullscreen() );
}

// Exit if there is no player
if !instance_exists(obj_player) exit;

// Get camera size
var _cam_width = camera_get_view_width(view_camera[0]);
var _cam_height = camera_get_view_height(view_camera[0]);

// Get camera target coordinates
var _cam_x = obj_player.x - _cam_width/2;
var _cam_y = obj_player.y - _cam_height/2;

// Constrain cam to room borders
_cam_x = clamp(_cam_x, 0, room_width - _cam_width);
_cam_y = clamp(_cam_y, 0, room_height - _cam_height);

// Set cam coordinate variables
final_cam_x += (_cam_x - final_cam_x) * cam_trail_speed;
final_cam_y += (_cam_y - final_cam_y) * cam_trail_speed;

// Set camera coordinates
camera_set_view_pos(view_camera[0], final_cam_x, final_cam_y);