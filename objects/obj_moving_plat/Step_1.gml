// Move in a circle
dir += rotation_speed;

// Get our target positions
var _target_x = xstart + lengthdir_x( radius, dir );
var _target_y = ystart + lengthdir_y( radius, dir );

// Get our xspeed and yspeed
//x_speed = 0;
y_speed = 0;
x_speed = _target_x - x;
//y_speed = _target_y - y;

// Move
x += x_speed;
y += y_speed;