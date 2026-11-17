// A IA e o teclado/mouse fornecem a mesma interface de comandos.
player_input = (global.bot_mode == "DESLIGADO") ? Object_input : Object_player_ai;

if (global.game_paused) exit;
if (life <= 0) {
    currently_state = state.dead;
    Script_death();
    exit;
}
if (player_input == Object_input) {
    aim_direction = point_direction(x, y, player_input.input_aim_x, player_input.input_aim_y);
    dash_direction = aim_direction;
} else {
    aim_direction = player_input.input_aim_direction;
    dash_direction = player_input.input_dash_direction;
}

if (dash_cooldown > 0) {
    dash_cooldown--;
}


if (player_input.player_walk && currently_state != state.dead) {
    currently_state = state.walk;
}

if (player_input.input_shift && dash_cooldown <= 0 && !dash_started) {
    if (global.current_character == "Meele") {
        Script_meele_dash();
    } else {
        Script_ranged_dash();
    }
}

switch (currently_state) {
    case state.walk:
        Script_player_walk();
        break;

    case state.dead:
        Script_death();
        break;
}

if (dash_started) {
    if (global.current_character == "Meele") {
        Script_meele_dash();
    } else {
        Script_ranged_dash();
    }
}

Script_knockback();
Script_level_up();
