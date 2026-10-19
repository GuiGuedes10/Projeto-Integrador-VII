enum enemy_state{
walk,
attack,
dead,
idle,
freeze
}

currently_state = state.walk
life_max = 100
life = life_max
enemy_speed = 3
stopping_range = 10;
strength = 50;

knockback_x = 0;
knockback_y = 0;
knockback_friction = 0.1;

previous_life = life;
flash_timer = 0;