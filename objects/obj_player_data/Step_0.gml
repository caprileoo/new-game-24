// Load Controls
get_controls();

var scroll = mouse_wheel_down() - mouse_wheel_up();
if (scroll != 0) {
    if (array_length(inv) > 0) {
        // Update selected item
        selected_item += scroll;
        // Wrap around inventory slots using array length directly
        var inv_size = array_length(inv);
        selected_item = ((selected_item % inv_size) + inv_size) % inv_size;
        
        // Reset name display
        item_name_alpha = 1;
        item_name_timer = show_name_duration;
    } else {
        show_debug_message("Inventory is empty!");
        selected_item = 0;
    }
}