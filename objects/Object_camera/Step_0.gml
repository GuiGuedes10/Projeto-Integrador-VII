if (instance_exists(Object_player)) {
    var _target_x = Object_player.x - (cam_width / 2);
    var _target_y = Object_player.y - (cam_height / 2);
    
    var _current_x = camera_get_view_x(camera);
    var _current_y = camera_get_view_y(camera);
    
    var _smooth_x = lerp(_current_x, _target_x, 0.1);
    var _smooth_y = lerp(_current_y, _target_y, 0.1);
    
    camera_set_view_pos(camera, _smooth_x, _smooth_y);
}