if (!audio_group_is_loaded(UI))
{
    audio_group_load(UI);
}

if (music_and_sound_loaded()) {
    room_goto_next();
}