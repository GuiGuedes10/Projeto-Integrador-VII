function Script_player_walk(){
	if(Object_input.input_lef) x = x - player_speed
	if(Object_input.input_right) x = x + player_speed
	if(Object_input.input_top) y = y - player_speed
	if(Object_input.input_down) y = y + player_speed
}