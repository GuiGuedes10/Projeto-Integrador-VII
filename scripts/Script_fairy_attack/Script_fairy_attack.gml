function Script_fairy_attack(_target_x, _target_y) {
    var _bullet = instance_create_layer(
        x,
        y,
        "Instances",
        Object_bullet_fairy
    );

    var _dir = point_direction(x, y, _target_x, _target_y);

    _bullet.direction = _dir;
    _bullet.speed = Object_bullet_fairy.bullet_speed;
}