if (life <= 0) currently_state = enemy_state.dead
if (Object_player.currently_state == state.dead) currently_state = enemy_state.idle
if (currently_state != enemy_state.dead && Object_player.currently_state != state.dead) currently_state = enemy_state.walk

switch (currently_state){
	
	case enemy_state.walk:
		Script_enemy_walk();
		break;
		
	case enemy_state.dead:
		instance_destroy();
		break;
}