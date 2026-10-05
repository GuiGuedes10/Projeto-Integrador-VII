var _x_inicial = 500;
var _y_inicial = 500;

if (global.current_character == "Meele") {
    instance_create_layer(_x_inicial, _y_inicial, "Instances", Object_player_meele);
} 
else if (global.current_character == "Ranged") {
    instance_create_layer(_x_inicial, _y_inicial, "Instances", Object_player_ranged);
}