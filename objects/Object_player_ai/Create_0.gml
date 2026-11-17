if (!variable_global_exists("bot_mode")) global.bot_mode = "DESLIGADO";
if (!variable_global_exists("ai_brain")) {
    global.ai_epsilon = PLAYER_AI_EPSILON_START;
    global.ai_training_decisions = 0;
    global.ai_melee_training_decisions = 0;
    global.ai_ranged_training_decisions = 0;
    global.player_model_id = Script_model_identity("player");
    global.ai_brain = new NeuralNetwork(PLAYER_AI_INPUT_SIZE, PLAYER_AI_HIDDEN_SIZE, player_ai_action.count);
}
if (!variable_global_exists("player_model_id")) global.player_model_id = Script_model_identity("player");
if (!variable_global_exists("ai_epsilon")) global.ai_epsilon = PLAYER_AI_EPSILON_START;
if (!variable_global_exists("player_ai_training")) global.player_ai_training = true;
Script_player_ai_reset();

if (!variable_global_exists("ai_training_decisions")) global.ai_training_decisions = 0;
if (!variable_global_exists("ai_melee_training_decisions")) global.ai_melee_training_decisions = 0;
if (!variable_global_exists("ai_ranged_training_decisions")) global.ai_ranged_training_decisions = 0;
