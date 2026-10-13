function Script_choose_action_utility(_current_state) {
    var _scores = [0, 0, 0, 0, 0, 0];
    
    var _is_hp_high = (string_count("HP_HIGH", _current_state) > 0);
    var _is_hp_low = (string_count("HP_LOW", _current_state) > 0);
    var _is_enemies_low = (string_count("ENEMIES_LOW", _current_state) > 0);
    var _is_enemies_full = (string_count("ENEMIES_FULL", _current_state) > 0);
    
    if (_is_hp_low) _scores[0] += 15.0;       
    if (_is_enemies_full) _scores[0] += 10.0;  
    
    if (_is_hp_high && _is_enemies_low) _scores[1] += 12.0; 
    
    if (_is_hp_high) _scores[2] += 6.0;
    if (_is_enemies_low) _scores[2] += 8.0;
    
    if (_is_hp_high && !_is_enemies_full) _scores[3] += 9.0;
    
    _scores[4] += 5.0; 
    
    if (_is_hp_high && _is_enemies_low) _scores[5] += 14.0; 
    if (_is_hp_low || _is_enemies_full) _scores[5] -= 50.0;  
    
    var _best_action = 0;
    var _best_score = _scores[0];
    
    for (var i = 1; i < 6; i++) {
        if (_scores[i] > _best_score) {
            _best_score = _scores[i];
            _best_action = i;
        }
    }
    
    return _best_action;
}