function Script_get_game_state(){
	var _current_hp = Object_player.life;
	var _hp_percent = _current_hp / Object_player.max_life;
	var _state_hp = (_hp_percent > 0.7) ? "HIGH" : ((_hp_percent > 0.3) ? "MED" : "LOW");

	var _enemy_count = instance_number(Object_enemy);
	var _state_enemies = (_enemy_count >= Object_game_director.max_enemies) ? "FULL" : ((_enemy_count > 15) ? "HIGH" : ((_enemy_count > 5) ? "MED" : "LOW"));

	var _player_type = "MELEE"; 
	if (Object_player.object_index != Object_player_meele) {
	    _player_type = "RANGED"; 
	}

	return "WPN_" + _player_type + "_HP_" + _state_hp + "_ENEMIES_" + _state_enemies;
}