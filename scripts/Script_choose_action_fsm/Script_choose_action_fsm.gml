function Script_choose_action_fsm(_current_state){
	var _action_chosen = 0;
    if (string_count("HP_LOW", _current_state) > 0) {
        _action_chosen = 0; 
    } 
    else if (string_count("ENEMIES_FULL", _current_state) > 0 || string_count("ENEMIES_HIGH", _current_state) > 0) {
        _action_chosen = 0;
    } 
    else if (string_count("HP_HIGH", _current_state) > 0 && string_count("ENEMIES_LOW", _current_state) > 0) {
        _action_chosen = choose(1, 5);
    } 
    else {
        _action_chosen = choose(2, 3, 4);
    }
    
    return _action_chosen;
}