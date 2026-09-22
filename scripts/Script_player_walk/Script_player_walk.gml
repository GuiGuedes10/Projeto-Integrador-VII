function Script_player_walk(){
    var _move_x = Object_input.input_right - Object_input.input_left;
    var _move_y = Object_input.input_down - Object_input.input_top;
    
    if (_move_x != 0 || _move_y != 0) {
        var _dir = point_direction(0, 0, _move_x, _move_y);
        
        var _hspd = lengthdir_x(player_speed, _dir);
        var _vspd = lengthdir_y(player_speed, _dir);
        
        if (place_meeting(x + _hspd, y, Object_collision_square)) {
            while (!place_meeting(x + sign(_hspd), y, Object_collision_square)) {
                x += sign(_hspd);
            }
            _hspd = 0; 
        }
        x += _hspd; 
        
        if (place_meeting(x, y + _vspd, Object_collision_square)) {
            while (!place_meeting(x, y + sign(_vspd), Object_collision_square)) {
                y += sign(_vspd);
            }
            _vspd = 0;
        }
        y += _vspd; 
    }
}