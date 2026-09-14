function Script_enemy_colision(){ 
	var _other = instance_place(x, y, Object_enemy);

	if (_other != noone) {
	    var _push_dir = point_direction(_other.x, _other.y, x, y);
    
	    if (x == _other.x && y == _other.y) {
	        _push_dir = random(360);
	    }
    
	    var _push_force = 1.2; 
    
	    x += lengthdir_x(_push_force, _push_dir);
	    y += lengthdir_y(_push_force, _push_dir);
	}
}