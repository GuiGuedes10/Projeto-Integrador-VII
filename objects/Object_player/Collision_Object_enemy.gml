var _dir = point_direction(other.x, other.y, x, y);

knockback_x = lengthdir_x(_impact_force, _dir);
knockback_y = lengthdir_y(_impact_force, _dir);

life -= other.strength;