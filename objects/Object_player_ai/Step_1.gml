// Produz comandos antes do Step do jogador, sem modificar o input fisico.
input_left = false;
input_right = false;
input_top = false;
input_down = false;
input_mb_left = false;
input_shift = false;
input_confirm = false;
player_walk = false;

if (global.bot_mode == "DESLIGADO") exit;

Script_player_ai_update();

player_walk = (input_left || input_right || input_top || input_down);
