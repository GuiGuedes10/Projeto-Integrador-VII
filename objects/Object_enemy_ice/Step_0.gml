if (instance_exists(creator)) {
    x = creator.x;
    y = creator.y;
    image_xscale = creator.image_xscale;
    image_yscale = creator.image_yscale;
    depth = creator.depth - 100;
} else {
    instance_destroy();
}