function animation_interval()
{
	var _frame_tick = sprite_get_speed(sprite_index) / game_get_speed(gamespeed_fps);
	return _frame_tick;
}