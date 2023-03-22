function [camera,dark] = initEmergent( exposureTime )
    cam = videoinput('gige', 1, 'Mono8');

%% Set manual trigger to avoid filling memory
    cam.FramesPerTrigger = 1;
    cam.TriggerRepeat = 1;
    triggerconfig(cam, 'manual');
    cam_src = getselectedsource(cam);

    start(cam)

 %% Set exposure time
    cam_src.ExposureTime = exposureTime;

    %% Background image
    im_bk = grabHamamatsuFrame(cam,0,100);
    figure    
        imagesc((im_bk))
        axis equal tight
        colormap(hot)
        colorbar()
        
     camera = cam;
     dark = im_bk;
end
