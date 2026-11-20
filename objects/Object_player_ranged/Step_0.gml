event_inherited();
if (global.game_paused || currently_state == state.dead) exit;

// Usa os mesmos comandos para teclado/mouse e para o bot.
var _move_x = player_input.input_right - player_input.input_left;
var _move_y = player_input.input_down - player_input.input_top;
var _movement_sprite = Script_get_movement_sprite(_move_x, _move_y, movement_sprites);
if (sprite_index != _movement_sprite) {
    sprite_index = _movement_sprite;
    image_index = 0;
}
// Os sprites laterais existentes olham para a direita.
if (_move_x != 0) image_xscale = abs(image_xscale) * sign(_move_x);


if (is_reloading) {
        reload_timer--;
        
        if (reload_timer <= 0) {
            bullet_current = max_bullet;
            is_reloading = false;
        }
    
}


if (player_input.input_mb_left && currently_state != state.dead && !is_reloading) Script_attack_ranged();
