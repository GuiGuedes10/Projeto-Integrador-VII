if (global.game_paused) return;

if (!instance_exists(target)) {
    instance_destroy();
    exit;
}

if (_cooldown > 0) {
    _cooldown--;
}

_orbit_angle += _orbit_speed;

x = target.x + lengthdir_x(_orbit_radius, _orbit_angle);
y = target.y + lengthdir_y(_orbit_radius, _orbit_angle);

if (_cooldown <= 0) {
    var _enemy = instance_nearest(x, y, Object_enemy);

    if (_enemy != noone) {
        var _dist = point_distance(x, y, _enemy.x, _enemy.y);

        if (_dist <= _range) {
            Script_fairy_attack(_enemy.x, _enemy.y);
            _cooldown = _attack_cooldown;
        }
    }
}