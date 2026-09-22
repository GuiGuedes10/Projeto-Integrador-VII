if (global.game_paused) exit;


if (instance_exists(owner)) {
    x = owner.x + lengthdir_x(dist_offset, image_angle);
    y = owner.y + lengthdir_y(dist_offset, image_angle);
}
