function __input_config_verbs()
{
    return {
        keyboard_and_mouse:
        {
            up:			input_binding_key("W"),
            down:		input_binding_key("S"),
            left:		input_binding_key("A"),
            right:		input_binding_key("D"),
            
			jump:		input_binding_key(vk_space),
			accept:		input_binding_key(vk_space),
            interact:	input_binding_key(ord("F")),
            spell_cast: input_binding_key(ord("Q")),
			left_click: input_binding_mouse_button(mb_left),
        },
        
        gamepad:
        {
            up:			[input_binding_gamepad_axis(gp_axislv, true),  input_binding_gamepad_button(gp_padu)],
            down:		[input_binding_gamepad_axis(gp_axislv, false), input_binding_gamepad_button(gp_padd)],
            left:		[input_binding_gamepad_axis(gp_axislh, true),  input_binding_gamepad_button(gp_padl)],
            right:		[input_binding_gamepad_axis(gp_axislh, false), input_binding_gamepad_button(gp_padr)],
            
            jump:		input_binding_gamepad_button(gp_face1),
			accept:		input_binding_gamepad_button(gp_face1),
            interact:	input_binding_gamepad_button(gp_face2),
            spell_cast: input_binding_gamepad_button(gp_face3),
        },
    };
}