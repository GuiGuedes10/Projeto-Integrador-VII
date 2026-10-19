if (!instance_exists(target)) {
    instance_destroy();
    exit;
}

x = lerp(x, target.x, circle_speed);
y = lerp(y, target.y, circle_speed);