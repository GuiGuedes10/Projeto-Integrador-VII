cam_width = 960;
cam_height = 540;

view_enabled = true;
view_visible[0] = true;

var _start_x = instance_exists(Object_player) ? Object_player.x - (cam_width / 2) : 0;
var _start_y = instance_exists(Object_player) ? Object_player.y - (cam_height / 2) : 0;

camera = camera_create_view(_start_x, _start_y, cam_width, cam_height, 0, -1, -1, -1, -1, -1);
view_set_camera(0, camera);

window_set_size(cam_width * 1.5, cam_height * 1.5);
surface_resize(application_surface, cam_width * 1.5, cam_height * 1.5);