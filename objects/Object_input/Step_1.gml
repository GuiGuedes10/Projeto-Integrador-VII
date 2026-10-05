if (!variable_global_exists("bot_mode")) {
    global.bot_mode = "DESLIGADO"; 
}

if (global.bot_mode == "DESLIGADO") {
    input_left = keyboard_check(ord("A"));
    input_right = keyboard_check(ord("D"));
    input_top = keyboard_check(ord("W"));
    input_down = keyboard_check(ord("S"));
    input_mb_left = mouse_check_button(mb_left);
    input_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
} 
else {
    input_left = 0; input_right = 0; input_top = 0; input_down = 0;
    input_mb_left = false; input_confirm = false;
    
    if (instance_exists(Object_player)) {
        var _enemy = instance_nearest(Object_player.x, Object_player.y, Object_enemy);
        
        if (_enemy != noone) {
            var _dist = point_distance(Object_player.x, Object_player.y, _enemy.x, _enemy.y);
            var _dir_to_enemy = point_direction(Object_player.x, Object_player.y, _enemy.x, _enemy.y);
            var _move_dir = -1;
            
            var _is_melee = (Object_player.object_index == Object_player_meele);
            
            if (_is_melee) {
                var _attack_range = 60;
                
                if (_dist > _attack_range + 10) {
                    _move_dir = _dir_to_enemy; 
                } else if (_dist < _attack_range - 10) {
                    _move_dir = _dir_to_enemy + 180; 
                }
            } 
            else {
                var _safe_distance = 250;
                
                if (_dist < _safe_distance) {
                    _move_dir = _dir_to_enemy + 180; 
                }
            }
            
            if (_move_dir != -1) {
                var _lx = lengthdir_x(1, _move_dir);
                var _ly = lengthdir_y(1, _move_dir);
                
                input_right = (_lx > 0.3);
                input_left  = (_lx < -0.3);
                input_down  = (_ly > 0.3);
                input_top   = (_ly < -0.3);
            }
            
            input_mb_left = true; 
            window_mouse_set(window_get_x() + window_get_width()/2 + lengthdir_x(100, _dir_to_enemy), 
            window_get_y() + window_get_height()/2 + lengthdir_y(100, _dir_to_enemy));
        }
    }
}

player_walk = (input_left || input_right || input_top || input_down);