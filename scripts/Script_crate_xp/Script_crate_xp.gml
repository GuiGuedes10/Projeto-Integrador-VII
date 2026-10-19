function Script_crate_xp(enemy_x, enemy_y){
	var _amount = irandom_range(5, 15);
	var _range
	for(i = 0; i <= _amount; i++){
		_range = irandom(5);
		instance_create_layer(x + _range, y + _range, "Instances",Object_Xp);
	}
}