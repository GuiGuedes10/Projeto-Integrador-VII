if (!instance_exists(target) || !target.visible) exit;
var _sprite = target.sprite_index;
if (_sprite == -1) exit;

// Consulta o sprite e o quadro atuais para acompanhar inclusive trocas de animacao.
var _anchor_x = (sprite_get_bbox_left(_sprite) + sprite_get_bbox_right(_sprite)) / 2;
var _anchor_y = (target.image_yscale >= 0) ? sprite_get_bbox_bottom(_sprite) : sprite_get_bbox_top(_sprite);
var _scale_x = target.image_xscale * shadow_width;
// Inverte a altura para que a silhueta se estenda dos pes para baixo.
var _scale_y = -target.image_yscale * shadow_length;
var _offset_x = (sprite_get_xoffset(_sprite) - _anchor_x) * _scale_x;
var _offset_y = (sprite_get_yoffset(_sprite) - _anchor_y) * _scale_y;
var _foot_x = (target.bbox_left + target.bbox_right) / 2;
var _foot_y = target.bbox_bottom;
var _draw_x = _foot_x + lengthdir_x(_offset_x, shadow_angle) + lengthdir_x(_offset_y, shadow_angle - 90);
var _draw_y = _foot_y + lengthdir_y(_offset_x, shadow_angle) + lengthdir_y(_offset_y, shadow_angle - 90);

draw_sprite_ext(_sprite, target.image_index, _draw_x, _draw_y,
    _scale_x, _scale_y, shadow_angle, c_black,
    clamp(shadow_alpha * target.image_alpha, 0, 1));
