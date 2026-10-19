function Script_chain_lightning(_first_enemy, _jumps, _range) {
    if (!instance_exists(_first_enemy)) return;

    var _hit_enemies = [_first_enemy];
    var _damage = global.bullet_damage * 0.5; 
    
    if (variable_instance_exists(_first_enemy, "life")) {
        _first_enemy.life -= _damage;
    }
    
    var _current_target = _first_enemy;

    for (var i = 0; i < _jumps; i++) {
        var _nearest_enemy = noone;
        var _min_dist = _range; 

        with (Object_enemy) { 
            if (id != _current_target && !array_contains(_hit_enemies, id)) {
                var _dist = point_distance(_current_target.x, _current_target.y, x, y);
                
                if (_dist <= _min_dist) {
                    _min_dist = _dist;
                    _nearest_enemy = id;
                }
            }
        }

        if (_nearest_enemy != noone) {

            var _effect = instance_create_layer(_current_target.x, _current_target.y, "Instances", Object_lightning_effect);
            _effect.x1 = _current_target.x;
            _effect.y1 = _current_target.y;
            _effect.x2 = _nearest_enemy.x;
            _effect.y2 = _nearest_enemy.y;

            if (variable_instance_exists(_nearest_enemy, "life")) {
                _nearest_enemy.life -= _damage;
            }
            
            array_push(_hit_enemies, _nearest_enemy);
            _current_target = _nearest_enemy;
            
        } else {
            break; 
        }
    }
}