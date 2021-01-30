% WCC 11/13/2020
% Q: scan multiple tiles
% A:

delete('t0*.png')

xy = s.getXY;

n_x = 3
n_y = 3

f_target_prev = 3000;

focus_list = {};

mat_v = [];
k = 0;
for j = 1:n_y
    mat_h = [];
    
    % decide direciton
%    if mod(j,2) == 1
    if 1
        i_start = 1;
        i_end = n_x;
        i_step = 1;
    else
        i_start = n_x;
        i_end = 1;
        i_step = -1;
    end
    
    for i = i_start:i_step:i_end
        
        xoffset = uint16(10000/0.85*(i-1));
        yoffset = uint16(8000/0.85*(j-1));
        
        location = xy+[xoffset yoffset]
        s.setXY(location);
        
        f = FocusClass(s,cam,f_target_prev);
        
        tile = f.imdata;
        f_target_prev = f.f_opt;
        
        % save each file
        fn = sprintf('t%03d_%03d.png',j,i)
        tilergb = repmat(uint8(tile),1,1,3);
        imwrite(tilergb,fn)
        
        mat_h = [mat_h tile];
        
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

% go back to the previous location
% s.setXY(xy);

%
figure(14)
clf
hold
for i = 1:k
    fi = focus_list{i};
    fcurve = fi.data_z_cs;
    plot(fcurve(:,1),fcurve(:,2),'o-')
    xlabel('Z value')
    ylabel('Contrast value')
end


figure(15)
clf
hold
for i = 1:k
    fi = focus_list{i};
    fi.f_opt
    fi.xy
    plot3(fi.xy(1),fi.xy(2),fi.f_opt,'o')
end
