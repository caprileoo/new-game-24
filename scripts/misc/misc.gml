function animation_interval()
{
    // delta_time is in microseconds, so we convert it to seconds
    // by dividing by 1,000,000
    var _seconds_per_step = delta_time / 1000000;
    
    // Get the sprite speed (frames per second)
    var _sprite_speed = sprite_get_speed(sprite_index);
    
    // Calculate the frame tick (how much the animation should progress this step)
    var _frame_tick = _sprite_speed * _seconds_per_step;
    
    return _frame_tick;
}