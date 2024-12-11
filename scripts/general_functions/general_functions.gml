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
		enter_click = 0;
		return;
	}
	//Direction inputs (In game)
	left_key = keyboard_check(ord("A")) + gamepad_button_check( 4, gp_padl ) + gamepad_button_check( 0, gp_padl );
	left_key = clamp( left_key, 0, 1 );
	
	right_key = keyboard_check(ord("D")) + gamepad_button_check( 4, gp_padr ) + gamepad_button_check( 0, gp_padr );
	right_key = clamp( right_key, 0, 1 );
	
	down_key = keyboard_check(ord("S")) + gamepad_button_check( 4, gp_padd ) + gamepad_button_check( 0, gp_padd );
	down_key = clamp( down_key, 0, 1 );
	
	down_key_pressed = keyboard_check_pressed(ord("S")) + gamepad_button_check_pressed( 4, gp_padd ) + gamepad_button_check_pressed( 0, gp_padd );
	down_key_pressed = clamp( down_key_pressed, 0, 1 );
	
	//Action inputs
	jump_key = keyboard_check(vk_space) + gamepad_button_check( 4, gp_face1 ) + gamepad_button_check( 0, gp_face1 );
	jump_key = clamp( jump_key, 0, 1 );
	
	jump_key_pressed = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed( 4, gp_face1 ) + gamepad_button_check_pressed( 0, gp_face1 );
	jump_key_pressed = clamp( jump_key_pressed, 0, 1 );
	
	use_energy_key_pressed = keyboard_check_pressed(ord("Q")) + gamepad_button_check_pressed( 4, gp_shoulderr ) + gamepad_button_check_pressed( 0, gp_shoulderr );
	use_energy_key_pressed = clamp( use_energy_key_pressed, 0, 1 );
	
	interaction_key = keyboard_check(ord("F")) + gamepad_button_check( 4, gp_shoulderl ) + gamepad_button_check( 0, gp_shoulderl );
	interaction_key = clamp( interaction_key, 0, 1 );
	
	interaction_key_pressed = keyboard_check_pressed(ord("F")) + gamepad_button_check_pressed( 4, gp_shoulderl ) + gamepad_button_check_pressed( 0, gp_shoulderl );
	interaction_key_pressed = clamp( interaction_key_pressed, 0, 1 );
	
	// Menu Inputs
	nav_up = keyboard_check_pressed(vk_up) + keyboard_check_pressed(ord("W")) + gamepad_button_check_pressed( 4, gp_padu ) + gamepad_button_check_pressed( 0, gp_padu );
	nav_up = clamp(nav_up, 0, 1);
	
	nav_down = keyboard_check_pressed(vk_down) + keyboard_check_pressed(ord("S")) + gamepad_button_check_pressed( 4, gp_padd ) + gamepad_button_check_pressed( 0, gp_padd );
	nav_down = clamp(nav_down, 0, 1);
	
	enter_key = keyboard_check_pressed(vk_enter) + gamepad_button_check_pressed( 4, gp_face1 ) + gamepad_button_check_pressed( 0, gp_face1 );
	enter_key = clamp(enter_key, 0, 1);
	
	enter_click = mouse_check_button_pressed(mb_left);
	
	
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