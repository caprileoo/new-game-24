function controls_setup(){
	buffer_time = 5;
	
	jump_key_buffered = 0;
	jump_key_buffer_timer = 0;
}

function get_controls(){
	if (global.input_locked) {
		left_key = 0;
		right_key = 0;
		down_key = 0;
		down_key_pressed = 0;
		jump_key_pressed = 0;
		jump_key = 0;
		use_energy_key_pressed = 0;
		interaction_key = 0;
		interaction_key_pressed = 0;
		nav_up = 0;
		nav_down = 0;
		enter_key = 0;
		left_click = 0;
        right_click = 0;
		return;
	}
	//Direction inputs (In game)
	left_key = input_check("left");
	
	right_key = input_check("right");
	
	down_key = input_check("down");
	
	down_key_pressed = input_check_pressed("down");
	
	//Action inputs
	jump_key = input_check("jump");
	
	jump_key_pressed = input_check_pressed("jump");
	
	use_energy_key_pressed = input_check_pressed("spell_cast");
	
	interaction_key = input_check("interact");
	
	interaction_key_pressed = input_check_pressed("interact");
	
	// Menu Inputs
	nav_up = input_check_pressed("up");
	
	nav_down = input_check_pressed("down");
	
	enter_key = input_check_pressed("accept");
	
	left_click = input_check_pressed("left_click");
    
    right_click = input_check_pressed("right_click");
	
	//Jump key buffering
	if (jump_key_pressed){
		jump_key_buffer_timer = buffer_time;
	}
	if ( jump_key_buffer_timer > 0 ){
		jump_key_buffered = 1;
		jump_key_buffer_timer--;
	} else {
		jump_key_buffered = 0;
	}
}