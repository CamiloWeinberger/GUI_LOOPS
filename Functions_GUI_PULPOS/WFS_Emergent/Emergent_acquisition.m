% -------------------- Acquisition EMRGENT camera  ---------------------- %

% Requirements:
% - Camera must be switched on
% - Camera must be recognized by Matlab. Try app ImageAcquisition from
% matlab.
% - Emergent acquisition program must be closed.

%% First part: Setting of the camera

% Define camera object
v = videoinput('gige', 1, 'Mono12');
s = v.Source;

% Set frame rate in frames per second
s.FrameRate = 50;

% Set a continuous acquisition (inifinite number of frames per trigger signal)
v.FramesPerTrigger = inf;
v.LoggingMode = 'memory';
s.PacketSize = 9000;

% 
% s.TriggerMode = 'On';

%% Second part: Start acquisition

% Start aquisition. 
start(v)

% At this point images are saved in an internal memory of the camera at the frame rate defined above.
% What needs to be done now is to retrieve these images (or some of them)
% from the camera memory to Matlab.

%% Third part: retrieve image.

% Ask continuously if there are frame available in memory.
% The loop remain cycling until the number of frames is different from
% zero.
while v.FramesAvailable == 0 
    
    pause(1/30)
end

% Display the number of frames in memory
v.FramesAvailable

% Get the frame from internal memory to Matlab workspace
[data1, t]= getdata(v,v.FramesAvailable);
data1 = data1(:,:,end);

% Stop acquisitioon
stop(v)

% Display image
imagesc(data1);drawnow
plot(t)