% WCC 11/13/2020
% Q: scan multiple tiles
% A:

delete('t0*.png')


xy = s.getXY
n_x = 4
n_y = 4

n_width = 844
n_height = 676

f_target_prev = 3000;


mat_v = [];
k = 0;
for j = 1:n_y
    mat_h = [];
    
    
    % decide direciton
    if mod(j,2) == 1
%    if 1 == 1
        rowodd = 1;
        i_start = 1;
        i_end = n_x;
        i_step = 1;
    else
        rowodd = 0;
        i_start = n_x;
        i_end = 1;
        i_step = -1;
    end
    
    for i = i_start:i_step:i_end
        
        xoffset = 10000/0.85*(i-1);
        yoffset = 8000/0.85*(j-1);
        
        location = xy+[xoffset yoffset]
        
        gotoxy(s,location,cam)
        
        tile = cam.snap(1);
        
        % save each file
        fn = sprintf('t%03d_%03d.png',j,i)
        tilergb = repmat(uint8(tile),1,1,3);
        imwrite(tilergb,fn)
        
        if rowodd == 1
            mat_h = [mat_h tile];
        else
            mat_h = [tile mat_h];
        end
        
        
        k = k + 1;
        focus_list{k} = f;
        
    end
    mat_v = [mat_v; mat_h];
    
    figure(13)
    clf
    image(repmat(uint8(mat_v),1,1,3))
    axis image
    axis off
    
end

% save the stitched image
imrgb = repmat(uint8(mat_v),1,1,3);
imwrite(imrgb,'stitched.png')

% show the stitched image
clf
image(imrgb)
axis image
axis off

s.setXY(xy)
