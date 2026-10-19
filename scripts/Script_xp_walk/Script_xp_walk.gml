function Script_xp_walk() {
    if (!instance_exists(Object_player)) return;

    var _target_x = Object_player.x;
    var _target_y = Object_player.y;
    
    var _dist = point_distance(x, y, _target_x, _target_y);
    var _dir = point_direction(x, y, _target_x, _target_y);
    
    x += lengthdir_x(_speed, _dir);
    y += lengthdir_y(_speed, _dir);

}