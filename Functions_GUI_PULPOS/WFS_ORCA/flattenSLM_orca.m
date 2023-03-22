
%% WFS SLOPESMAP TO FLATTEN DM AND SLM 
% Plot the current frame with the pupils outlined
%% +++++++++++ INIT WaveFront Sensor +++++++++++
close all
N = 254;
x0 = [263 265 684 691]-24;
y0 = [238 658 237 660]-3;
x = x0-floor(N/2);
y = y0-floor(N/2);
posx = 160;
posy = 125;
sqare = 900;
frame = grabHamamatsuFrame(cam,im_dark,10);
frame = frame(posy:posy+sqare,posx:posx+sqare);
figure(123456)
plotFrameWithPupils(frame,x,y,N)
%% Mask Maker
Mask=zeros(901);
for i=1:901
    for j=1:901
        if sum((i-x0).^2+(j-y0).^2 < (N/2)^2)>=1
            Mask(j,i)=1;
        end
    end
end
nMaskPix=sum(sum(Mask));
figure; imagesc(Mask);

%% Initiating OOMAO objects : telescope and source
c = 1;
nPx = 2*c*N;
% The size of the pupil on the DM is around 5mm.
D = 5e-3;
% We define a telescope object with the given aperture and resolution.
tel = telescope(D,'fieldOfViewInArcMin',2.5,'resolution',nPx,...
    'samplingTime',1/250);
% We use an R-band (lambda = 640nm) source to most closely match our 
% laboratory laser (lambda = 635nm)
ngs = source('wavelength',photometry.R);
% Initiate OOMAO Pyramid object
%dm.Send(V0)
% Number of averaging frames
nFrames = 10;
% Pupil centre coordinates
z = x+1i*y;
% Initiate Pyramid object
wfs = pyramid(N,nPx,'modulation',0,'c',c);%,'binning',4,'nFaces',faces);
% Pointer to function which grabs OCAM2 frame and extracts pupils
wfs.camera.frameGrabber = @()getPupilImagesSlopesORCA(cam,0*im_dark,nFrames,x,y,N);
% The source is propagateed to the WFS through the telescope.
ngs = ngs.*tel*wfs;
% We initiate the sensor to get the reference slopes (our zero point)
% (If you want no reference comment out)
wfs.INIT;
+wfs;
% Force units to be 1 (set in Pyramid object)
% Reference image if using full detector
frameRef = 0;
% Uncomment to calculate V0 on the pyramid
wfs.referenceSlopesMap = wfs.referenceSlopesMap*0;
% Reference slopes
figure
    imagesc(wfs.referenceSlopesMap)
    title('Reference slopes maps X Y, normalised')
    axis equal tight
    colorbar
% The  camera image and slope signals are displayed. 
figure
    subplot(2,1,1)
    imagesc(wfs.camera)
    subplot(2,1,2)
    slopesDisplay(wfs)
    title('Actual Slopes maps X Y, reference subctracted, normalised')



%% Pupil Plane SLM
slm_pupil.turbmap = 0;
radiusSLM = 136;%159 D = 7 mm;
centerSLM = [283,641];%[305,610];
%%
nPixSLM = 2*radiusSLM;
%%
atmSLM = atmosphere(photometry.V,30,30,...
    'altitude',[0],...
    'fractionnalR0',[1],...
    'windSpeed',[10],...
    'windDirection',[0],...
    'randStream', RandStream('mt19937ar','Seed',0));
telSLM = telescope(8,'fieldOfViewInArcmin',2,'resolution',nPixSLM,'samplingTime',1/200);
telSLM = telSLM + atmSLM;
ngsSLM = source;
ngsSLM = ngsSLM.*telSLM;
+telSLM;
ngsSLM = ngsSLM.*telSLM;
%% SLM_pupil Interaction Matrix
modesNumberSLM = 250;
modesType = 'KL';
%Calibration amplitude in rad
ampCalibrationSLM = 0.1;

if strcmp(modesType,'zernike')
    modesSLM=zernike(2:modesNumberSLM+1,8,'resolution',nPixSLM);
    modesNumberSLMReduced = modesNumberSLM;
elseif strcmp(modesType,'fourier')
    modesSLM=fourierModes(modesNumberSLM,nPixSLM);
    modesNumberSLM = modesNumberSLM^2;
    modesNumberSLMReduced = sqrt(modesNumberSLM);
elseif strcmp(modesType,'KL')
    modesSLM=zernike(1:modesNumberSLM,8,'resolution',nPixSLM);
    modesNumberSLMReduced = modesNumberSLM;
    kl=KL_basis(telSLM,atmSLM,modesNumberSLM);
    modesSLM.modes=kl.KL_pure;
end

dmSLM = deformableMirror(modesNumberSLMReduced,'modes',...
    modesSLM,'resolution',nPixSLM);
dmSLM.driver = @(x) setMirrorSLM(slm_pupil, x, modesSLM, nPixSLM,...
    centerSLM);

%% Calibration 
slm_pupil.turbmap = 0;
ampCalibrationSLM = 0.3;
nAv = 1;
intMat = calibrateSLMStyle(wfs,dmSLM,tel,ampCalibrationSLM,...
    zeros(modesNumberSLM,1),1,0,nAv);
dmSLM.coefs = 0;
CM = pinv(intMat);

%% too slow
dispOn = true;
dmSLM.coefs = zeros(modesNumberSLM,1);
gain = 0.3;
dmCalibSLM.nThresholded = 0;

%% Close the loop
nIter = 4;
% Loopwhile
for n=1:nIter
    time = tic;
    inner = tic;
    +wfs;
    Vdm = CM*wfs.slopes;
    dmSLM.coefs = dmSLM.coefs - gain*Vdm;
    %dmSLM.coefs(50:end) = 0;
    if dispOn
        
        subplot(2,2,1)
        imagesc(wfs.camera.frame)
        colormap(hot)
        axis equal tight
        axis off;
        title('Pyramid image [ADU]')
        colorbar
        drawnow;
        
        subplot(2,2,2)
        imagesc(dmSLM)
        axis equal tight;
        axis off;
        title('DM commands [nm]')
        h = colorbar();
        drawnow;
        
        subplot(2,2,3)
        imagesc(wfs.validSlopes.*wfs.slopesMap)
        axis equal tight
        axis off;
        title('Pyramid signals')
        colorbar()
        set(gca,'CLim',[-0.2 0.2])
        drawnow;
        
        subplot(2,2,4)
        imagesc(slm_pupil.bitmap)
        axis equal tight
        axis off;
        title('SLM bitmap')
        colorbar()
        set(gca,'CLim',[0 255])
        drawnow;
        
    end

    
end

%% Save 
flat_slm = slm_pupil.phasemap+flat_slm;
%%
save('SLM_pupil_flatBench.mat','flat_slm')