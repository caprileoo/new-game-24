var up_key = keyboard_check_pressed(vk_up);
var down_key = keyboard_check_pressed(vk_down);
var ini_key = keyboard_check_pressed(vk_enter);

op_length = array_length(option[menu_level]);

pos += down_key - up_key;

if(pos >= op_length){
	pos = 0;
}

if(pos < 0){
	pos = op_length - 1;
}

if(ini_key){
	
	var sml = menu_level;
	
	switch(menu_level){ //pasue menu
		case 0:
			switch(pos){
				case 0: 
					if(!instance_exists(obj_warp) and !instance_exists(obj_tittle_trans) and !instance_exists(obj_respawn_trans)){
						var inst = instance_create_depth(0, 0, -9999, obj_tittle_trans);
						inst.target_rm = target_rm;
						inst.final_rm = final_rm;
					}
					break; //start game
				case 1: menu_level = 1; break; //settings
				case 2: game_end(); break; //Quit
			}
			break;
		case 1:
			switch(pos){
				case 0: //window size 
					break;
				case 1: //brightness
					break;
				case 2: //controls
					break;
				case 3: //back
					menu_level = 0;
					break;
			}
			break;
	}

	if(sml != menu_level){ //set position back
		pos = 0;
	}
	
	op_length = array_length(option[menu_level]);	//corrent option length
	
}

