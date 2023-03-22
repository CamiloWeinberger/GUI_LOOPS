function [camera,dark] = initEmergent( exposureTime )
    cam = videoinput('gige', 1, 'Mono12');
    src = cam.Source;

    % Set frame rate in frames per second
    src.FrameRate = 50;
    
    % Set exposure time
    src.Exposure = exposureTime;
    
    %% Set manual trigger to avoid filling memory
    %cam.FramesPerTrigger = 1;
    %cam.TriggerRepeat = 1;
    %triggerconfig(cam, 'manual');
    %cam_src = getselectedsource(cam);

    cam.FramesPerTrigger = inf;
    cam.LoggingMode = 'memory';
    src.PacketSize = 9000;

    start(cam)
        
    i=0;
    while cam.FramesAvailable == 0 
            pause(1/50)
            i=i+1;
            if i==50
                disp('Timeout: No frames available in memory')
                break
            end
    end
    
    % Get the frame from internal memory to Matlab workspace
    [data, t]   = getdata(cam, 1);
    im_bk       = data(:,:,end);

    % Stop acquisitioon
    stop(cam)

    % Display image
    figure
    imagesc(im_bk);
    axis equal tight
    colormap(hot)
    colorbar()
        
    dark = im_bk;
    camera = cam;
end
