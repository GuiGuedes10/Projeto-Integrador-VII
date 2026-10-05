function Script_knockback(){
	knockback_x = lerp(knockback_x, 0, knockback_friction);
	knockback_y = lerp(knockback_y, 0, knockback_friction);

	Script_colison(knockback_x, knockback_y, Object_collision_square);
}