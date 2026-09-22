function Script_attack_meele() {
    if (attack_cooldown > 0) {
        attack_cooldown--;
    }

    if (attack_cooldown <= 0 && mouse_check_button_pressed(mb_left)) {
        var _dir = point_direction(x, y, mouse_x, mouse_y);
        
        var _dist = 24; 
        
        var _spawn_x = x + lengthdir_x(_dist, _dir);
        var _spawn_y = y + lengthdir_y(_dist, _dir);
        
        var _slash = instance_create_layer(_spawn_x, _spawn_y, "Instances", Object_slash);
        
        _slash.owner = id;
        _slash.dist_offset = _dist;
        _slash.direction = _dir;
        _slash.image_angle = _dir;
        _slash.image_xscale = -1;
        
        attack_cooldown = 15; 
    }
}