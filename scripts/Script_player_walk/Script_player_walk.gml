function Script_player_walk(){
    var _move_x = player_input.input_right - player_input.input_left;
    var _move_y = player_input.input_down - player_input.input_top;
    
    if (_move_x != 0 || _move_y != 0) {
        var _dir = point_direction(0, 0, _move_x, _move_y);
        
        var _hspd = lengthdir_x(player_speed, _dir);
        var _vspd = lengthdir_y(player_speed, _dir);
        
        Script_colison(_hspd, _vspd, Object_collision_square);
    }
}