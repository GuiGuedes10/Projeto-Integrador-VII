event_inherited();
if (global.game_paused || currently_state == state.dead) exit;

if(player_input.input_mb_left && currently_state != state.dead) Script_attack_meele()