if(place_meeting(x, y, obj_player) and !instance_exists(obj_warp) and !instance_exists(obj_title_trans) and !instance_exists(obj_respawn_trans)){
	var _inst = instance_create_depth(0, 0, -9999, obj_warp);
	_inst.target_x = target_x;
	_inst.target_y = target_y;
	_inst.target_rm = target_rm;
	_inst.target_face = target_face;
	_inst.animation_speed = animation_speed;
	_inst.delay = delay;
}