// Load Controls
get_controls();

//Creates Quad with two triangles. Used to make the shadows. 
//Z coordinate is used as a flag to determine if the vertex will be repositioned in the shader
function Quad(_vb,_x1,_y1,_x2,_y2){
	//Upper triangle
	vertex_position_3d(_vb,_x1,_y1,0);
	vertex_position_3d(_vb,_x1,_y1,2); //repositioned vertex
	vertex_position_3d(_vb,_x2,_y2,1);
	
	//Lower Triangle
	vertex_position_3d(_vb,_x1,_y1,2); //repositioned vertex
	vertex_position_3d(_vb,_x2,_y2,1);
	vertex_position_3d(_vb,_x2,_y2,3); //repositioned vertex
}



//Construct the vertex buffer with every wall
//Instead of using the four edges as the walls, we use the diagonals instead (Optimization)
vertex_begin(vb,vf);
var _vb = vb;

// Handle obj_wall and obj_moving_plat instances (excluding child objects)
with(obj_wall){
    if (object_index == obj_wall || object_index == obj_moving_plat) {
        Quad(_vb,x,y,x+sprite_width,y+sprite_height); //Negative Slope Diagonal Wall
        Quad(_vb,x+sprite_width,y,x,y+sprite_height); //Positive Slope Diagonal Wall
    }
}

// Handle obj_slope instances separately
with(obj_slope){
    Quad(_vb,x,y,x+sprite_width,y+sprite_height); //large diagonal wall
    Quad(_vb,x,y+sprite_height,mid_x,mid_y); //small diagonal wall
}
vertex_end(vb);

// Exit if there is no player
if !instance_exists(obj_player) exit;

// Get camera size
var _cam_width = camera_get_view_width(view_camera[0]);
var _cam_height = camera_get_view_height(view_camera[0]);

// Get camera target coordinates
var _cam_x = obj_player.x - _cam_width/2;
var _cam_y = obj_player.y - _cam_height/2;

// Constrain cam to room borders
_cam_x = clamp(_cam_x, 0, room_width - _cam_width);
_cam_y = clamp(_cam_y, 0, room_height - _cam_height);

// Frame-independent smooth movement using lerp
var _smooth_speed = cam_trail_speed * delta_time/16667; // For 60fps normalization
_smooth_speed = clamp(_smooth_speed, 0, 1); // Ensure lerp value stays between 0 and 1

final_cam_x = lerp(final_cam_x, _cam_x, _smooth_speed);
final_cam_y = lerp(final_cam_y, _cam_y, _smooth_speed);

// Round the final positions to prevent sub-pixel rendering
final_cam_x = round(final_cam_x);
final_cam_y = round(final_cam_y);

// Update both camera position and lighting system coordinates
camera_set_view_pos(view_camera[0], final_cam_x, final_cam_y);
vx = final_cam_x;
vy = final_cam_y;
global.vx = vx;
global.vy = vy;

//add lights by left clicking. For testing purposes
if (mouse_check_button_pressed(mb_left)){
		instance_create_depth(mouse_x,mouse_y,depth,obj_light);	
}
if (mouse_check_button_pressed(mb_right)){
	repeat(100)
		instance_create_depth(mouse_x,mouse_y,depth,obj_light);	
}