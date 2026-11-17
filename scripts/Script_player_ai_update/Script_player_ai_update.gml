// Executado no contexto de Object_player_ai, inclusive antes de salvar uma morte.
function Script_player_ai_update(_terminal = false) {
    var _player = instance_find(Object_player, 0);
    if (_player == noone) {
        Script_player_ai_reset();
        return;
    }

    if (!variable_instance_exists(id, "episode_player")) Script_player_ai_reset();
    if (episode_player != _player) Script_player_ai_reset();
    if (episode_finished) return;

    var _is_dead = _terminal || _player.life <= 0;
    if (global.game_paused && !_is_dead) return;

    var _observation = Script_player_ai_observe(_player);
    var _frame_reward = _is_dead ? -300.0 : PLAYER_AI_SURVIVAL_REWARD_PER_SECOND / game_get_speed(gamespeed_fps);

    // Contadores cumulativos independem do alvo atual e do XP gasto ao subir de nivel.
    _frame_reward += (_player.total_damage_dealt - last_damage_dealt) * PLAYER_AI_DAMAGE_REWARD;
    _frame_reward -= (_player.total_damage_taken - last_damage_taken) * 0.6;
    _frame_reward += (_player.total_kills - last_kills) * PLAYER_AI_KILL_REWARD;
    _frame_reward += (_player.total_xp_pickups - last_xp_pickups) * 5.0;
    _frame_reward += (_player.total_healing_received - last_healing_received) * PLAYER_AI_HEAL_REWARD;
    _frame_reward += (_player.total_levels_gained - last_levels_gained) * PLAYER_AI_LEVEL_REWARD;
    last_healing_received = _player.total_healing_received;
    last_levels_gained = _player.total_levels_gained;
    last_damage_dealt = _player.total_damage_dealt;
    last_damage_taken = _player.total_damage_taken;
    last_kills = _player.total_kills;
    last_xp_pickups = _player.total_xp_pickups;
    global.ai_accumulated_reward += _frame_reward;

    global.ai_timer--;
    if (global.ai_timer <= 0 || _is_dead) {
        Script_player_ai_learn(_observation, _is_dead);

        if (_is_dead) {
            episode_finished = true;
            global.ai_last_inputs = noone;
            global.ai_player_last_action = -1;
            global.ai_current_action = player_ai_action.idle;
            return;
        }

        global.ai_timer = PLAYER_AI_DECISION_INTERVAL;
        // Uma decisao sem inimigos so permite esperar; nao gasta a janela de exploracao.
        if (global.player_ai_training && array_length(_observation.actions) > 1) {
            global.ai_training_decisions++;
            if (_player.object_index == Object_player_ranged) {
                global.ai_ranged_training_decisions++;
            } else {
                global.ai_melee_training_decisions++;
            }
            global.ai_epsilon = max(PLAYER_AI_EPSILON_MIN, global.ai_epsilon - PLAYER_AI_EPSILON_DECAY);
        }
        var _actions = _observation.actions;
        var _best_action = _actions[0];
        if (global.player_ai_training && random(1.0) < global.ai_epsilon) {
            _best_action = _actions[irandom(array_length(_actions) - 1)];
        } else {
            var _q_values = global.ai_brain.forward(_observation.inputs);
            for (var i = 1; i < array_length(_actions); i++) {
                var _action = _actions[i];
                if (_q_values[_action] > _q_values[_best_action]) _best_action = _action;
            }
        }

        global.ai_last_inputs = _observation.inputs;
        global.ai_player_last_action = _best_action;
        global.ai_current_action = _best_action;
    }

    // Sem alvo o episodio continua, mas nenhum comando de combate e emitido.
    // Recursos tambem podem ser buscados quando nao ha inimigos.

    if (_observation.enemy == noone && global.ai_current_action < player_ai_action.seek_potion) return;
    var _dir = _observation.direction;
    var _move_dir = -1;
    input_aim_direction = _dir;
    input_dash_direction = _dir;

    switch (global.ai_current_action) {
        case player_ai_action.seek_potion:
            if (_observation.potion.target != noone && _player.life < _player.max_life) {
                _move_dir = _observation.potion.direction;
                input_mb_left = (_observation.enemy != noone);
            }
            break;
        case player_ai_action.seek_xp:
            if (_observation.xp.target != noone) {
                _move_dir = _observation.xp.direction;
                input_mb_left = (_observation.enemy != noone);
            }
            break;
        case player_ai_action.approach:
            _move_dir = _dir;
            break;
        case player_ai_action.retreat:
            _move_dir = _dir + 180;
            break;
        case player_ai_action.idle:
            break;
        case player_ai_action.dash_away:
            input_dash_direction = _dir + 180;
            input_shift = _observation.dash_ready;
            break;
        case player_ai_action.dash_toward:
            input_shift = _observation.dash_ready;
            break;
        case player_ai_action.retreat_attack:
            _move_dir = _dir + 180;
            input_mb_left = true;
            break;
        case player_ai_action.idle_attack:
            input_mb_left = true;
            break;
        case player_ai_action.approach_attack:
            _move_dir = _dir;
            input_mb_left = true;
            break;
    }

    if (_move_dir != -1) {
        var _move_x = lengthdir_x(1, _move_dir);
        var _move_y = lengthdir_y(1, _move_dir);
        input_right = (_move_x > 0.3);
        input_left = (_move_x < -0.3);
        input_down = (_move_y > 0.3);
        input_top = (_move_y < -0.3);
    }
}
