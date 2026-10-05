if (Object_input.input_down) {
    index_selecionado++;
    if (index_selecionado >= array_length(opcoes)) index_selecionado = 0;
}

if (Object_input.input_top) {
    index_selecionado--;
    if (index_selecionado < 0) index_selecionado = array_length(opcoes) - 1;
}

if (Object_input.input_confirm) {
    global.game_paused = false; 
    
    switch(index_selecionado) {
        case 0: 
            room_restart(); 
            break;
            
        case 1: 
            room_goto(Room_menu);
            break;
            
        case 2: 
            game_end();
            break;
    }
}