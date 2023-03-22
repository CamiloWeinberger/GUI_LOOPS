% Create the SLM object
resol       = [2160, 3840];
% resol       = [1080, 1920];
slm         = SLM_wavelength2(resol);
slm.driver  = @(bitmap,id) fullscreenPupil(bitmap, id);
slm.driver_display = 2;

% TTangle     = 3; % TipTilt angle in degrees
TTangle     = 4; % 4 TipTilt angle in degrees

% alpha       = 88.8;
% alpha       = 89.35;
% alpha       = 30;
alpha       = 89.4;




[Pyr] =  Mod_pyr_SLM(resol,0,1,alpha,TTangle);% no modulation

slm.phaseFactor = 256;
% slm.phasemap = Prism;
slm.bitmap = Pyr;


%%
clc
Pyr_frames =  Mod_pyr_SLM(resol,40,4,alpha,TTangle);% modulation (RESOL SLM, Radio Px, Frames)
% Pyr_frames = Pyr_frames;
%
idx = 1;
while 1
    %tic
    slm.bitmap = Pyr_frames(:,:,idx);
    idx = idx+1;
    if idx == size(Pyr_frames,3)+1;
        idx = 1;
    end
    %pause(1/60)
    %toc
%  display(idx)
end     %modulacion

% imagesc(slm.bitmap);colorbar;axis image


%% PRCONDITIONER
clc
load('OL1_R128_M0_RMSE0.054.mat');OL1 = fftshift(OL1);
% figure(10);imagesc(OL1);axis image; colorbar
[Pyr] =  Mod_pyr_SLM_preconditioner(resol,0,1,alpha,TTangle,1*OL1);% no modulation

slm.phaseFactor = 256;
% slm.phasemap = Prism;
slm.bitmap = Pyr;
display('done')

Pyr_frames = Mod_pyr_SLM_preconditioner(resol,40,4,alpha,TTangle,1*OL1);% modulation (RESOL SLM, Radio Px, Frames)

