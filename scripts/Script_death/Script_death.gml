function Script_death(){
    var _match_stats = {
        ai_type: global.ia_director,                   
        frames_survived: Object_game.survival_time,     
        player_type: instance_exists(Object_player) ? (Object_player.object_index == Object_player_meele ? "MELEE" : "RANGED") : "DESCONHECIDO",
        timestamp: current_time,      
		bot_mode: global.bot_mode,
    };

    if (global.ia_director == "Q_TABLE" && variable_global_exists("ai_q_table")) {
        _match_stats.q_table = global.ai_q_table;
    }

    var _json_string = json_stringify(_match_stats);
    
    var _filename = "telemetry_" + string(global.ia_director) + "_score_" + string(Object_game.survival_time) + "_bot_mode_" + global.bot_mode + ".json";
    
    var _file = file_text_open_write(_filename);
    file_text_write_string(_file, _json_string);
    file_text_close(_file);

    if (instance_exists(Object_player) && Object_player.life <= 0 && global.bot_mode != "DESLIGADO") {
        room_restart();
    } else {
        instance_create_layer(0, 0, "Instances", Object_death_menu);
    }
}