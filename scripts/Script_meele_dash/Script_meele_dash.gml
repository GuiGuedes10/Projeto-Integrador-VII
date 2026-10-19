
function Script_meele_dash() {
    var _dash_speed = player_speed * 3.5;

    if (!dash_started) {
        dash_cooldown = dash_cooldown_max;

        begin_x = x;
        begin_y = y;

        var _dir = point_direction(x, y, mouse_x, mouse_y);

        dash_target_x = x + lengthdir_x(dash_range, _dir);
        dash_target_y = y + lengthdir_y(dash_range, _dir);

        dash_started = true;
    }

    var _dist = point_distance(begin_x, begin_y, x, y);

    if (_dist >= dash_range) {
        dash_started = false;
        image_xscale = 1;
        image_yscale = 1;
        return;
    }

    var _factor = 0.001;
    var _stretch_dash = 1 + (_dist * _factor);
    var _squash_dash = 1 / _stretch_dash;

    image_xscale = _stretch_dash;
    image_yscale = _squash_dash;

    var _move_dir = point_direction(x, y, dash_target_x, dash_target_y);
    var _remaining = point_distance(x, y, dash_target_x, dash_target_y);
    var _move = min(_dash_speed, _remaining);

    var _hspd = lengthdir_x(_move, _move_dir);
    var _vspd = lengthdir_y(_move, _move_dir);

    var _hit = Script_colison(_hspd, _vspd, Object_collision_square);

    if (_hit) {
        dash_started = false;
        currently_state = state.walk;

        image_xscale = 1;
        image_yscale = 1;
        image_angle = 0;
        return;
    }
}
