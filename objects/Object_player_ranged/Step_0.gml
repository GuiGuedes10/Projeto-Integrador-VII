event_inherited();
if (global.game_paused || currently_state == state.dead) exit;

if (is_reloading) {
        reload_timer--;
        
        if (reload_timer <= 0) {
            bullet_current = max_bullet;
            is_reloading = false;
        }
    
}


if (player_input.input_mb_left && currently_state != state.dead && !is_reloading) Script_attack_ranged();
