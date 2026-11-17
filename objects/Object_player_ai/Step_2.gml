// Aplica a troca depois do consumo dos comandos deste frame.
// Assim o proximo Begin Step gera comandos para o novo modo.
if (Object_input.input_toggle_bot) {
    global.bot_mode = (global.bot_mode == "LIGADO") ? "DESLIGADO" : "LIGADO";
    Script_player_ai_reset();
}

// Preserva o epsilon aprendido; a avaliacao usa exploracao efetiva zero.
if (Object_input.input_toggle_ai_training) {
    global.player_ai_training = !global.player_ai_training;
    var _player = instance_find(Object_player, 0);
    if (_player != noone) _player.ai_mode_changed = true;
    Script_player_ai_reset();
}
