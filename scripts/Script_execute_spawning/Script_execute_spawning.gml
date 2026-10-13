function Script_execute_spawning(action_chosen){
	var _action_chosen = argument[0];
	var _enemy_count = instance_number(Object_enemy);

	var _spawn_amount = 0;
	var _enemy_hp = 50;
	var _enemy_spd = 1.5;
	var _enemy_dmg = 10;
	var _formation = "CERCO";

	switch (_action_chosen) {
	    case 0: 
	        _spawn_amount = 0; 
	        break;
	    case 1: 
	        _spawn_amount = irandom_range(15, 30);
	        _enemy_hp = 50;  
	        _enemy_spd = 2.0;
	        _enemy_dmg = 10;
	        _formation = "CERCO";
	        break;
	    case 2: 
	        _spawn_amount = irandom_range(5, 10);
	        _enemy_hp = 150;  
	        _enemy_spd = 0.8; 
	        _enemy_dmg = 25;
	        _formation = "FRENTE";
	        break;
	    case 3: 
	        _spawn_amount = irandom_range(8, 12);
	        _enemy_hp = 40;
	        _enemy_spd = 3.0; 
	        _enemy_dmg = 60;
	        _formation = "MISTO"; 
	        break;
	    case 4: 
	        _spawn_amount = irandom_range(15, 20);
	        _enemy_hp = 80;
	        _enemy_spd = 1.2;
	        _enemy_dmg = 15;
	        _formation = "FRENTE";
	        break;
	    case 5: 
	        _spawn_amount = max_enemies;
	        _enemy_hp = 60;
	        _enemy_spd = 1.6;
	        _enemy_dmg = 10;
	        _formation = "CERCO";
	        break;
	}

	if (_enemy_count + _spawn_amount > max_enemies) {
	    _spawn_amount = max(0, max_enemies - _enemy_count);
	}

	var _base_direction = random(360); 
	var _cam_x = camera_get_view_x(view_camera[0]);
	var _cam_y = camera_get_view_y(view_camera[0]);
	var _cam_w = 960;
	var _cam_h = 540;
	var _margin = 80;

	repeat (_spawn_amount) {
	    var _spawn_x = 0;
	    var _spawn_y = 0;
    
	    if (_formation == "CERCO") {
	        var _side = choose("LEFT", "RIGHT", "TOP", "BOTTOM");
	        switch (_side) {
	            case "LEFT":
	                _spawn_x = _cam_x - _margin;
	                _spawn_y = random_range(_cam_y - _margin, _cam_y + _cam_h + _margin);
	                break;
	            case "RIGHT":
	                _spawn_x = _cam_x + _cam_w + _margin;
	                _spawn_y = random_range(_cam_y - _margin, _cam_y + _cam_h + _margin);
	                break;
	            case "TOP":
	                _spawn_x = random_range(_cam_x - _margin, _cam_x + _cam_w + _margin);
	                _spawn_y = _cam_y - _margin;
	                break;
	            case "BOTTOM":
	                _spawn_x = random_range(_cam_x - _margin, _cam_x + _cam_w + _margin);
	                _spawn_y = _cam_y + _cam_h + _margin;
	                break;
	        }
	    } 
	    else if (_formation == "FRENTE" || _formation == "MISTO") {
	        var _dir = (_formation == "FRENTE") ? (_base_direction + random_range(-30, 30)) : random(360);
	        var _dist = random_range(600, 850); 
	        _spawn_x = Object_player.x + lengthdir_x(_dist, _dir);
	        _spawn_y = Object_player.y + lengthdir_y(_dist, _dir);
	    }
    
	    _spawn_x = clamp(_spawn_x, 64, room_width - 64);
	    _spawn_y = clamp(_spawn_y, 64, room_height - 64);
    
	    var _inst = instance_create_layer(_spawn_x, _spawn_y, "Instances", Object_enemy);
	    _inst.life_max = _enemy_hp;
	    _inst.life = _enemy_hp;
	    _inst.move_speed = _enemy_spd;
	    _inst.damage = _enemy_dmg;
	}
}