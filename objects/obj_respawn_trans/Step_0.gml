//Step
global.input_locked = true;
if (fade_in) {
    alpha += animation_speed;
    if (alpha >= 1) {
        alpha = 1;
        fade_in = false;
        room_goto(target_rm);
        
        // Safely check and use global variable
        if (variable_global_exists("player_respawn_data")) {
            var _player = instance_create_layer(global.player_respawn_data.target_x, 
                                                global.player_respawn_data.target_y, 
                                                "Player", 
                                                obj_player);
            _player.face = global.player_respawn_data.target_face;
            
            // Only delete if the variable exists
            global.player_respawn_data = undefined;
        }
        
        fade_out = true;
    }
} else if (fade_out) {
    if (delay > 0) {
        delay -= 1;
    } else {
        alpha -= animation_speed;
        if (alpha <= 0) {
            alpha = 0;
            instance_destroy();
        }
    }
}