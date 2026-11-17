if (!variable_global_exists("bot_mode")) exit;
if (global.bot_mode == "DESLIGADO") exit; 

var _box_w = 420; 
var _box_h = 355; 
var _margin = 20; 

var _gui_w = display_get_gui_width();

var _x1 = _gui_w - _box_w - _margin;
var _y1 = _margin;
var _x2 = _gui_w - _margin;
var _y2 = _margin + _box_h;

draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(_x1, _y1, _x2, _y2, false);

draw_set_alpha(1.0);
draw_set_color(c_white);

var _text_x = _x1 + 15;
var _text_y = _y1 + 12;
var _spacing = 19;

draw_set_color(c_yellow);
draw_text(_text_x, _text_y, "=== TELEMETRIA DO SISTEMA  ===");
_text_y += _spacing + 3;

draw_set_color(c_white);

draw_text(_text_x, _text_y, "[ PLAYER ] - Q-learning com rede neural");
_text_y += _spacing;

var _training = global.player_ai_training;
draw_text(_text_x, _text_y, "  > Modo: " + (_training ? "TREINAMENTO" : "AVALIACAO") + " [F8]");
_text_y += _spacing;
var _eps_nn = _training ? global.ai_epsilon : 0.0;
draw_text(_text_x, _text_y, "  > Epsilon: " + string_format(_eps_nn, 1, 4));
_text_y += _spacing;

var _action_curr = variable_global_exists("ai_current_action") ? global.ai_current_action : 0;
draw_text(_text_x, _text_y, "  > Action: " + string(_action_curr));
_text_y += _spacing + 5;

draw_text(_text_x, _text_y, "[ SPAWNER ] - Diretor de Inimigos");
_text_y += _spacing;

var _director = variable_global_exists("ia_director") ? global.ia_director : "PADRÃO";
draw_text(_text_x, _text_y, "  > Método Ativo: " + string(_director));
_text_y += _spacing;

if (_director == "Q_TABLE") {
    var _states_count = 0;
    if (variable_global_exists("ai_q_table") && is_struct(global.ai_q_table)) {
        _states_count = array_length(variable_struct_get_names(global.ai_q_table));
    }
    draw_text(_text_x, _text_y, "  > Q-Table action: " + string(_states_count));
    _text_y += _spacing;
    
    var _frames_surv = variable_global_exists("frames_survived") ? global.frames_survived : 0;
    draw_text(_text_x, _text_y, "  > Frames Survived: " + string(_frames_surv));
    _text_y += _spacing;
    
    var _eps_qt  = variable_global_exists("epsilon") ? global.epsilon : 0.2;
    var _alpha   = variable_global_exists("alpha") ? global.alpha : 0.1;
    var _gamma   = variable_global_exists("gamma") ? global.gamma : 0.9;
    var _max_en  = variable_global_exists("max_enemies") ? global.max_enemies : 30;
    
    draw_text(_text_x, _text_y, "  > Epsilon (Spawner): " + string(_eps_qt));
    _text_y += _spacing;
    draw_text(_text_x, _text_y, "  > Alpha: " + string(_alpha) + " | Gamma: " + string(_gamma));
    _text_y += _spacing;
    draw_text(_text_x, _text_y, "  > Max Enemies: " + string(_max_en));
    _text_y += _spacing;
} else {
    draw_text(_text_x, _text_y, "  > (Método alternativo / Heurístico)");
    _text_y += _spacing;
}

draw_set_alpha(1.0);