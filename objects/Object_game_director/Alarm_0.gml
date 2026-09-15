if (global.game_paused || !instance_exists(Object_player)) {
    alarm[0] = 1;
    exit;
}

var _current_hp = Object_player.life;
var _hp_percent = _current_hp / Object_player.max_life;
var _state_hp = (_hp_percent > 0.7) ? "HIGH" : ((_hp_percent > 0.3) ? "MED" : "LOW");

var _enemy_count = instance_number(Object_enemy);
var _state_enemies = (_enemy_count >= max_enemies) ? "FULL" : ((_enemy_count > 15) ? "HIGH" : ((_enemy_count > 5) ? "MED" : "LOW"));

var _current_state = "HP_" + _state_hp + "_ENEMIES_" + _state_enemies;

if (!variable_struct_exists(q_table, _current_state)) {
    variable_struct_set(q_table, _current_state, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
}

if (last_state != "") {
    var _reward = 0;
    
    var _damage_dealt = last_player_hp - _current_hp;
    if (_damage_dealt > 0) _reward += _damage_dealt * 1.5; 
    
    if (last_action == 0 && _state_hp != "LOW") _reward -= 8; 
    if (_state_hp == "HIGH" && (last_action == 0 || last_action == 1)) _reward -= 5;
    
    if (Object_player.currently_state == state.dead || _current_hp <= 0) _reward += 150;
    
    var _action_costs = [0, 2, 4, 4, 7, 10]; 
    _reward -= _action_costs[last_action];
    
    if (_enemy_count >= max_enemies && last_action > 0) _reward -= 15; 

    var _old_q = q_table[$ last_state][last_action];
    
    var _max_future_q = q_table[$ _current_state][0];
    for (var i = 1; i < 6; i++) {
        if (q_table[$ _current_state][i] > _max_future_q) _max_future_q = q_table[$ _current_state][i];
    }
    
    q_table[$ last_state][last_action] = _old_q + alpha * (_reward + gamma * _max_future_q - _old_q);
}

var _action_chosen = 0;

if (random(1) < epsilon) {
    _action_chosen = irandom(5); 
} else {
    var _q = q_table[$ _current_state];
    var _best_val = _q[0];
    _action_chosen = 0;
    for (var i = 1; i < 6; i++) {
        if (_q[i] > _best_val) {
            _best_val = _q[i];
            _action_chosen = i;
        }
    }
}

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

last_state = _current_state;
last_action = _action_chosen;
last_player_hp = _current_hp;

alarm[0] = 60 * 3;