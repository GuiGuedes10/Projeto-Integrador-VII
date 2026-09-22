function Script_attack_ranged() {
    if (attack_cooldown > 0) {
        attack_cooldown--;
    }

    if (attack_cooldown <= 0 && bullet_current > 0) {
        
        var _dir = point_direction(x, y, mouse_x, mouse_y);
        var _proj = instance_create_layer(x, y, "Instances", Object_bullet);
        
        _proj.direction = _dir;
        _proj.image_angle = _dir;
        _proj.speed = Object_bullet.bullet_speed;
        
        attack_cooldown = 15;
        
        bullet_current--; 
        
        if (bullet_current <= 0) {
            is_reloading = true;
            reload_timer = 60; 
        }
    }
}