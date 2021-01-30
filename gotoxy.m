function gotoxy (s, xy, cam)

sprintf('========================================================')

xy_startfrom = s.getXY

s.setXY(xy)

diff = abs(s.getXY - xy);

% wait until arrived
while max(diff) > 10
    pause(1)
    xx = s.getXY;
    diff = abs(xy-xx)
    ['    approaching ']
    ['      from']
    xx
    ['      to']
    xy
end

% wait until stable
xy_old = [inf inf];
xy_new = xy_startfrom;
while max(abs(xy_new-xy_old)) > 10
    pause(1)
    xy_old = xy_new;
    xy_new = s.getXY;
end

pause(1)

xy_final = s.getXY

xy_target = xy

xy_error = xy - xy_final

%im1 = cam.snap(1);
%im2 = cam.snap(1);

%imshowpair(im1,im2)

%input('wait')

end

