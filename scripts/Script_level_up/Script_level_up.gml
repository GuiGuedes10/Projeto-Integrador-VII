function Script_level_up(){
	var _xp_needed = 50 * power(level, 1.5);

	if (xp >= _xp_needed) {
	    xp -= _xp_needed; 
	    level++;          
		instance_create_layer(0, 0, "Instances", Object_level_up_menu);
	}
}