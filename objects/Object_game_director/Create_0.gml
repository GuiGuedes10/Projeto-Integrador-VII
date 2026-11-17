if (!variable_global_exists("ai_q_table")) {
    global.director_model_id = Script_model_identity("director-q");
    global.ai_q_table = {}; 
}

if (!variable_global_exists("director_model_id")) global.director_model_id = Script_model_identity("director-q");

global.ia_director = "Q_TABLE";
//global.ia_director = "FSM";
//global.ia_director = "UTILITY";

ia = global.ia_director;

q_table = global.ai_q_table;
global.last_state = "";
global.last_action = 0;

if (instance_exists(Object_player)) {
    last_player_hp = Object_player.life;
} else {
    last_player_hp = 500; 
}

alpha = 0.1;
gamma = 0.9;
epsilon = 0.2; 
global.max_enemies = 10; 

global.frames_survived = 0;

alarm[0] = 60 * 3;