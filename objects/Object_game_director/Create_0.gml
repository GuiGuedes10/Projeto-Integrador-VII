// Hiperparâmetros do Q-Learning
alpha = 0.1;   // Learning Rate
gamma = 0.9;   // Discount Factor
epsilon = 0.15; // 15% de chance de testar algo novo, 85% de foco na melhor estratégia

max_enemies = 60; 

q_table = {};
last_state = "";
last_action = -1;

last_player_hp = (instance_exists(Object_player)) ? Object_player.life : 100;

alarm[0] = 60 * 3; 