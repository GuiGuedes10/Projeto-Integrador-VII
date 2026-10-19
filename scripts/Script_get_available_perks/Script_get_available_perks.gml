function Script_get_available_perks() {
    var _filtered_perks = [];
    var _current_char = global.current_character;
	

    for (var i = 0; i < array_length(global.perk_list); i++) {
        var _perk = global.perk_list[i];
        
        var _char_allowed = (_perk.allowed_characters == "all" || array_contains(_perk.allowed_characters, _current_char));
        
        if (_char_allowed) {
            var _condition_passed = true;
            
            if (variable_struct_exists(_perk, "condition")) {
                _condition_passed = _perk.condition();
            }
            
            if (_condition_passed) {
                array_push(_filtered_perks, _perk);
            }
        }
    }
    
    return _filtered_perks;
}