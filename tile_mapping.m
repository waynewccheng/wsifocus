function xy = tile_mapping (r,c)
tile_x_step = (10000/0.85);
tile_y_step = (8000/0.85);

    xy_my_marker = ([-1674 -51075]);
    r_my_marker = 12;
    c_my_marker = 5;
    y_step = (r-r_my_marker) * tile_x_step;
    x_step = (c-c_my_marker) * tile_y_step;
    
    x_step = -x_step;
    
    xy = [x_step y_step]

end
