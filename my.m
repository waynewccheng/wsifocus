im = cam.snap(1);
imagesc(im)
s.getXY
s.getZ

    cs_old = 0;
    f_opt = -1;
    f_target = 2500;
    
    data_z_cs = zeros(1,2);

    k = 1;
    for f = f_target-2000:700:f_target+2000
        s.setZ(f);
        focus = s.getZ
        im = cam.snap(1);
        imagesc(im)
        saveas(gcf,sprintf('%03d.png',k))
        
        contrast = mycontrast(im)
        
        data_z_cs(k,:) = [focus contrast];
        k = k + 1;
    end
    
    plot(data_z_cs(:,1),data_z_cs(:,2),'o-')
  
    return
  
    for f = f_target-2000:200:f_target+2000
        s.setZ(f);
        im = cam.snap(1);
        cs = mycontrast(im);
        
        [f cs]
        k = k + 1;
        data(1,k) = f;
        data(2,k) = cs;
        
        if cs > cs_old
            f_opt = f;
            cs_old = cs;
        end
    end    