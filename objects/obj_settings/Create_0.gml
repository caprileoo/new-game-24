// Resolution options
enum RESOLUTION {
    RES_720P,
    RES_1080P,
    RES_1440P
}

// Display mode options
enum DISPLAY_MODE {
    WINDOWED,
    FULLSCREEN_PRESERVE,  // Preserve aspect ratio with black bars
    FULLSCREEN_STRETCH    // Stretch to fill screen (not ideal for pixel art)
}

// Detect available resolutions and disable those that are too large
function update_available_resolutions() {
    var _display_width = display_get_width();
    var _display_height = display_get_height();
    
    // Flag for each resolution to determine if it's available
    resolution_available[RESOLUTION.RES_720P] = (_display_width >= 1280 && _display_height >= 720);
    resolution_available[RESOLUTION.RES_1080P] = (_display_width >= 1920 && _display_height >= 1080);
    resolution_available[RESOLUTION.RES_1440P] = (_display_width >= 2560 && _display_height >= 1440);
    
    // Make sure the currently selected resolution is available
    // If not, downgrade to the highest available resolution
    if (!resolution_available[selected_resolution]) {
        if (resolution_available[RESOLUTION.RES_1080P]) {
            selected_resolution = RESOLUTION.RES_1080P;
        } else if (resolution_available[RESOLUTION.RES_720P]) {
            selected_resolution = RESOLUTION.RES_720P;
        } else {
            // For extremely small monitors, default to 720p anyway
            // The game will scale down but remain usable
            selected_resolution = RESOLUTION.RES_720P;
        }
    }
}

// Resolution width and height values
resolution_width[RESOLUTION.RES_720P] = 1280;
resolution_height[RESOLUTION.RES_720P] = 720;
resolution_width[RESOLUTION.RES_1080P] = 1920;
resolution_height[RESOLUTION.RES_1080P] = 1080;
resolution_width[RESOLUTION.RES_1440P] = 2560;
resolution_height[RESOLUTION.RES_1440P] = 1440;

// Current settings (selected in menu)
selected_resolution = RESOLUTION.RES_720P;
selected_display_mode = DISPLAY_MODE.WINDOWED;

// Applied settings (what the game is currently using)
applied_resolution = selected_resolution;
applied_display_mode = selected_display_mode;

// Scale factors for different resolutions
scale_factor[RESOLUTION.RES_720P] = 4;    // 320x180 * 4 = 1280x720
scale_factor[RESOLUTION.RES_1080P] = 6;   // 320x180 * 6 = 1920x1080
scale_factor[RESOLUTION.RES_1440P] = 8;   // 320x180 * 8 = 2560x1440

// Resolution names for display
resolution_name[RESOLUTION.RES_720P] = "720p (1280x720)";
resolution_name[RESOLUTION.RES_1080P] = "1080p (1920x1080)";
resolution_name[RESOLUTION.RES_1440P] = "1440p (2560x1440)";

// Display mode names
display_mode_name[DISPLAY_MODE.WINDOWED] = "Windowed";
display_mode_name[DISPLAY_MODE.FULLSCREEN_PRESERVE] = "Fullscreen";
display_mode_name[DISPLAY_MODE.FULLSCREEN_STRETCH] = "Fullscreen Stretch";

// Set display_width and display_height - these will be used for adaptive scaling
display_width = display_get_width();
display_height = display_get_height();
is_ultrawide = (display_width / display_height) >= 2.0; // Detect if ultrawide (21:9 or wider)

// Apply initial settings
window_set_size(
    resolution_width[applied_resolution],
    resolution_height[applied_resolution]
);
window_set_fullscreen(applied_display_mode != DISPLAY_MODE.WINDOWED);

// Center window if windowed
if (applied_display_mode == DISPLAY_MODE.WINDOWED) {
    window_center();
}

// Create a trigger to apply surface scaling on first room
alarm[0] = 1; // Delay one frame

update_available_resolutions();

// Don't delete these fonts (original code from CleanUp_0)
font_list = [
    fnt_main,
    fnt_main_outline,
    fnt_main_glow,
    fnt_main_shade,
    fnt_main_outline_glow, 
    fnt_main_outline_shade,
    fnt_main_outline_shade_glow
];