if (global.game_paused || life <= 0 || other.life <= 0 || dash_started) exit;


var _dir = point_direction(other.x, other.y, x, y);

knockback_x = lengthdir_x(_impact_force, _dir);
knockback_y = lengthdir_y(_impact_force, _dir);

var _actual_damage = min(life, max(0, other.strength));
life -= _actual_damage;
total_damage_taken += _actual_damage;

if(currently_state != state.dead){
	if (life <= max_life * 0.8) {
		Script_screenshake(8, 15);
	} else {
	    Script_screenshake(20, 30);
	}
}

