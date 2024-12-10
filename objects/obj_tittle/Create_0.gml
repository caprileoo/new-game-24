audio_sound_set_track_position(snd_theme_song, 0);
audio_sound_set_track_position(snd_hover, 0);
audio_play_sound(snd_theme_song, 0, true);
width = 640;
height = 480;

op_border = 100;
op_space = 20;

pos = 0;

option[0, 0] = "New Game";
option[0, 1] = "Settings";
option[0, 2] = "Touch Some Grass";

option[1, 0] = "Window Size";
option[1, 1] = "Brightness";
option[1, 2] = "Controls";
option[1, 3] = "Back";

op_length = 0;
menu_level = 0;

target_rm = rm_second_loading_phase;
final_rm = rm_devroom;