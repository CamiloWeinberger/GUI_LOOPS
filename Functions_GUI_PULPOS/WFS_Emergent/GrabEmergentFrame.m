function frame = GrabEmergentFrame(cam)

    start(cam)

    i=0;
    pause(2)
    while cam.FramesAvailable == 0 
        disp('entering the while loop')
        pause(1/50)
        i = i+1;
        
        if i==50
            disp('Timeout: No frames available in memory')
            stop(cam)
            break
        end
    end
    fprintf('i=%f\n',i)
    
    if cam.FramesAvailable ~= 0
        disp('getting frame')
        % Get the frame from internal memory to Matlab workspace
        [data, t]   = getdata(cam, 1);
        frame       = data(:,:,end);
        % Stop acquisitioon
        stop(cam)
    end
    stop(cam)

end