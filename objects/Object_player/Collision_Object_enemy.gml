var _dir = point_direction(other.x, other.y, x, y);

knockback_x = lengthdir_x(_impact_force, _dir);
knockback_y = lengthdir_y(_impact_force, _dir);

life -= other.strength;

if (life <= max_life * 0.8) {
    Script_screenshake(8, 15);
} else {
    Script_screenshake(20, 30);
}