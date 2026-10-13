if (global.game_paused) exit;

if (life <= 0) currently_state = state.dead
if (Object_input.player_walk && currently_state != state.dead) currently_state = state.walk

switch (currently_state){
	case state.walk:
		Script_player_walk();
		break;
	
	case state.dead:
		Script_death();
		break;
}

Script_knockback();
Script_level_up();
