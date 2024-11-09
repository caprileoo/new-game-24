function isAnimationEnded()
{
	var _frame_tick = sprite_get_speed(sprite_index) / game_get_speed(room_speed);
	
	var _num_frames = sprite_get_number(sprite_index);
	
	return image_index >= _num_frames - _frame_tick;
}

function animationInterval()
{
	var _frame_tick = sprite_get_speed(sprite_index) / room_speed;
	return _frame_tick;
}