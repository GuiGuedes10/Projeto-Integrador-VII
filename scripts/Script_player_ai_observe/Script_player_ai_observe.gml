function Script_player_ai_observe(_player) {
    var _enemy = noone;
    var _distance = infinity;
    var _nearby_count = 0;
    // Ordem fixa dos setores: cima, baixo, esquerda, direita.
    var _proximity = [0, 0, 0, 0];
    with (Object_enemy) {
        if (life > 0) {
            var _candidate_distance = point_distance(_player.x, _player.y, x, y);
            if (_candidate_distance <= PLAYER_AI_PERCEPTION_RADIUS) {
                _nearby_count++;
                var _dx = x - _player.x;
                var _dy = y - _player.y;
                var _sector;
                // Na diagonal exata, o setor horizontal vence; nenhum inimigo e contado duas vezes.
                if (abs(_dx) >= abs(_dy)) {
                    _sector = (_dx < 0) ? 2 : 3;
                } else {
                    _sector = (_dy < 0) ? 0 : 1;
                }
                var _value = clamp(1 - _candidate_distance / PLAYER_AI_PERCEPTION_RADIUS, 0, 1);
                _proximity[_sector] = max(_proximity[_sector], _value);
            }
            if (_candidate_distance < _distance) {
                _distance = _candidate_distance;
                _enemy = id;
            }
        }
    }

    var _direction = (_enemy == noone) ? 0 : point_direction(_player.x, _player.y, _enemy.x, _enemy.y);
    var _dash_ready = (_player.dash_cooldown <= 0 && !_player.dash_started);
    var _potion = Script_player_ai_resource(_player, Object_life_potion);
    var _xp = Script_player_ai_resource(_player, Object_Xp);
    var _inputs = [
        (_enemy == noone) ? 1 : clamp(_distance / 500.0, 0, 1),
        clamp(_player.life / max(1, _player.max_life), 0, 1),
        _direction / 360.0,
        _dash_ready ? 1.0 : 0.0,
        clamp(_nearby_count / PLAYER_AI_ENEMY_COUNT_LIMIT, 0, 1),
        _proximity[0],
        _proximity[1],
        _proximity[2],
        _proximity[3],
        (_player.object_index == Object_player_ranged) ? 1.0 : 0.0,
        _potion.inputs[0], _potion.inputs[1], _potion.inputs[2],
        _xp.inputs[0], _xp.inputs[1], _xp.inputs[2]
    ];

    var _actions = [];
    for (var i = 0; i < player_ai_action.count; i++) {
        if (i == player_ai_action.seek_potion) {
            if (_potion.target != noone && _player.life < _player.max_life) array_push(_actions, i);
            continue;
        }
        if (i == player_ai_action.seek_xp) {
            if (_xp.target != noone) array_push(_actions, i);
            continue;
        }
        if (_enemy == noone && i != player_ai_action.idle) continue;
        if (!_dash_ready && (i == player_ai_action.dash_away || i == player_ai_action.dash_toward)) continue;
        array_push(_actions, i);
    }

    return {potion: _potion, xp: _xp, enemy: _enemy, direction: _direction, dash_ready: _dash_ready, inputs: _inputs, actions: _actions};
}

// Tres entradas por recurso: proximidade, deslocamento X e deslocamento Y.
function Script_player_ai_resource(_player, _object) {
    var _target = instance_nearest(_player.x, _player.y, _object);
    if (_target == noone) return {target: noone, direction: 0, inputs: [0, 0, 0]};
    var _distance = point_distance(_player.x, _player.y, _target.x, _target.y);
    if (_distance > PLAYER_AI_PERCEPTION_RADIUS) return {target: noone, direction: 0, inputs: [0, 0, 0]};
    return {target: _target,
        direction: point_direction(_player.x, _player.y, _target.x, _target.y),
        inputs: [clamp(1 - _distance / PLAYER_AI_PERCEPTION_RADIUS, 0, 1),
            clamp((_target.x - _player.x) / PLAYER_AI_PERCEPTION_RADIUS, -1, 1),
            clamp((_target.y - _player.y) / PLAYER_AI_PERCEPTION_RADIUS, -1, 1)]};
}
