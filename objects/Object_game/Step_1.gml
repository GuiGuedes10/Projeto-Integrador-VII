if (!global.game_paused && instance_exists(Object_player)) {
    if (Object_player.currently_state != state.dead) {
        survival_time += 1 / game_get_speed(gamespeed_fps);
    }
}