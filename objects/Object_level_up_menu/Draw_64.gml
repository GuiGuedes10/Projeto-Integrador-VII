var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

draw_set_color(c_yellow);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_gui_w / 2, 80, "NOVO NÍVEL ALCANÇADO!");

var _card_w = 160;
var _card_h = 220;
var _spacing = 200;
var _start_x = (_gui_w / 2) - _spacing;
var _start_y = _gui_h / 2;

for (var _i = 0; _i < 3; _i++) {
    var _cx = _start_x + (_i * _spacing);
    var _cy = _start_y;
    
    var _x1 = _cx - (_card_w / 2);
    var _y1 = _cy - (_card_h / 2);
    var _x2 = _cx + (_card_w / 2);
    var _y2 = _cy + (_card_h / 2);
    
    var _hover = point_in_rectangle(_mouse_x, _mouse_y, _x1, _y1, _x2, _y2);
    
    draw_set_color(_hover ? c_dkgray : c_black);
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    
    draw_set_color(_hover ? c_yellow : c_white);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    
    draw_set_color(c_white);
    draw_text_ext(_cx, _y1 + 40, options[_i].title, 16, _card_w - 20);
    
    draw_set_color(c_ltgray);
    draw_text_ext(_cx, _cy + 20, options[_i].description, 14, _card_w - 20);
    
    if (_hover && Object_input.input_mb_left) {
        options[_i].effect();
        
        global.game_paused = false;
        
        instance_destroy();
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);