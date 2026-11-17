function Script_death(){
    if (death_processed) return;
    death_processed = true;
    if (global.bot_mode != "DESLIGADO" && instance_exists(Object_player_ai)) {
        with (Object_player_ai) Script_player_ai_update(true);
    }

    if (!variable_global_exists("match_counter")) {
        global.match_counter = 1;
    }
    
    var _match_id = global.match_counter;
    
    var _character = (object_index == Object_player_meele) ? "MELEE" : "RANGED";
    var _filename = Script_telemetry_filename(_match_id, _character, global.ia_director);

    var _match_stats = {
        telemetry_file: _filename,
        match_id: _match_id,
        ai_director: global.ia_director,                  
        frames_survived: Object_game.survival_time,      
        player_type: instance_exists(Object_player) ? (Object_player.object_index == Object_player_meele ? "MELEE" : "RANGED") : "DESCONHECIDO",
        timestamp: current_time,      
        bot_mode: global.bot_mode,
        player_ai_mode: global.player_ai_training ? "TREINAMENTO" : "AVALIACAO",
        player_ai_mode_at_start: ai_mode_at_start,
        player_ai_mode_changed: ai_mode_changed,
        player_ai_effective_epsilon: global.player_ai_training ? global.ai_epsilon : 0,
        damage_dealt: total_damage_dealt,
        damage_taken: total_damage_taken,
        kills: total_kills,
        xp_collected: total_xp_collected,
        healing_received: total_healing_received,
        potions_collected: total_potions_collected,
        levels_gained: total_levels_gained,
        reward_profile: {
            name: "survival_priority_v1",
            per_second_alive: PLAYER_AI_SURVIVAL_REWARD_PER_SECOND,
            per_damage_dealt: PLAYER_AI_DAMAGE_REWARD,
            per_kill: PLAYER_AI_KILL_REWARD,
            per_damage_taken: -0.6,
            death: -300,
            gamma: PLAYER_AI_GAMMA
        },
        resource_rewards: {per_healed_hp: PLAYER_AI_HEAL_REWARD, per_level: PLAYER_AI_LEVEL_REWARD, per_xp_pickup: 5},
        player_model_id: global.player_model_id,
        player_implementation_version: PLAYER_AI_IMPLEMENTATION_VERSION,
        player_agent_variant: "shared_character_resources",
        player_character_encoding: {melee: 0, ranged: 1},
        player_exploration: {
            initial_epsilon: PLAYER_AI_EPSILON_START,
            minimum_epsilon: PLAYER_AI_EPSILON_MIN,
            decay_per_combat_decision: PLAYER_AI_EPSILON_DECAY,
            decision_interval_frames: PLAYER_AI_DECISION_INTERVAL,
            training_decisions: global.ai_training_decisions,
            melee_training_decisions: global.ai_melee_training_decisions,
            ranged_training_decisions: global.ai_ranged_training_decisions
        },
        player_perception: {
            radius: PLAYER_AI_PERCEPTION_RADIUS,
            enemy_count_limit: PLAYER_AI_ENEMY_COUNT_LIMIT,
            sector_order: ["up", "down", "left", "right"],
            resource_input_order: ["potion_proximity", "potion_dx", "potion_dy", "xp_proximity", "xp_dx", "xp_dy"],
            proximity_encoding: "1 - distance / radius; empty = 0"
        },
        director_model_id: (global.ia_director == "Q_TABLE") ? global.director_model_id : noone,
        director_implementation_version: (global.ia_director == "Q_TABLE") ? DIRECTOR_Q_IMPLEMENTATION_VERSION : noone,
        player_brain: noone, 
        q_table: noone       
    };

    if (global.ia_director == "Q_TABLE" && variable_global_exists("ai_q_table")) {
        _match_stats.q_table = global.ai_q_table;
    }

    if (variable_global_exists("ai_brain") && is_struct(global.ai_brain)) {
        _match_stats.player_brain = {
            model_id: global.player_model_id,
            model_version: PLAYER_AI_MODEL_VERSION,
            action_version: PLAYER_AI_ACTION_VERSION,
            perception_radius: PLAYER_AI_PERCEPTION_RADIUS,
            enemy_count_limit: PLAYER_AI_ENEMY_COUNT_LIMIT,
            input_size: global.ai_brain.input_size,
            hidden_size: global.ai_brain.hidden_size,
            output_size: global.ai_brain.output_size,
            weights_ih: global.ai_brain.weights_ih,
            weights_ho: global.ai_brain.weights_ho,
            bias_h: global.ai_brain.bias_h,
            bias_o: global.ai_brain.bias_o,
            training_decisions: global.ai_training_decisions,
            melee_training_decisions: global.ai_melee_training_decisions,
            ranged_training_decisions: global.ai_ranged_training_decisions,
            ai_epsilon: global.ai_epsilon 
        };
    }

    var _json_string = json_stringify(_match_stats);
    
    var _file = file_text_open_write(_filename);
    if (_file < 0) {
        show_debug_message("Falha ao salvar telemetria: " + _filename);
    } else {
        file_text_write_string(_file, _json_string);
        file_text_close(_file);
    }

    global.match_counter++;

    if (instance_exists(Object_player) && Object_player.life <= 0 && global.bot_mode != "DESLIGADO") {
        room_restart();
    } else {
        instance_create_layer(0, 0, "Instances", Object_death_menu);
    }
}