enum state{
idle,
walk,
dead,
}

currently_state = state.idle;
player_speed = 3;
life = 500;
max_life = 500;
level = 1;
xp = 0;
attack_cooldown = 0;
_cooldown = 15;
dash_range = 100
dash_cooldown = 0
dash_cooldown_max = 60
dash_started = false


_impact_force = 8; 
knockback_x = 0;
knockback_y = 0;
knockback_friction = 0.1;

dash_circle = instance_create_layer(
    x, y,
    layer,
    Object_circle
);

dash_circle.target = id;
// Fonte dos comandos usados pelo personagem.
player_input = Object_input;

total_damage_dealt = 0;
total_damage_taken = 0;
total_kills = 0;
total_xp_collected = 0;
total_xp_pickups = 0;
death_processed = false;
aim_direction = 0;
dash_direction = 0;

ai_mode_at_start = global.player_ai_training ? "TREINAMENTO" : "AVALIACAO";
ai_mode_changed = false;

total_healing_received = 0;
total_potions_collected = 0;
total_levels_gained = 0;
