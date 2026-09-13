function Script_knockback(){
	knockback_x = lerp(knockback_x, 0, knockback_friction);
	knockback_y = lerp(knockback_y, 0, knockback_friction);

	x += knockback_x;
	y += knockback_y;
}