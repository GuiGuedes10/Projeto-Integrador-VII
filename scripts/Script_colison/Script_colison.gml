
function Script_colison(_hspd, _vspd, _collision_obj) {
    var _collided = false;

    if (place_meeting(x + _hspd, y, _collision_obj)) {
        _collided = true;

        var _step_x = sign(_hspd);

        while (_step_x != 0 && !place_meeting(x + _step_x, y, _collision_obj)) {
            x += _step_x;
        }
    } else {
        x += _hspd;
    }

    if (place_meeting(x, y + _vspd, _collision_obj)) {
        _collided = true;

        var _step_y = sign(_vspd);

        while (_step_y != 0 && !place_meeting(x, y + _step_y, _collision_obj)) {
            y += _step_y;
        }
    } else {
        y += _vspd;
    }

    return _collided;
}
