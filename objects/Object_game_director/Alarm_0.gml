if (global.game_paused || !instance_exists(Object_player)) {
    alarm[0] = 1;
    exit;
}

if (Object_player.life > 0) {
    global.frames_survived++;
}

var _current_state = Script_get_game_state();
var _action_chosen;

if(ia == "Q_TABLE"){
	if (last_state != "") {
	    Script_update_q_table(last_state, _current_state, last_action, last_player_hp, Object_player.life);
	}

	_action_chosen = Script_choose_action_q_table(_current_state);
}

if(ia == "FSM"){
	_action_chosen = Script_choose_action_fsm(_current_state);
}

if(ia == "UTILITY"){
	_action_chosen = Script_choose_action_utility(_current_state);
}

Script_execute_spawning(_action_chosen);

last_state = _current_state;
last_action = _action_chosen;
last_player_hp = Object_player.life;

alarm[0] = 60 * 3;