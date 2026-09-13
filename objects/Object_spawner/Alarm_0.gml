var _spawn_x = irandom_range(100, room_width - 100);
var _spawn_y = irandom_range(100, room_height - 100);

instance_create_layer(_spawn_x, _spawn_y, "Instances", Object_enemy);

alarm[0] = irandom_range(90, 180);