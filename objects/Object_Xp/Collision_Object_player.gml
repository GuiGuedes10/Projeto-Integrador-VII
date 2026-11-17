if (global.game_paused || other.life <= 0) exit;
other.xp += xp_valor;
other.total_xp_collected += xp_valor;
other.total_xp_pickups++;
instance_destroy();
