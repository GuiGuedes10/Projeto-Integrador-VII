if (global.game_paused || other.life <= 0 || other.life >= other.max_life) exit;
var _healed = min(max(0, life_points), other.max_life - other.life);
if (_healed <= 0) exit;
other.life += _healed;
other.total_healing_received += _healed;
other.total_potions_collected++;
instance_destroy();
