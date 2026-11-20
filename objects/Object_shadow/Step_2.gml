if (!instance_exists(target)) {
    instance_destroy();
    exit;
}
x = (target.bbox_left + target.bbox_right) / 2;
y = target.bbox_bottom - 2;
if (depth != target.depth + 1) depth = target.depth + 1;
