% =============================================
%   SCRIPT simulating new IR
% ==============================================

%clear all
close all
clc
wfsModel = 'diff';

%% ---------- ATMOSPHERE ----------
r0 = 0.2;
atm = atmosphere(photometry.V,r0,30,...
    'altitude',[0],...
    'fractionnalR0',[1],...
    'windSpeed',[10],...
    'windDirection',[0]);

%% Definition of the telescope
nPx = 50;
tel = telescope(4,...
    'fieldOfViewInArcMin',2,...
    'resolution',nPx,...
    'samplingTime',1/200);

%% KL Base
nModes = 400;
% --- KL Base ---
modeout = KL_basis(tel,atm,nModes);
modes = modeout.KL_pure;

%% Definition of the deformable mirror
% ----- Modal ------------
dm = deformableMirror(nModes,...
    'modes',modes,...
    'resolution',nPx,...
    'validActuator',logical(1:nModes));
    
%% Definition of a calibration source
ngs = source('wavelength',photometry.V);

%% Definition of the wavefront sensor
nLenslet = nPx;
d = tel.D/nLenslet;
modu =3;
wfs = pyramid(nLenslet,nPx,'c',2,'modulation',modu);
% ----- NOISE --------------
ngs.magnitude = 0;
intensityFrame = 1; % Choose between Full Frame or Slopes Map
ngs = ngs.*tel*wfs;
wfs.INIT
+wfs;

%% ------ E2E OG ------
%% RESIDUAL PHASE ------ 
nTurbu = 1;
r0 = 0.15;
atm = atmosphere(photometry.V,r0,30,...
    'altitude',[0],...
    'fractionnalR0',[1],...
    'windSpeed',[10],...
    'windDirection',[0]);
[map,Cphi] = psdScreen(tel,atm,0,nTurbu);

% ---------- CALIB Diff -------
dmCalib = calibration(dm,wfs,ngs,ngs.wavelength/40,intensityFrame);
dmCalib.nThresholded = 0;
commandMatrix = dmCalib.M;
intMat = dmCalib.D;
% ---------- CALIB resphase -------
resPhase = {tel.pupil;map(:,:,1)};
ngs = ngs.*resPhase;
dmCalib= calibration(dm,wfs,ngs,ngs.wavelength/40,intensityFrame);
dmCalib.nThresholded = 0;
intMat_res = dmCalib.D;

% PLOT
OG = sum(intMat_res.*intMat,1)./sum(intMat.^2,1);
figure(100);plot(OG);hold on

% S = sqrt(sum(intMat.^2,1));
% figure;
% plot(S);
%% CONVOLUTIVE MODEL

model = convModelCam(tel,wfs,modes,24);
model.computeGainsCam(map(:,:,1));
%%
figure;imagesc(model.w_cam);
figure;imagesc(angle(model.m))
figure(100);plot(diag(model.Gopt_cam))


% ==================================================
                                                NEW APPROACH
==================================================

% ---------- MODULATION ------------------------
rMod = 4*wfs.modulation;
ring = zeros(4*nPx);

for i=1:4*nPx
    for j=1:4*nPx
        if sqrt((i-4*nPx/2-1)^2+(j-4*nPx/2-1)^2)>=rMod && ...
                sqrt((i-4*nPx/2-1)^2+(j-4*nPx/2-1)^2)<rMod+1
            ring(i,j)=1;
        end
    end
end
w = ring/(sum(sum(ring)));
figure;imagesc(w)
% ----------------------------------

%% Built tip-tilt Matrix for each point in modulation camera
FoV = 10;
tip_tilt = buildTT(nPx,2,FoV);

%% TEST ------
phiTT = padarray(tip_tilt(:,:,3241),[3*nPx/2,3*nPx/2]);
PUP =  padarray(tel.pupil,[3*nPx/2,3*nPx/2]);
PSF = abs(fftshift(fft2(fftshift(exp(1j*phiTT).*PUP)))).^2;
figure;imagesc(PSF)
%% -------------------------
% Definition of the wavefront sensor
nLenslet = nPx;
d = tel.D/nLenslet;
modu = 0;
wfs = pyramid(nLenslet,nPx,'c',2,'modulation',modu);
% ----- NOISE --------------
ngs.magnitude = 0;
intensityFrame = 1; % Choose between Full Frame or Slopes Map
ngs = ngs.*tel*wfs;
wfs.INIT
+wfs;
%% BUILDING IR_TT

pseudoDirac = zeros(nPx,nPx);
amp = 0.3;
pseudoDirac(nPx/2+1,nPx/2+1) = amp;


IR_TT = zeros((4*nPx)^2,(4*nPx)^2);

for r=1:(4*nPx)^2
    disp(r)
    TT = {tel.pupil;tip_tilt(:,:,r)};
    % PUSH
    ngs = ngs.*TT;
    ngs.phase = pseudoDirac;
    ngs = ngs*wfs;
    sp = wfs.intensityFrame;

    % PULL
    ngs = ngs.*TT;
    ngs.phase = -pseudoDirac;
    ngs = ngs*wfs;
    sm = wfs.intensityFrame;

    IR_residu = (sp-sm)/(2*amp);
    IR_TT(:,r) = IR_residu;
    
end

%
figure;imagesc(reshape(IR_TT(:,3242),4*nPx,4*nPx));


%% TEST modulation
w_res = model.w_cam;
IR_mod = IR_TT*w(:);
IR_mod = reshape(IR_mod,4*nPx,4*nPx);
% Modal Convolution
S = zeros(nModes,1);
for i=1:nModes
    m = reshape(modes(:,i),nPx,nPx);
    m = padarray(m,[3*nPx/2,3*nPx/2]);
    mI_modes = fftshift(ifft2(fft2(IR_mod).*fft2(m)));
    S(i) = sqrt(sum(mI_modes(:).^2));
end
figure;
plot(S)

%% TEST OG --------
w_res = model.w_cam;
w = model.w_calib;

IR_mod = IR_TT*w(:);
IR_mod = reshape(IR_mod,4*nPx,4*nPx);

IR_mod_res = IR_TT*w_res(:);
IR_mod_res = reshape(IR_mod_res,4*nPx,4*nPx);

% Modal Convolution
OGnew = zeros(nModes,1);
for i=1:nModes
    m = reshape(modes(:,i),nPx,nPx);
    m = padarray(m,[3*nPx/2,3*nPx/2]);
    mI_modes = fftshift(ifft2(fft2(IR_mod).*fft2(m)));
    mI_modes_res = fftshift(ifft2(fft2(IR_mod_res).*fft2(m)));
    OGnew(i) = sum(mI_modes_res(:).*mI_modes(:))./sum(mI_modes(:).*mI_modes(:));
end
figure(100);
plot(OGnew)