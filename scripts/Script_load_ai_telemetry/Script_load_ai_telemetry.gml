function Script_player_ai_model_valid(_model) {
    if (!is_struct(_model)) return false;
    var _fields = ["model_version", "action_version", "perception_radius", "enemy_count_limit", "input_size", "hidden_size", "output_size", "weights_ih", "weights_ho", "bias_h", "bias_o"];
    for (var i = 0; i < array_length(_fields); i++) {
        if (!struct_exists(_model, _fields[i])) return false;
    }
    if (_model.model_version != PLAYER_AI_MODEL_VERSION || _model.action_version != PLAYER_AI_ACTION_VERSION) return false;
    if (_model.input_size != PLAYER_AI_INPUT_SIZE || _model.hidden_size != PLAYER_AI_HIDDEN_SIZE || _model.output_size != player_ai_action.count) return false;
    if (_model.perception_radius != PLAYER_AI_PERCEPTION_RADIUS || _model.enemy_count_limit != PLAYER_AI_ENEMY_COUNT_LIMIT) return false;
    var _weights = [_model.weights_ih, _model.weights_ho];
    var _biases = [_model.bias_h, _model.bias_o];
    var _rows = [_model.hidden_size, _model.output_size];
    var _cols = [_model.input_size, _model.hidden_size];
    for (var layer_index = 0; layer_index < 2; layer_index++) {
        var _matrix = _weights[layer_index];
        var _bias = _biases[layer_index];
        if (!is_array(_matrix) || !is_array(_bias)) return false;
        if (array_length(_matrix) != _rows[layer_index] || array_length(_bias) != _rows[layer_index]) return false;
        for (var row_index = 0; row_index < _rows[layer_index]; row_index++) {
            if (!is_real(_bias[row_index]) || !is_array(_matrix[row_index])) return false;
            if (array_length(_matrix[row_index]) != _cols[layer_index]) return false;
            for (var col_index = 0; col_index < _cols[layer_index]; col_index++) {
                if (!is_real(_matrix[row_index][col_index])) return false;
            }
        }
    }
    return true;
}

function Script_load_ai_telemetry(_filename) {
    if (!file_exists(_filename)) {
        show_debug_message("Arquivo de telemetria nao encontrado: " + string(_filename));
        return false;
    }
    var _file = file_text_open_read(_filename);
    if (_file < 0) return false;
    var _json_string = "";
    while (!file_text_eof(_file)) {
        _json_string += file_text_read_string(_file);
        file_text_readln(_file);
    }
    file_text_close(_file);
    var _data;
    try {
        _data = json_parse(_json_string);
    } catch (_error) {
        show_debug_message("Telemetria invalida: " + string(_filename));
        return false;
    }
    if (!is_struct(_data)) return false;
    var _loaded = false;
    if (struct_exists(_data, "player_brain") && _data.player_brain != noone) {
        var _model = _data.player_brain;
        if (!Script_player_ai_model_valid(_model)) {
            show_debug_message("Modelo do player incompativel; cerebro atual preservado: " + string(_filename));
        } else {
            var _brain = new NeuralNetwork(_model.input_size, _model.hidden_size, _model.output_size);
            _brain.weights_ih = _model.weights_ih;
            _brain.weights_ho = _model.weights_ho;
            _brain.bias_h = _model.bias_h;
            _brain.bias_o = _model.bias_o;
            global.ai_brain = _brain;
            global.player_model_id = Script_model_identity_from_save(_data, "player_model_id", "player", _filename);
            global.ai_epsilon = (struct_exists(_model, "ai_epsilon") && is_real(_model.ai_epsilon)) ? clamp(_model.ai_epsilon, 0.05, 1) : 0.05;
            global.ai_training_decisions = (struct_exists(_model, "training_decisions") && is_real(_model.training_decisions) && _model.training_decisions >= 0) ? floor(_model.training_decisions) : 0;
            global.ai_melee_training_decisions = (struct_exists(_model, "melee_training_decisions") && is_real(_model.melee_training_decisions) && _model.melee_training_decisions >= 0) ? floor(_model.melee_training_decisions) : 0;
            global.ai_ranged_training_decisions = (struct_exists(_model, "ranged_training_decisions") && is_real(_model.ranged_training_decisions) && _model.ranged_training_decisions >= 0) ? floor(_model.ranged_training_decisions) : 0;
            if (instance_exists(Object_player_ai)) {
                with (Object_player_ai) Script_player_ai_reset();
            }
            _loaded = true;
        }
    }
    if (struct_exists(_data, "q_table") && is_struct(_data.q_table)) {
        global.ai_q_table = _data.q_table;
        global.director_model_id = Script_model_identity_from_save(_data, "director_model_id", "director-q", _filename);
        _loaded = true;
    }
    return _loaded;
}
