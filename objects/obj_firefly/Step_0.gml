// Hovering effect
hover_offset += hover_speed;
var hover_y = hover_amplitude * sin(hover_offset);

// Get player's position and facing direction
var player_x = target.x;
var player_y = target.y;
target_direction = -target.face;

// Calculate the target position based on player's direction
var target_x = player_x - target_direction * horizontal_offset; // Use horizontal offset
var target_y = player_y - vertical_offset + hover_y; // Use vertical offset

// Smoothly move towards the target position
x += (target_x - x) / follow_speed;
y += (target_y - y) / follow_speed;

// Dynamic follow speed based on distance
var distance = point_distance(x, y, target_x, target_y);
follow_speed = max(4, distance / 10); // Adjust this value to change the smoothness