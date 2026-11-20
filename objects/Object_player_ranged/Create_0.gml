event_inherited()

enum mage_weapon{
normal,
thunder,
ice
}

currently_weapon = mage_weapon.normal

global.bullet_damage = 50;

max_bullet = 6
bullet_current = max_bullet;
is_reloading = false;
reload_timer = 0;
// A mesma funcao pode receber outros conjuntos de sprites no futuro.
movement_sprites = {
    idle: Sprite_ragend_idle,
    up: Sprite_ragend_walk_up,
    down: Sprite_ragend_walk_down,
    side: Sprite_ragend_walk_to_the_side,
    up_diagonal: Sprite_ragend_walk_up_transverse,
    down_diagonal: Sprite_ragend_walk_transverse
};
// Mantem a colisao original ao trocar quadros e animacoes.
mask_index = Sprite_ragend_idle;
image_speed = 1;
