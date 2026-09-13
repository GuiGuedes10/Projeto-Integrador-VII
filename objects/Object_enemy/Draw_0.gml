draw_self();

var _bar_width = 32;  
var _bar_height = 4;  

var _bar_x = x - (_bar_width / 2);

var _bar_y = y + 24; 

var _life_percent = clamp(life / life_max, 0, 1);
var _current_width = _bar_width * _life_percent;

draw_set_color(c_black);
draw_rectangle(_bar_x - 1, _bar_y - 1, _bar_x + _bar_width + 1, _bar_y + _bar_height + 1, false);

draw_set_color(c_maroon);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, false);

draw_set_color(c_red);
draw_rectangle(_bar_x, _bar_y, _bar_x + _current_width, _bar_y + _bar_height, false);

draw_set_color(c_white);