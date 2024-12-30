// Control Setup
controls_setup();

//Resize the application surface to be lower res (for pixel games + performance boost)
surface_resize(application_surface,320,180);
display_set_gui_maximize();

//turn of automaic drawing of application surface
application_surface_draw_enable(false);

// Cursor Render
hovering = false;
cursor_scale_x = 2;
cursor_scale_y = 2;

// Camera variables
final_cam_x = 0;
final_cam_y = 0;
cam_trail_speed = 0.1;

//view coordinates
vx = 0;
vy = 0;

//Shader uniform variable setup
u_pos = shader_get_uniform(shd_light,"u_pos");
u_zz = shader_get_uniform(shd_light,"zz");
u_str = shader_get_uniform(shd_light,"u_str");
u_dir = shader_get_uniform(shd_light,"u_dir");
u_fov = shader_get_uniform(shd_light,"u_fov");
u_nmap = shader_get_sampler_index(shd_light,"u_nmap");

u_pos2 = shader_get_uniform(shd_shadow,"u_pos");

//Vertex format and buffer setup
vertex_format_begin();
vertex_format_add_position_3d();
vf = vertex_format_end();
vb = vertex_create_buffer();

//shadow surface variable declaration
shad_surf = noone;


//Background layer functions
function BGbegin(){
	gpu_set_colorwriteenable(1,1,1,0);
}

function BGend(){
	gpu_set_colorwriteenable(1,1,1,1);
}

var _bg_layer = layer_get_id("Background");
var _bg_layer2 = layer_get_id("Background2");
layer_script_begin(_bg_layer,BGbegin);
layer_script_end(_bg_layer2,BGend);



// Normal layer functions
global.n_surf = noone;
global.vx = 0;
global.vy = 0;

function Nbegin(){
	if (!surface_exists(global.n_surf)){
		global.n_surf = surface_create(320,180);
	}
	surface_set_target(global.n_surf);
	matrix_set(matrix_world,matrix_build(-global.vx,-global.vy,0,0,0,0,1,1,1));
	draw_clear_alpha(c_white,0);
}

function Nend(){
	surface_reset_target();
	matrix_set(matrix_world,matrix_build(0,0,0,0,0,0,1,1,1));
}

var _n_layer = layer_get_id("Normal");
layer_script_begin(_n_layer,Nbegin);
layer_script_end(_n_layer,Nend);
