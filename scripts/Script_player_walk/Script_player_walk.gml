function Script_player_walk(){
    var _move_x = Object_input.input_right - Object_input.input_lef;
    var _move_y = Object_input.input_down - Object_input.input_top;
    
    if (_move_x != 0 || _move_y != 0) {
        var _dir = point_direction(0, 0, _move_x, _move_y);
        
        x += lengthdir_x(player_speed, _dir);
        y += lengthdir_y(player_speed, _dir);
    }
}