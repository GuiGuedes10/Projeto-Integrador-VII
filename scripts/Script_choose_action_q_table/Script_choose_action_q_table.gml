function Script_choose_action_q_table(current_state){
	var _current_state = argument[0];

	if (!variable_struct_exists(q_table, _current_state)) {
	    variable_struct_set(q_table, _current_state, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
	}

	var _action_chosen = 0;

	if (random(1) < epsilon) {
	    _action_chosen = irandom(5); 
	} else {
	    var _q = q_table[$ _current_state];
	    var _best_val = _q[0];
	    _action_chosen = 0;
	    for (var i = 1; i < 6; i++) {
	        if (_q[i] > _best_val) {
	            _best_val = _q[i];
	            _action_chosen = i;
	        }
	    }
	}

	return _action_chosen;
}