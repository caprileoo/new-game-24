//Step
global.input_locked = true;
if (fade_in) {
    alpha += animation_speed;
    if (alpha >= 1) {
        alpha = 1;
        fade_in = false;
        room_goto(target_rm);
        obj_player.x = target_x;
        obj_player.y = target_y;
        obj_player.face = target_face;
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
