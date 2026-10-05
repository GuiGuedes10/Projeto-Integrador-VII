if (!variable_global_exists("ai_q_table")) {
    global.ai_q_table = {}; 
}

q_table = global.ai_q_table;

last_state = "";
last_action = 0;

if (instance_exists(Object_player)) {
    last_player_hp = Object_player.life;
} else {
    last_player_hp = 500; 
}

alpha = 0.1;
gamma = 0.9;
epsilon = 0.2; 
max_enemies = 30; 

global.frames_survived = 0;
global.bot_mode = "DESLIGADO"; 

if (global.bot_mode != "DESLIGADO") {
    game_set_speed(600, gamespeed_fps);
}

alarm[0] = 60 * 3;