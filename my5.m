% WCC 1/29/2021
% WCC 11/13/2020
% Q: scan multiple tiles
% A:

% mapping between stage and pixel
tile_x_step = (10000/0.85);
tile_y_step = (8000/0.85);
tile_x_pixel = 844;
tile_y_pixel = 676;


TileClass.clean


xy_my_marker = ([-1674 -51075]);

xy_my_marker = ([-124026 -133429] + [0 tile_y_step]);

n_x = 10
n_y = 8

f_target_prev = 5000;

% prepare tile locations
tile_xy = zeros(n_y,n_x,2);

% use xy_my_marker as the center, find the starting tile
xy_start = xy_my_marker - [tile_x_step*n_x/2 tile_y_step*n_y/2];

for j = 1:n_y
    for i = 1:n_x
        xoffset = tile_x_step*(i-1);
        yoffset = tile_y_step*(j-1);
        
        tile_xy(j,i,:) = xy_start + [xoffset yoffset];
    end
end



for j = 1:n_y
    
    % decide direciton
        if mod(j,2) == 1
    %if 1
        i_start = 1;
        i_end = n_x;
        i_step = 1;
    else
        i_start = n_x;
        i_end = 1;
        i_step = -1;
    end
    
    for i = i_start:i_step:i_end
        
        location = squeeze(tile_xy(j,i,1:2))
        s.setXY(location);
        
        %focusit
        
        pause(3)
        
        %f = FocusClass(s,cam,f_target_prev);
        
        %tile = f.imdata;
        tile = cam.snap(1);
        
        %f_target_prev = f.f_opt;
        
        % save each file
        tilergb = repmat(uint8(tile),1,1,3);
        TileClass.save(j,i,tilergb)
        
    end
    
end

imrgb = TileClass.reconstruct(n_y,n_x);
figure(13)
clf
image(imrgb)
axis image
axis off

% save the stitched image
imwrite(imrgb,'stitched.png')

return

% show the stitched image
clf
image(imrgb)
axis image
axis off

% go back to the previous location
s.setXY(xy);
