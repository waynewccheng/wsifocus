% WCC 11/12/2020
% Q: how to scan the whole slide for Radboud U Camelyon
% A: need to do auto-focus first

classdef FocusClass < handle
    
    properties
        data_z_cs = zeros(1,2);
%        f_target = 2500;
        f_step = 200;
        f_opt
        k_opt
        cs_opt
        xy
        imdata
        tile_w = 8000;
        tile_h = 6400;
    end
    
    methods
        
        function obj = FocusClass (s, cam, f_target)
            %             im = cam.snap(1);
            %             imagesc(im)
            %             s.getXY
            %             s.getZ
            
           
            % delete png files
            delete('0*.png')
            
            % sequential search
            obj.cs_opt = 0;
            obj.f_opt = -1;
            contrast = -1;
            
            % decide the direction by taking 2 points
            s.setZ(f_target);
            im1 = cam.snap(1);
            cs1 = mycontrast(im1);
            
            s.setZ(f_target + obj.f_step * 5);
            im2 = cam.snap(1);
            cs2 = mycontrast(im2);
            
            if cs1 < cs2
                
                the_step = obj.f_step;
                the_start = f_target;
                
                f = the_start;
            else
                the_step = -obj.f_step;
                the_start = f_target;
                
                f = the_start + obj.f_step;
                
            end
            
            % loop for finding the maximum
            k = 1;
            while k < 20
                % set focus
                s.setZ(f);
                
                % acquire the image
                im = cam.snap(1);
                
                % show the image
                figure(11)
                clf
                im_rgb = repmat(uint8(im),1,1,3);
                image(im_rgb)
                axis image
                axis off
                
                % save the image
                saveas(gcf,sprintf('%03d.png',k))
                
                
                % record the focus and contrast
                focus = s.getZ;
                contrast_prev = contrast;
                contrast = mycontrast(im);
                obj.data_z_cs(k,:) = [focus contrast];
                
                % compare with the maximum
                if contrast > obj.cs_opt
                    obj.f_opt = focus;
                    obj.cs_opt = contrast;
                    obj.k_opt = k;
                    obj.imdata = im;
                end
                
                % show curve
                obj.show_curve;
                drawnow
                
                % update
                sprintf('Iteration %d, Z value = %d, Contrast = %.2f',k,focus,contrast)
                
                % stop if not improving
                if contrast < contrast_prev & (contrast_prev-contrast)/contrast_prev > 0.05
                    break
                end
                
                % next iteration
                k = k + 1;
                f = f + the_step;
            end
            
            % show final plot
            obj.show_curve;
            plot(obj.data_z_cs(obj.k_opt,1),obj.data_z_cs(obj.k_opt,2),'xr')
            saveas(gcf,sprintf('%03d.png',000));
            
            % set the optimal focus
            s.setZ(obj.f_opt)
            
            % where the tile is
            % do it last due to the delay of the stage
            obj.xy = s.getXY;
            
        end
        
        function show_curve (obj)
            figure(12)
            clf
            hold on
            plot(obj.data_z_cs(:,1),obj.data_z_cs(:,2),'o-')
            xlabel('Z value')
            ylabel('Contrast value')
            axis([2000 8000 0 15])
        end
        
    end
    
    
    
end

