#macro PLAYER_AI_INPUT_SIZE 16
#macro PLAYER_AI_HEAL_REWARD 0.5
#macro PLAYER_AI_LEVEL_REWARD 20
#macro PLAYER_AI_EPSILON_START 0.5
#macro PLAYER_AI_EPSILON_MIN 0.05
#macro PLAYER_AI_EPSILON_DECAY 0.00005
#macro PLAYER_AI_DECISION_INTERVAL 12
#macro PLAYER_AI_PERCEPTION_RADIUS 300
#macro PLAYER_AI_ENEMY_COUNT_LIMIT 10
#macro PLAYER_AI_HIDDEN_SIZE 8
#macro PLAYER_AI_MODEL_VERSION 5
#macro PLAYER_AI_SURVIVAL_REWARD_PER_SECOND 20
#macro PLAYER_AI_DAMAGE_REWARD 0.02
#macro PLAYER_AI_KILL_REWARD 5
#macro PLAYER_AI_GAMMA 0.99
#macro PLAYER_AI_ACTION_VERSION 2

enum player_ai_action {
    approach,
    retreat,
    idle,
    dash_away,
    dash_toward,
    retreat_attack,
    idle_attack,
    approach_attack,
    seek_potion,
    seek_xp,
    count
}

// Reinicia apenas a transicao da partida; preserva pesos e exploracao aprendidos.
function Script_player_ai_reset() {
    global.ai_timer = 0;
    global.ai_current_action = player_ai_action.idle;
    global.ai_last_inputs = noone;
    global.ai_player_last_action = -1;
    global.ai_accumulated_reward = 0;

    episode_player = instance_find(Object_player, 0);
    episode_finished = false;
    last_damage_dealt = 0;
    last_damage_taken = 0;
    last_kills = 0;
    last_xp_pickups = 0;
    last_healing_received = 0;
    last_levels_gained = 0;
    if (episode_player != noone) {
        last_damage_dealt = episode_player.total_damage_dealt;
        last_damage_taken = episode_player.total_damage_taken;
        last_kills = episode_player.total_kills;
        last_xp_pickups = episode_player.total_xp_pickups;
        last_healing_received = episode_player.total_healing_received;
        last_levels_gained = episode_player.total_levels_gained;
    }

    input_left = false;
    input_right = false;
    input_top = false;
    input_down = false;
    input_mb_left = false;
    input_shift = false;
    input_confirm = false;
    player_walk = false;
    input_aim_direction = 0;
    input_dash_direction = 0;
}
