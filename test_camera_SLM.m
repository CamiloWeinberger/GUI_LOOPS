addpath C:\Users\Charlotte\Documents\MATLAB\Pyramid\runningTheBench
addpath C:\Users\Charlotte\Documents\MATLAB\Pyramid\runningTheBench\functionFiles\
addpath C:\Users\Charlotte\Documents\MATLAB\Pyramid\runningTheBench\WFS_ORCA\
addpath(['C:\Users\Charlotte\Documents\MATLAB\Pyramid\OOMAO\' +...
    'external_functions\']);
% focal plane SLM

faces = 4;
angle = -1.25*pi/8;
% angle = 0;
slm = ORCA_slmFocalPlane(faces,angle);

%%

addpath(genpath('Functions_GUI_PULPOS'))
wvg = WaveGen;
wfs = WFSensors(1);

%%
wfs.Exposure = 10;
wfs.rec = 1;
idx = 2;
tic
x = 0;y=0;
while 1
    y(idx) = wfs.vid.FramesAvailable;
    x(idx) = toc;
    dif(idx) = (y(idx)-y(idx-1))./(x(idx)-x(idx-1));
    if idx <=100
        plot(x(1:idx),y(1:idx)./x(1:idx));
    xlim([x(1) x(idx)+0.00001])
    elseif idx>100
        plot(x(idx-100:idx),y(idx-100:idx)./x(idx-100:idx));
        xlim([x(idx-100) x(idx)])
    end
    ylim([0 200])
    title(num2str(idx))
    drawnow
    idx = idx + 1;
end
%%
wfs.rec = 0;

%%
if wfs.vid.FramesAvailable>0
data = getdata(wfs.vid,wfs.vid.FramesAvailable);
end
maxom = max(data(:));
for idx = 1:size(data,4)
    imagesc(imresize(data(:,:,:,idx),[200 200]),[0 maxom])
    title(num2str(idx))
    drawnow;
end

%%

%%
wfs.rec = 0;
wfs.Exposure = 10;
wfs.rec = 1;
while 1
    cqnt = wfs.vid.FramesAcquired
    if cqnt >= wfs.vid.FramesPerTrigger-10
        wfs.rec = 0;
        wfs.rec = 1;
    end
    data = wfs.frame; 
    pause(wfs.Exposure/1000)
    imagesc(imresize(data,[200 200]),[0 2^16]);axis image;
    drawnow;
end



