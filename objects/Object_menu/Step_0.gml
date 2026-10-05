var _cima = Object_input.input_top
var _baixo = Object_input.input_down
var _confirma = Object_input.input_confirm

if (_baixo) {
    index_selecionado++;
    if (index_selecionado >= array_length(opcoes)) index_selecionado = 0;
}

if (_cima) {
    index_selecionado--;
    if (index_selecionado < 0) index_selecionado = array_length(opcoes) - 1;
}

if (_confirma) {
    if (estado_atual == 0) { 
        switch(index_selecionado) {
            case 0: 
                estado_atual = 1;               
                opcoes = menu_personagens;     
                index_selecionado = 0;         
                break;
                
            case 1: 
                game_end();
                break;
        }
    } 
    else if (estado_atual == 1) { 
        switch(index_selecionado) {
            case 0:
                global.current_character = "Meele"; 
                room_goto(Room_game);                 
                break;
                
            case 1: 
                global.current_character = "Ranged"; 
                room_goto(Room_game);                   
                break;
                
            case 2: 
                estado_atual = 0;             
                opcoes = menu_principal;      
                index_selecionado = 0;
                break;
        }
    }
}