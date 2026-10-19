if (global.game_paused) exit;

if (life <= 0) {
	currently_state = enemy_state.dead
	Script_crate_xp(x, y)
	}
if (Object_player.currently_state == state.dead) currently_state = enemy_state.idle
if (currently_state != enemy_state.dead && Object_player.currently_state != state.dead && currently_state != enemy_state.freeze) currently_state = enemy_state.walk

switch (currently_state){
	
	case enemy_state.walk:
		Script_enemy_walk();
		break;
		
	case enemy_state.dead:
		instance_destroy();
		break;
	
	case enemy_state.freeze:
		Script_enemy_freeze();
		break;
}

if (life < previous_life) {
    flash_timer = 6; 
}

previous_life = life;

if (flash_timer > 0) {
    flash_timer--;
}

Script_enemy_colision()