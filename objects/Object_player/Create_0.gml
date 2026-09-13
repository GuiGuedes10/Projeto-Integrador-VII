enum state{
idle,
walk,
dead
}

currently_state = state.idle;
player_speed = 4;
life = 1000;
max_life = 1000;
level = 0;
xp = 0;
attack_cooldown = 0;

max_bullet = 6
bullet_current = max_bullet;
is_reloading = false;
reload_timer = 0;

_impact_force = 8; 
knockback_x = 0;
knockback_y = 0;
knockback_friction = 0.1;