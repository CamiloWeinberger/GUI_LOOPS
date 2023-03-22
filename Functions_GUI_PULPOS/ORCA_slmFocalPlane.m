function [slm] = ORCA_slmFocalPlane( faces,angle)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    slm = SLM([1024, 1280]);
    slm.driver = @(bitmap,id) fullscreen(bitmap, id);
    slm.driver_display = 3; %3
    load('SLM_flatmap_660.mat')
    % Apply the phase screen on the SLM
    center = [515.5 640.5];%[x from left / y from top]
    orientation = pi/2;
    alternative=0;
    slm.pyramid(faces, angle, center, orientation,alternative);
    % Zelda Mask ----------------------------
    %slm.Zelda(center,faces*7.5,pi/2);
    % ------------
    closescreen
    slm.flatmap=double(flatmap)*2*pi/255;
    [TIP,TILT]=meshgrid(1:1280,1:1024);
    slm.tipmap=-.5*pi*(TIP+TILT);
%     slm.tipmap=.25*pi*(TIP+TILT);
    % plot result
    figure(10);
    imagesc(slm.phasemap)
    axis square tight;
end

