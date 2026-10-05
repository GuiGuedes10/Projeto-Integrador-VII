var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_red);
draw_text(_gui_w / 2, (_gui_h / 2) - 100, "VOCÊ MORREU!");

var _x_centro = _gui_w / 2;
var _y_centro = _gui_h / 2;

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