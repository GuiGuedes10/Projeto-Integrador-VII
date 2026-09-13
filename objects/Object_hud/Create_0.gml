randomize();
heart_offset = irandom(5000); 
heart_cycle_speed = irandom_range(3000, 5000);

for (var _i = 0; _i < 20; _i++) {
    ammo_offset[_i] = irandom(5000);
    ammo_cycle_speed[_i] = irandom_range(2000, 5000);
}