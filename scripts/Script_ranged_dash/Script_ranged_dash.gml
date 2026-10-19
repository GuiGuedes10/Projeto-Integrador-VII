function Script_ranged_dash() {
    if (dash_started) return;

    dash_cooldown = 15;
    dash_started = true;

    var _dir = point_direction(x, y, mouse_x, mouse_y);
    var _distance = dash_range;
    var _steps = ceil(dash_range);

    for (var i = 1; i <= _steps; i++) {
        var _check_dist = dash_range * (i / _steps);
        var _check_x = x + lengthdir_x(_check_dist, _dir);
        var _check_y = y + lengthdir_y(_check_dist, _dir);

        if (place_meeting(_check_x, _check_y, Object_collision_square)) {
            _distance = max(0, _check_dist - 1);
            break;
        }
    }

    x += lengthdir_x(_distance, _dir);
    y += lengthdir_y(_distance, _dir);

    dash_started = false;
}