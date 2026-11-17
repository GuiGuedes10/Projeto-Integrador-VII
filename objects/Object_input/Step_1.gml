input_left = keyboard_check(ord("A"));
input_right = keyboard_check(ord("D"));
input_top = keyboard_check(ord("W"));
input_down = keyboard_check(ord("S"));
input_mb_left = mouse_check_button(mb_left);
input_shift = keyboard_check(vk_shift);
input_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
input_toggle_bot = keyboard_check_pressed(ord("P"));
input_toggle_ai_training = keyboard_check_pressed(vk_f8);

player_walk = (input_left || input_right || input_top || input_down);

input_aim_x = mouse_x;
input_aim_y = mouse_y;
