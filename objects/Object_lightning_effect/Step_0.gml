timer--;
alpha = timer / duration; 

if (timer <= 0) {
    instance_destroy();
}