draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _x_centro = display_get_gui_width() / 2;
var _y_centro = display_get_gui_height() / 2;

if (estado_atual == 1) {
    draw_set_color(c_aqua);
    draw_text(_x_centro, _y_centro - 100, "ESCOLHA SEU PERSONAGEM");
}

for (var i = 0; i < array_length(opcoes); i++) {
    if (i == index_selecionado) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_white);
    }
    
    draw_text(_x_centro, _y_centro + (i * espacamento), opcoes[i]);
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);