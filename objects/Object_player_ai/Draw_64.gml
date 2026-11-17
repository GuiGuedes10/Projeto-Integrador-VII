if (global.bot_mode != "DESLIGADO") exit;
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(20, display_get_gui_height() - 28, "P: ligar bot | F8: " + (global.player_ai_training ? "TREINAMENTO" : "AVALIACAO"));
