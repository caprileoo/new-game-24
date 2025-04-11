// Clean up all created fonts
for (var i = 0; i < array_length(font_list); i++) {
    if (font_exists(font_list[i])) {
        font_delete(font_list[i]);
    }
}