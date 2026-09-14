global.game_paused = true;

if (!variable_global_exists("perk_list")) {
    Script_init_perks();
}

var _available = array_create(array_length(global.perk_list));
array_copy(_available, 0, global.perk_list, 0, array_length(global.perk_list));
_available = array_shuffle(_available);

options = [
    _available[0],
    _available[1],
    _available[2]
];