/// @function Script_get_movement_sprite(move_x, move_y, sprites)
/// @description Retorna o sprite da direcao. Y negativo = cima; Y positivo = baixo.
/// @param sprites Struct com idle, up, down, side, up_diagonal e down_diagonal.
function Script_get_movement_sprite(_move_x, _move_y, _sprites) {
    if (_move_x == 0 && _move_y == 0) return _sprites.idle;
    if (_move_y < 0) {
        return (_move_x == 0) ? _sprites.up : _sprites.up_diagonal;
    }
    if (_move_y > 0) {
        return (_move_x == 0) ? _sprites.down : _sprites.down_diagonal;
    }
    return _sprites.side;
}
