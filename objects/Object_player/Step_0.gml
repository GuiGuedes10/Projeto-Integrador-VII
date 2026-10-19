
if (global.game_paused) exit;

if (dash_cooldown > 0) {
    dash_cooldown--;
}

if (life <= 0) {
    currently_state = state.dead;
}

if (Object_input.player_walk && currently_state != state.dead) {
    currently_state = state.walk;
}

if (Object_input.input_shift && dash_cooldown <= 0 && !dash_started) {
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
