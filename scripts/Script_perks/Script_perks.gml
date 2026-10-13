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
            description: "Aumente o tamanho da espada (la ele kkj)",
            allowed_characters: ["Meele"],
            condition: function() {
                return global.slash_range < Object_player_meele.slash_range_max; 
            },
            effect: function() {
                global.slash_range += global.slash_range * 0.1;
                
                if (global.slash_range > Object_player_meele.slash_range_max) {
                    global.slash_range = Object_player_meele.slash_range_max;
                }
            }
        }
    ];
}