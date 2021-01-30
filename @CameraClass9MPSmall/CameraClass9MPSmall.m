classdef CameraClass9MPSmall
    properties
        vid
        src
        n_width = 844
        n_height = 676
    end
    
    methods
        %%
        function obj = CameraClass9MPSmall
            
            % open the device
            %            obj.vid = videoinput('pointgrey', 1, 'Mono16_640x480');
            %            obj.vid = videoinput('pointgrey', 1, 'F7_Raw16_3376x2704_Mode7');
            obj.vid = videoinput('pointgrey', 1, 'F7_Mono8_844x676_Mode5');
            
            obj.src = getselectedsource(obj.vid);
            
            %load('lightsetting','src')
            %obj.src = src;
            
            % fix the camera settings
            obj.src.ExposureMode = 'Manual';
            obj.src.FrameRatePercentageMode = 'Manual';
            obj.src.GainMode = 'Manual';
            obj.src.ShutterMode = 'Manual';
            obj.src.SharpnessMode = 'Manual';
            
            % grap the camera settings
            % load('cameravstruth.mat','myBrightness','myExposure','myShutter','myGain')
            myBrightness = 0;
            myExposure = 1.65;
            myShutter = 0.68;
            myGain = 0;
            
            %% set the exposure time
            % for skin setup
            obj.src.Brightness = myBrightness;
            obj.src.Exposure = myExposure;
            obj.src.Shutter = myShutter;
            obj.src.Gain = myGain;
            obj.src.Gamma = 1;
            obj.src.FrameRatePercentage = 100;
            obj.src.Sharpness = 1532;
            
            % open preview window
            preview(obj.vid);
        end
        
        %%
        function close (obj)
            
            % close the device
            closepreview;
            delete(obj.vid);
            
        end
        
        %%
        function vim = snap(obj, nround)
            
            % initialize the sum matrix
            imsum = zeros(obj.n_height,obj.n_width,'double');
            
            for r = 1:nround
                imtemp = getsnapshot(obj.vid);
                imsum = imsum + double(imtemp);
            end
            
            % mean of all frame
            vim = imsum / (nround);
            
        end
        
        %% added 11/16/2020
        function vim = show(obj)
            
            im = obj.snap(1);
            
            clf
            imrgb = repmat(uint8(im),1,1,3);
            image(imrgb);
            axis image
            axis off
            
        end
        
    end
end
