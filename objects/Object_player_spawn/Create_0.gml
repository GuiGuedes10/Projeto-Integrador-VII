var _x_inicial = 1237;
var _y_inicial = 1163;

if (global.current_character == "Meele") {
    instance_create_layer(_x_inicial, _y_inicial, "Instances", Object_player_meele);
} 
else if (global.current_character == "Ranged") {
    instance_create_layer(_x_inicial, _y_inicial, "Instances", Object_player_ranged);
}

instance_create_layer(0, 0, "Instances", Object_hud_controller);
instance_create_layer(0, 0, "Instances", Object_hud);
