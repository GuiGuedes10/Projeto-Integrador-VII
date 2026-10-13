function Script_update_q_table(old_state, current_state, action, old_hp, current_hp){
	var _enemy_count = instance_number(Object_enemy);
	var _reward = 0;
	var _damage_dealt = old_hp - current_hp;

	if (_damage_dealt > 0) _reward += _damage_dealt * 1.5; 

	var _hp_percent = current_hp / Object_player.max_life;
	var _state_hp = (_hp_percent > 0.7) ? "HIGH" : ((_hp_percent > 0.3) ? "MED" : "LOW");

	if (action == 0 && _state_hp != "LOW") _reward -= 8; 
	if (_state_hp == "HIGH" && (action == 0 || action == 1)) _reward -= 5;

	if (Object_player.currently_state == state.dead || current_hp <= 0) _reward += 150;

	var _action_costs = [0, 2, 4, 4, 7, 10]; 
	_reward -= _action_costs[action];

	if (_enemy_count >= max_enemies && action > 0) _reward -= 15; 

	if (!variable_struct_exists(q_table, current_state)) {
	    variable_struct_set(q_table, current_state, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
	}

	var _old_q = q_table[$ old_state][action];
	var _q_current = q_table[$ current_state];
	var _max_future_q = _q_current[0];

	for (var i = 1; i < 6; i++) {
	    if (_q_current[i] > _max_future_q) _max_future_q = _q_current[i];
	}

	q_table[$ old_state][action] = _old_q + alpha * (_reward + gamma * _max_future_q - _old_q);
}