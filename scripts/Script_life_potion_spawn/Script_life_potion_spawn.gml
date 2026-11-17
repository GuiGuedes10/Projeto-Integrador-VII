function Script_life_potion_spawn(enemy_x, enemy_y){
	var _chance = irandom_range(1, 100);

	if (_chance <= 5) {
	    instance_create_layer(enemy_x, enemy_y, "Instances", Object_life_potion)
	}
}