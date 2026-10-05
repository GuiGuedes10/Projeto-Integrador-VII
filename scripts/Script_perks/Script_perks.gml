function Script_init_perks() {
    global.perk_list = [
        {
            title: "Pente Expandido",
            description: "+2 Balas na capacidade do pente",
            allowed_characters: ["Ranged"],
            effect: function() {
                Object_player.max_bullet += 2;
                Object_player.bullet_current += 2;
            }
        },
        {
            title: "Injeção de Adrenalina",
            description: "+200 de Vida Máxima",
            allowed_characters: ["all"], 
            effect: function() {
                Object_player.max_life += 200;
                Object_player.life = Object_player.max_life;
            }
        },
        {
            title: "Botas da velocidade",
            description: "Aumente sua velocidade em 10%",
            allowed_characters: ["all"], 
            effect: function() {
                Object_player.player_speed += Object_player.player_speed * 0.1;
            }
        },
        {
            title: "Melhorar munição",
            description: "Aumente seu dano em 10%",
            allowed_characters: ["Ranged"],
            effect: function() {
               global.bullet_damage = global.bullet_damage * 1.1; 
            }
        },
		{
            title: "Reforjar",
            description: "Aumente o tamanho da sua espada (la ele kkj)",
            allowed_characters: ["Meele"],
            effect: function() {
               global.slash_range += global.slash_range * 1.1; 
            }
        }
    ];
}

function Script_get_available_perks() {
    var _filtered_perks = [];
    var _current_char = global.current_character;
    
    for (var i = 0; i < array_length(global.perk_list); i++) {
        var _perk = global.perk_list[i];
        
        if (_perk.allowed_characters == "all" || array_contains(_perk.allowed_characters, _current_char)) {
            array_push(_filtered_perks, _perk);
        }
    }
    
    return _filtered_perks;
}