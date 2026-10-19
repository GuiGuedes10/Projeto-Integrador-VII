function Script_enemy_freeze() {
    if (variable_instance_exists(id, "freeze_timer")) {
        freeze_timer--;
    }

    if (!variable_instance_exists(id, "ice_box") || !instance_exists(ice_box)) {
        ice_box = instance_create_layer(x, y, "Instances", Object_enemy_ice);
        ice_box.creator = id;
    }

    if (freeze_timer <= 0) {
        if (variable_instance_exists(id, "ice_box") && instance_exists(ice_box)) {
            instance_destroy(ice_box);
        }
        
        currently_state = enemy_state.walk;
    }
}