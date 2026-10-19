function Script_attack_ranged() {
    if (attack_cooldown > 0) {
        attack_cooldown--;
    }

    if (attack_cooldown <= 0 && bullet_current > 0) {
		
		if(currently_weapon == mage_weapon.normal){
	        var _dir = point_direction(x, y, mouse_x, mouse_y);
	        var _proj = instance_create_layer(x, y, "Instances", Object_bullet);
        
	        _proj.direction = _dir;
	        _proj.image_angle = _dir;
	        _proj.speed = Object_bullet.bullet_speed;
        
	        attack_cooldown = Object_player_ranged._cooldown;
        
	        bullet_current--; 		
		}
		
		
        if(currently_weapon == mage_weapon.thunder){
		    var _dir = point_direction(x, y, mouse_x, mouse_y);
	        var _proj = instance_create_layer(x, y, "Instances", Object_bullet_thunder);
        
	        _proj.direction = _dir;
	        _proj.image_angle = _dir;
	        _proj.speed = Object_bullet_thunder.bullet_speed;
        
	        attack_cooldown = Object_player_ranged._cooldown;
        
	        bullet_current--; 
		}
		
		if(currently_weapon == mage_weapon.ice){
		    var _dir = point_direction(x, y, mouse_x, mouse_y);
	        var _proj = instance_create_layer(x, y, "Instances", Object_bullet_ice);
        
	        _proj.direction = _dir;
	        _proj.image_angle = _dir;
	        _proj.speed = Object_bullet_ice.bullet_speed;
        
	        attack_cooldown = Object_player_ranged._cooldown;
        
	        bullet_current--; 
		}

        
        if (bullet_current <= 0) {
            is_reloading = true;
            reload_timer = 60; 
        }
    }
}