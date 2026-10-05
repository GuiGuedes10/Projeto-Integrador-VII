function Script_colison(_hspd, _vspd, _collision_obj) {
    if (place_meeting(x + _hspd, y, _collision_obj)) {
        while (!place_meeting(x + sign(_hspd), y, _collision_obj)) {
            x += sign(_hspd);
        }
        _hspd = 0;
    }
    x += _hspd;

    if (place_meeting(x, y + _vspd, _collision_obj)) {
        while (!place_meeting(x, y + sign(_vspd), _collision_obj)) {
            y += sign(_vspd);
        }
        _vspd = 0;
    }
    y += _vspd;
}