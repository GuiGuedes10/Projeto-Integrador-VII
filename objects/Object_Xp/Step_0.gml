if(global.game_paused == true) return;

if (instance_exists(Object_player)) {
    
    var _distancia = point_distance(x, y, Object_player.x, Object_player.y);
    
    if (_distancia <= _range) {
       Script_xp_walk();
    }
}