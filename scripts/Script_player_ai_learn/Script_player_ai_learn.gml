function Script_player_ai_learn(_observation, _terminal) {
    // Bloqueio tambem cobre a atualizacao terminal antes do salvamento.
    if (!global.player_ai_training) {
        global.ai_accumulated_reward = 0;
        return;
    }
    if (is_array(global.ai_last_inputs) && global.ai_player_last_action >= 0) {
        var _max_next_q = 0;
        if (!_terminal) {
            var _next_q = global.ai_brain.forward(_observation.inputs);
            var _actions = _observation.actions;
            _max_next_q = _next_q[_actions[0]];
            for (var i = 1; i < array_length(_actions); i++) {
                _max_next_q = max(_max_next_q, _next_q[_actions[i]]);
            }
        }

        var _target_q = global.ai_brain.forward(global.ai_last_inputs);
        _target_q[global.ai_player_last_action] = global.ai_accumulated_reward + PLAYER_AI_GAMMA * _max_next_q;
        global.ai_brain.train(global.ai_last_inputs, _target_q, 0.05);
    }
    global.ai_accumulated_reward = 0;
}
