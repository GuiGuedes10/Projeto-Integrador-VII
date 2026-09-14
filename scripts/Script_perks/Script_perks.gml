function Script_init_perks() {
    global.perk_list = [
        {
            title: "Pente Expandido",
            description: "+2 Balas na capacidade do pente",
            effect: function() {
                Object_player.max_bullet += 2;
                Object_player.bullet_current += 2;
            }
        },
        {
            title: "Injeção de Adrenalina",
            description: "+200 de Vida Máxima",
            effect: function() {
                Object_player.max_life += 200;
                Object_player.life += Object_player.max_life; 
            }
        },
        {
            title: "Botas da velocidade",
            description: "Aumente sua velocidade em 10%",
            effect: function() {
                Object_player.player_speed += Object_player.player_speed * 0.1;
            }
        },
		{
            title: "Melhorar munição",
            description: "Aumente seu dano em 10%",
            effect: function() {
               global.bullet_damage = global.bullet_damage * 0.1;
            }
        }
    ];
}