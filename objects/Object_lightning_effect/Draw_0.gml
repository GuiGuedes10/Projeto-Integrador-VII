draw_set_color(c_aqua); 
draw_set_alpha(alpha);

var _dist = point_distance(x1, y1, x2, y2);
var _dir = point_direction(x1, y1, x2, y2);
var _segments = max(2, floor(_dist / 20)); 
var _px = x1;
var _py = y1;

for (var i = 1; i < _segments; i++) {
    var _t = i / _segments;
    var _target_x = lerp(x1, x2, _t);
    var _target_y = lerp(y1, y2, _t);
    
    var _offset = irandom_range(-10, 10);
    var _nx = _target_x + lengthdir_x(_offset, _dir + 90);
    var _ny = _target_y + lengthdir_y(_offset, _dir + 90);
    
    draw_line_width(_px, _py, _nx, _ny, 2); 
    
    _px = _nx;
    _py = _ny;
}

draw_line_width(_px, _py, x2, y2, 2);

draw_set_alpha(1);
draw_set_color(c_white);