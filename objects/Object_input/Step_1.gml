input_lef = keyboard_check(ord("A"))
input_right = keyboard_check(ord("D"))
input_top = keyboard_check(ord("W"))
input_down = keyboard_check(ord("S"))
input_mb_left = mouse_check_button(mb_left)

player_walk = (input_lef || input_right || input_top || input_down);