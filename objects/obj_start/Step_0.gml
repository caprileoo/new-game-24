if(place_meeting(x, y, obj_player) and !instance_exists(obj_warp) and !instance_exists(obj_tittle_trans) and !instance_exists(obj_respawn_trans)){
	var inst = instance_create_depth(0, 0, -9999, obj_warp);
	inst.target_x = target_x;
	inst.target_y = target_y;
	inst.target_rm = target_rm;
	inst.target_face = target_face;
	inst.animation_speed = animation_speed;
	inst.delay = delay;
}