n_x = 4
n_y = 4

margin = 23;

mat_v = [];
for j = 1:n_y
    mat_h = [];
    for i = 1:n_x
        fn = sprintf('t%03d_%03d.png',j,i)
        tile_original = imread(fn);
        tile = tile_original(margin+1:size(tile_original,1)-margin,margin+1:size(tile_original,2)-margin);
        mat_h = [mat_h tile];
    end
    mat_v = [mat_v; mat_h];
end

imrgb = repmat(uint8(mat_v),1,1,3);
image(imrgb)
imwrite(imrgb,'stitch.png')