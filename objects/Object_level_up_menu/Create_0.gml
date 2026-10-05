global.game_paused = true;

if (!variable_global_exists("perk_list")) {
    Script_init_perks();
}

var _available = [];
var _current_char = global.current_character; 

for (var _i = 0; _i < array_length(global.perk_list); _i++) {
    var _perk = global.perk_list[_i]; 
    
    if (array_contains(_perk.allowed_characters, "all") || array_contains(_perk.allowed_characters, _current_char)) {
        array_push(_available, _perk);
    }
}

_available = array_shuffle(_available);

options = [];
var _max_options = min(3, array_length(_available)); 

for (var i = 0; i < _max_options; i++) {
    array_push(options, _available[i]);
}

index_selecionado = 0;
cooldown = 0;
_timer = 10