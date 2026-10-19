global.game_paused = true;

if (!variable_global_exists("perk_list")) {
    Script_init_perks();
}

var _available = Script_get_available_perks();

_available = array_shuffle(_available);

options = [];
var _max_options = min(3, array_length(_available)); 

for (var i = 0; i < _max_options; i++) {
    array_push(options, _available[i]);
}

index_selecionado = 0;
cooldown = 0;
_timer = 10;