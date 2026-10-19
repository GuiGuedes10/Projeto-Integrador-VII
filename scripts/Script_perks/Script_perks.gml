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
            description: "+100 de Vida Máxima",
            allowed_characters: ["all"], 
            effect: function() {
                Object_player.max_life += 100;
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
        },
		{
		    title: "Pequena companheira",
		    description: "Invoque uma pequena companheira de batalha que ajudara matar os monstros",
		    allowed_characters: ["Ranged"],
		    condition: function() {
		        return !instance_exists(Object_fairy);
		    },
		    effect: function() {
		        var _player = instance_find(Object_player, 0);

		        if (_player != noone) {
		            var _fairy = instance_create_layer(
		                _player.x,
		                _player.y,
		                "Instances",
		                Object_fairy
		            );
					global.fairy_exist = true;
		            _fairy.target = _player.id;
		        }
		    }
		},
		{
		    title: "melhorar companheira",
		    description: "Aumente o dano da sua pequena companheira de batalha",
		    allowed_characters: ["Ranged"],
		    condition: function() {
		        return instance_exists(Object_fairy);
		    },
		    effect: function() {
		        var _fairy = instance_find(Object_fairy, 0);
		        if (_fairy != noone) {
		            _fairy._damage += _fairy._damage * 0.5;
		        }
		    }
		},
		{
			title: "O poder da tempestade",
			description: "Altere o tipo de magia lançada por um raio que atinge outros inimigos",
			allowed_characters: ["Ranged"],
			condition: function() {
		        return Object_player_ranged.currently_weapon == mage_weapon.normal && Object_player.level >= 5;
		    },
			effect: function(){
				Object_player_ranged.currently_weapon = mage_weapon.thunder
			}
		},
		{
			title: "O poder do gelo",
			description: "Altere o tipo de magia lançada pora um raio de gelo que congela os inimigos",
			allowed_characters: ["Ranged"],
			condition: function() {
		        return Object_player_ranged.currently_weapon == mage_weapon.normal;
		    },
			effect: function(){
				Object_player_ranged.currently_weapon = mage_weapon.ice;
			}
		}
    ];
}