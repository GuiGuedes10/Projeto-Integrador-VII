if (global.game_paused || !instance_exists(Object_player_ranged)) exit;
var _speed = sprite_get_speed(Sprite_bullet_hud);
if (sprite_get_speed_type(Sprite_bullet_hud) == spritespeed_framespersecond) {
    _speed /= game_get_speed(gamespeed_fps);
}
ammo_animation_frame = (ammo_animation_frame + _speed) mod sprite_get_number(Sprite_bullet_hud);
