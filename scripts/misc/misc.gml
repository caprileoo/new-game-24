function animation_interval()
{
	var _frame_tick = sprite_get_speed(sprite_index) / room_speed;
	return _frame_tick;
}