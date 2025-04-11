// Control Setup
controls_setup();
window_set_cursor(cr_none);

// Audio Setup
audio_sound_set_track_position(snd_theme_song, 0);
audio_sound_set_track_position(snd_hover, 0);
audio_play_sound(snd_theme_song, 0, true);

hovering = false;
cursor_scale_x = 2;
cursor_scale_y = 2;

width = 640;
height = 480;

op_border = 100;
op_space = 20;

pos = 0;
menu_locked = false;

option[0, 0] = "New Game";
option[0, 1] = "Settings";
option[0, 2] = "Touch Some Grass";

option[1, 0] = "Display Mode";
option[1, 1] = "Resolution";
option[1, 2] = "Apply";
option[1, 3] = "Brightness";
option[1, 4] = "Controls";
option[1, 5] = "Back";

op_length = 0;
menu_level = 0;

target_rm = rm_second_loading_phase;
final_rm = rm_devroom;