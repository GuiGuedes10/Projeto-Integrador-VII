if (!variable_instance_exists(id, "target")) target = noone;
if (!instance_exists(target) || target == id) {
    instance_destroy();
    exit;
}
if (!variable_instance_exists(id, "shadow_alpha")) shadow_alpha = 0.6;
if (!variable_instance_exists(id, "shadow_length")) shadow_length = 0.9;
if (!variable_instance_exists(id, "shadow_width")) shadow_width = 1;
if (!variable_instance_exists(id, "shadow_angle")) shadow_angle = 45;

x = (target.bbox_left + target.bbox_right) / 2;
y = target.bbox_bottom;
depth = target.depth + 1;
