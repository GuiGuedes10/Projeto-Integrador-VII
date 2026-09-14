var _cam_x = Object_player.x - (camera_get_view_width(view_camera[0]) / 2);
var _cam_y = Object_player.y - (camera_get_view_height(view_camera[0]) / 2);

if (shake_duration > 0) {
    shake_duration--;
    
    _cam_x += random_range(-shake_intensity, shake_intensity);
    _cam_y += random_range(-shake_intensity, shake_intensity);
}

camera_set_view_pos(view_camera[0], _cam_x, _cam_y);