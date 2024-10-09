//Get inputs
left_key = keyboard_check(ord("A"));
right_key = keyboard_check(ord("D"));
jump_key_pressed = keyboard_check_pressed(vk_space);

#region X Movement
//Direction
move_dir = right_key - left_key;

//Get x_speed
x_speed = move_dir * move_speed;

//X Collision
var _sub_pixels = .5; //How close we can get close to the wall

if place_meeting( x + x_speed, y, obj_wall){
	//Scoot up to wall precisely
	var _pixel_check = _sub_pixels * sign(x_speed);
	while !place_meeting( x + _pixel_check, y, obj_wall){
		x += _pixel_check;
	}
	
	//Set xspd to zero to "collide"
	x_speed = 0;
}

//Move
x += x_speed;
#endregion

#region Y Movement
//Gravity
y_speed += grav;

//Jump
if (jump_key_pressed && place_meeting( x, y + 1, obj_wall)){
	y_speed = jump_speed;
}

//Y Collision
var _sub_pixels = .5;
if(place_meeting( x, y + y_speed, obj_wall)){
	//Scoot up to wall precisely
	var _pixel_check = _sub_pixels * sign(y_speed);
	while !place_meeting( x, y + _pixel_check, obj_wall){
		y += _pixel_check;
	}
	
	//Set y_speed to 0 to collide
	y_speed = 0;
}

//Jump
y += y_speed;
#endregion