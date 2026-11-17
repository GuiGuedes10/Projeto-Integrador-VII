// Altere estas versoes quando mudar a implementacao do respectivo agente.
#macro PLAYER_AI_IMPLEMENTATION_VERSION "player_v5"
#macro DIRECTOR_Q_IMPLEMENTATION_VERSION "director_q_v1"

// Nao usa random: criar um ID nao altera a sequencia aleatoria do experimento.
function Script_model_identity(_kind) {
    if (!variable_global_exists("model_identity_counter")) global.model_identity_counter = 0;
    global.model_identity_counter++;
    return _kind + "-" + date_datetime_string(date_current_datetime()) + "-" + string(get_timer()) + "-" + string(global.model_identity_counter);
}

function Script_model_identity_from_save(_data, _field, _kind, _filename) {
    if (struct_exists(_data, _field)) {
        var _value = variable_struct_get(_data, _field);
        if (is_string(_value) && string_length(_value) > 0) return _value;
    }
    // Arquivos antigos nao permitem reconstruir a identidade original do treinamento.
    return "legacy-" + _kind + "-" + _filename;
}

// Nomes portaveis e verificados no disco; contadores de uma nova sessao podem repetir.
function Script_telemetry_filename(_match_id, _character, _director) {
    var _raw = "match_" + string(_match_id) + "_" + PLAYER_AI_IMPLEMENTATION_VERSION + "_" + _character + "_" + _director + "_" + Script_model_identity("checkpoint");
    var _allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-";
    var _base = "";
    for (var i = 1; i <= string_length(_raw); i++) {
        var _char = string_char_at(_raw, i);
        _base += (string_pos(_char, _allowed) > 0) ? _char : "_";
    }
    var _filename = _base + ".json";
    var _suffix = 1;
    while (file_exists(_filename)) {
        _filename = _base + "_" + string(_suffix) + ".json";
        _suffix++;
    }
    return _filename;
}
