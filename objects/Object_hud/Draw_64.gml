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

    var _heart_width = sprite_get_width(Sprite_life_hud);
    var _bar_x = _start_x + _heart_width - 40; 
    var _bar_y = _start_y; 
    
    var _max_bar_width = 200; 
    var _bar_height = 16;     
    
    var _life_percent = clamp(Object_player.life / Object_player.max_life, 0, 1);
    var _current_bar_width = _max_bar_width * _life_percent;

    draw_set_color(c_maroon);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _max_bar_width, _bar_y + _bar_height, false);

    draw_set_color(c_red);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _current_bar_width, _bar_y + _bar_height, false);

    draw_set_color(c_black);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _max_bar_width, _bar_y + _bar_height, true);

    draw_set_color(c_white);
	
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