if (global.game_paused) exit;
Script_enemy_take_damage(other, demage);
other.currently_state = enemy_state.freeze;

other.freeze_timer = 180; 

instance_destroy(); 