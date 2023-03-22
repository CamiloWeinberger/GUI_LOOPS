%% ================================================
%  FULL FRAME
%
%% Plot the current frame with the pupils outlined
%setMirror(dm,V0)
N = 450;%ORCA
%% Initiate OOMAO Pyramid Full Frame object
c = 1;
nPx = 2*c*N;
% The size of the pupil on the DM is around 5mm.
D = 5e-3;
% We define a telescope object with the given aperture and resolution.
tel = telescope(D,'fieldOfViewInArcMin',2.5,'resolution',nPx,'samplingTime',1/250);
% We use an R-band (lambda = 640nm) source to most closely match our
% laboratory laser (lambda = 635nm)
ngs = source('wavelength',photometry.V);
%dm.Send(V0)
% Number of averaging frames
nFrames = 5;
% Initiate Pyramid object
wfs = pyramid(N,nPx,'modulation',0,'c',c,'binning',1);
% Pointer to function which grabs OCAM2 frame and extracts pupils
wfs.camera.frameGrabber = @()getPupilImagesORCA(cam,0*im_dark,nFrames);%with ORCA
% The source is propagateed to the WFS through the telescope.
ngs = ngs.*tel*wfs;
% We initiate the sensor to get the reference slopes (our zero point)
wfs.INIT;
+wfs;
figure;imagesc(reshape(wfs.referenceIntensityFrame,nPx,nPx))