//Step
global.input_locked = true;
if (fade_in) {
    alpha += 0.02; // Adjust this value to control the speed of the fade in
    if (alpha >= 1) {
        alpha = 1;
        fade_in = false;
        room_goto(target_rm);
        fade_out = true;
    }
} else if (fade_out) {
    alpha -= 0.02; // Adjust this value to control the speed of the fade out
    if (alpha <= 0) {
        alpha = 0;
        instance_destroy();
    }
}
