// Registra dano real e a passagem de vivo para morto uma unica vez.
function Script_enemy_take_damage(_enemy, _damage) {
    if (global.game_paused || !instance_exists(_enemy) || _enemy.life <= 0 || _damage <= 0) return 0;

    var _actual_damage = min(_enemy.life, _damage);
    _enemy.life -= _damage;

    var _player = instance_find(Object_player, 0);
    if (_player != noone && _player.life > 0) {
        _player.total_damage_dealt += _actual_damage;
        if (_enemy.life <= 0) _player.total_kills++;
    }
    return _actual_damage;
}
