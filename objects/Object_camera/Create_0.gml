// Camera e viewport separados: o zoom nao aumenta a janela alem do monitor.
camera_zoom = 2;
cam_width = 1920 / camera_zoom;
cam_height = 1080 / camera_zoom;
var _render_width = 1280;
var _render_height = 720;

view_enabled = true;
for (var i = 0; i < 8; i++) view_visible[i] = false;
view_visible[0] = true;
view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = _render_width;
view_hport[0] = _render_height;

var _start_x = instance_exists(Object_player) ? Object_player.x - cam_width / 2 : 0;
var _start_y = instance_exists(Object_player) ? Object_player.y - cam_height / 2 : 0;
camera = camera_create_view(_start_x, _start_y, cam_width, cam_height, 0, -1, -1, -1, -1, -1);
view_set_camera(0, camera);

// O motor dimensiona a application_surface a partir do viewport.
var _window_scale = min(1, min(display_get_width() * 0.9 / _render_width, display_get_height() * 0.9 / _render_height));
window_set_size(floor(_render_width * _window_scale), floor(_render_height * _window_scale));
window_center();
display_set_gui_size(_render_width, _render_height);

shake_intensity = 0;
shake_duration = 0;
