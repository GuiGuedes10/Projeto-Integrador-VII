if (global.game_paused) exit;

if (life <= 0) currently_state = state.dead
if (Object_input.player_walk && currently_state != state.dead) currently_state = state.walk
if (is_reloading) {
        reload_timer--;
        
        if (reload_timer <= 0) {
            bullet_current = max_bullet;
            is_reloading = false;
        }
    
}

if (Object_input.input_mb_left && currently_state != state.dead && !is_reloading) Script_attack();



switch (currently_state){
	case state.walk:
		Script_player_walk();
		break;
}

Script_knockback();
Script_level_up();