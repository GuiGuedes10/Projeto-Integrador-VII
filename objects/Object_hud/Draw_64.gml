if (instance_exists(Object_player)) {
    var _start_x = 50; 
    var _start_y = 50; 
    
    var _current_cicle = (current_time + heart_offset) % heart_cycle_speed;
    var _frame = 0; 
    
    if (_current_cicle < 100) {
        _frame = 1;
    } else if (_current_cicle > 200 && _current_cicle < 300) {
        _frame = 1;
    }
    
    draw_sprite(Sprite_life_hud, _frame, _start_x, _start_y);

   if (instance_exists(Object_player)) {
    var _heart_width = sprite_get_width(Sprite_life_hud);
    var _bar_x = _start_x + _heart_width - 40; 
    var _bar_y = _start_y; 
    var _bar_height = 16; 
    
    var _pixels_per_hp = 0.25; 
    
    var _max_bar_width = Object_player.max_life * _pixels_per_hp; 
    
    var _life_percent = clamp(Object_player.life / Object_player.max_life, 0, 1);
    var _current_bar_width = _max_bar_width * _life_percent;

    draw_set_color(c_maroon);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _max_bar_width, _bar_y + _bar_height, false);

    draw_set_color(c_red);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _current_bar_width, _bar_y + _bar_height, false);

    var _segments = Object_player.max_life / 10;
    draw_set_color(c_black);
    
    for (var _i = 1; _i < _segments; _i++) {
        var _line_x = _bar_x + (_i * 10 * _pixels_per_hp);
        
        draw_line(_line_x, _bar_y, _line_x, _bar_y + _bar_height - 1);
    }

    draw_set_color(c_black);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _max_bar_width, _bar_y + _bar_height, true);

    draw_set_color(c_white);
}
	
	var _ammo_start_x = _start_x; 
    var _ammo_start_y = _bar_y + 50; 
    var _ammo_padding = -30; 
    var _ammo_width = sprite_get_width(Sprite_bullet_hud);
    
   for (var _i = 0; _i < Object_player.bullet_current; _i++) {
        var _draw_x = _ammo_start_x + (_i * (_ammo_width + _ammo_padding));
        
        var _ammo_cicle = (current_time + ammo_offset[_i]) % ammo_cycle_speed[_i];
        
        var _ammo_frame = (_ammo_cicle < 600) ? floor(_ammo_cicle / 200) : 0;
         
        draw_sprite(Sprite_bullet_hud, _ammo_frame, _draw_x, _ammo_start_y);
    }
}

var _total_sec = floor(Object_game.survival_time);
var _minutes = _total_sec div 60;
var _seconds = _total_sec mod 60;

var _str_m = (_minutes < 10) ? "0" + string(_minutes) : string(_minutes);
var _str_s = (_seconds < 10) ? "0" + string(_seconds) : string(_seconds);
var _timer_text = _str_m + ":" + _str_s;

var _gui_w = display_get_gui_width();

draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_black);
draw_text((_gui_w / 2) + 2, 22, _timer_text);

draw_set_color(c_white);
draw_text(_gui_w / 2, 20, _timer_text);

draw_set_halign(fa_left);

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

draw_sprite(Sprite_crosshair, 0, _mx, _my);