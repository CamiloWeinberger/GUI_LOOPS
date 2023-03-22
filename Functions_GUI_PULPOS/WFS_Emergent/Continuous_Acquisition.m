addpath WFS_EMERGENT\

close all, clear all
[cam, dark] = initEmergent(10000);

%%
src.Exposure = 100000;
im = GrabEmergentFrame(cam);
[imC, x, y] = CropFrame(im, 150);
%src.Exposure = 3000;

%%
clear im
for i=1:10
    im = GrabEmergentFrame(cam);
    pause(0.75)
    figure(1)
    imagesc(SubFrame(im, 110, x, y)); axis image
    colorbar
    drawnow
end