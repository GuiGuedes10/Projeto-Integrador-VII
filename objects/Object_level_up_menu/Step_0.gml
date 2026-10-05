if (cooldown > 0) {
    cooldown--;
}

if(global.bot_mode != "DESLIGADO"){
	options[index_selecionado].effect();
    global.game_paused = false;
    instance_destroy();
}

if (cooldown <= 0) {
    if (Object_input.input_right) {
        index_selecionado++;
        if (index_selecionado >= array_length(options)) index_selecionado = 0;
        cooldown = _timer; 
    }

    if (Object_input.input_left) {
        index_selecionado--;
        if (index_selecionado < 0) index_selecionado = array_length(options) - 1;
        cooldown = _timer; 
    }
}

if (Object_input.input_confirm) {
    options[index_selecionado].effect();
    global.game_paused = false;
    instance_destroy();
}