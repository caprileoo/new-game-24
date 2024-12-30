// Snap to player when room start
if (instance_exists(obj_player)) {
    // Get player's initial position and facing direction
    var player_x = obj_player.x;
    var player_y = obj_player.y;
    var initial_direction = -obj_player.face;
    
    // Calculate the initial position based on offsets
    x = player_x - initial_direction * horizontal_offset;
    y = player_y - vertical_offset;
}