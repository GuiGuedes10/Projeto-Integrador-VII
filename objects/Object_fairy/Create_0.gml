target = noone;

var _colors = [
    c_red,
    c_aqua,
    c_lime,
    c_yellow,
    c_fuchsia,
    c_orange,
    c_purple,
    c_white
];

image_blend = _colors[irandom(array_length(_colors) - 1)];

_damage = 20
_speed = 0.30
_range = 200

_attack_cooldown = 60;
_cooldown = 0

_player_dist = 24

_orbit_angle = 0;
_orbit_radius = 40;
_orbit_speed = 3;