if (global.game_paused) exit;

if (life <= 0) currently_state = state.dead
if (Object_input.player_walk && currently_state != state.dead) currently_state = state.walk

switch (currently_state){
	case state.walk:
		Script_player_walk();
		break;
	
	case state.dead:
		if (Object_player.life <= 0 && global.bot_mode != "DESLIGADO") {
		var _json_string = json_stringify(Object_game_director.q_table);
			var _filename = "qtable_" + string(global.bot_mode) + "_score_" + string(global.frames_survived) + ".json";
		    var _file = file_text_open_write(_filename);
		    file_text_write_string(_file, _json_string);
		    file_text_close(_file);
		    room_restart();
		}
		break;
}

Script_knockback();
Script_level_up();
