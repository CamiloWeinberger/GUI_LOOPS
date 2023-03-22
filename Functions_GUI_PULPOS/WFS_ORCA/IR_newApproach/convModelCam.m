classdef convModelCam<handle
    % =====================================================================
    % CONVMODEL is an object describing the convolutive model developped by
    % Olivier FAUVARQUE (2019). It is mainly used to compute optical gains
    % in closed loop operation.
    % ---- Works for any Fourier-Based WFS --------------------------------
    %
    % REQUIRED PARAMETERS:
    % - tel: telescope 
    % - pwfs: Fourier-based wavefront sensor
    % - modalBase: modal base used for closed loop
    %
    % METHODS:.
    % - computeGainsCam: compute Optical Gains due to residual phases thanks
    % to data from focal plane camera
    %
    % Author: Vincent CHAMBOULEYRON - LAM Marseille - 04/2019
    % =====================================================================
    
    properties(Access=public)
        tel;    
        pwfs;
        modalBase;
        modulation;  % modulation
        w;           % Modulation circle
        m;           % WFS Mask
        p;           % Pupil in bigger array for FFT
        psf_calib;   % PSF at the Pyramid focal plane at Calibration
        psf_cam;     % PSF at the Pyramid focal plane
        w_calib;     % Effective Modulation circle at Calibration
        w_cam;       % PSF at the Pyramid focal plane with modulation = Modulation camera
        IR_calib;    % Impulse Response at Calibration
        IR_cam;      % Impulse Response at sensing computed with modulation camera
        S;           % Squared Modal Sensitivity at Calibration
        convBase;    % Auto-Convolution of Modal Basis
        Gcomp_cam;   % Compensatory Optical Gains computed with modulation camera
        Gopt_cam;    % Optical Gains computed with modulation camera
        crop;        % Crop field of fiew inpercentage
    end
    
    methods
        
        %% Constructor
        function convMod = convModelCam(tel,pwfs,modalBase,crop)
            convMod.tel                    = tel;
            convMod.pwfs                   = pwfs;
            convMod.modalBase              = modalBase;
            convMod.modulation             = convMod.pwfs.modulation;
            convMod.crop                   = crop;
            
            
            nPx = convMod.tel.resolution;
            
            % --------------- Padding of the pupil------------------
            convMod.p = padarray(convMod.tel.pupil,[(convMod.pwfs.c-0.5)*nPx ...
                ,(convMod.pwfs.c-0.5)*nPx]);
            % ------------------------------------------------------
            
            
            % ============================================================
            %                 MODULATION CIRCLE AT CALIBRATION
            % ============================================================
            
            rMod = 2*convMod.pwfs.c*convMod.pwfs.modulation;
            ring = zeros(2*convMod.pwfs.c*nPx);
            
            for i=1:2*convMod.pwfs.c*nPx
                for j=1:2*convMod.pwfs.c*nPx
                    if sqrt((i-2*convMod.pwfs.c*nPx/2-1)^2+(j-2*convMod.pwfs.c*nPx/2-1)^2)>=rMod && ...
                            sqrt((i-2*convMod.pwfs.c*nPx/2-1)^2+(j-2*convMod.pwfs.c*nPx/2-1)^2)<rMod+1
                       ring(i,j)=1;
                    end
                end
            end
            convMod.w = ring/(sum(sum(ring)));

            % ============================================================
            %                   MASK
            % ============================================================
            
            convMod.m = fftshift(convMod.pwfs.pyrMask);
            % CROP FOV
%             cropMask = zeros(2*convMod.pwfs.c*nPx,2*convMod.pwfs.c*nPx);
%             cropMask(int32(convMod.pwfs.c*nPx+1-2*convMod.pwfs.c*convMod.crop):int32(convMod.pwfs.c*nPx+1+2*convMod.pwfs.c*convMod.crop), ...
%                 int32(convMod.pwfs.c*nPx+1-2*convMod.pwfs.c*convMod.crop):int32(convMod.pwfs.c*nPx+1+2*convMod.pwfs.c*convMod.crop)) = 1;
%             convMod.m = convMod.m.*cropMask;
            
            % ============================================================
            %                   IMPULSE RESPONSE
            % ============================================================
            
            
            % At calibration ----------------------------------------
            convMod.psf_calib = abs(fftshift(fft2(fftshift(convMod.p)))).^2;
            convMod.w_calib = fftshift(ifft2(fft2(convMod.w).*fft2(convMod.psf_calib)));
            convMod.w_calib = convMod.w_calib/sum(convMod.w_calib(:));
            convMod.IR_calib = impulseResp(convMod.m,convMod.w_calib);
            % ----------------------------------------------------------
                   
            
            % ============================================================
            %                 Auto-convolution of the Modal Base
            % ============================================================
            
            convMod.convBase = zeros(2*convMod.pwfs.c*nPx,2*convMod.pwfs.c*nPx,size(convMod.modalBase,2));
            
            
            % -------- Padding of the modal base  ---------
            convBase_p = zeros(2*convMod.pwfs.c*nPx,2*convMod.pwfs.c*nPx,size(convMod.modalBase,2));
            for i = 1:size(convMod.modalBase,2);
                convBase_p(:,:,i) = padarray(reshape(convMod.modalBase(:,i),nPx,nPx),[(convMod.pwfs.c-0.5)*nPx ...
                ,(convMod.pwfs.c-0.5)*nPx]);
            end  
            % -------------------------------------------------
            
            for i = 1:size(convMod.modalBase,2)
                disp(i)
                conv = fftshift(ifft2(fft2(convBase_p(:,:,i)).*fft2(rot90(convBase_p(:,:,i),2))));
                convMod.convBase(:,:,i) = conv;
            end
            
      
            % ============================================================
            %                 Modal Senstivity of WFS
            % ============================================================
            
            sensing_calib = fftshift(ifft2(fft2(convMod.IR_calib).*fft2(rot90(convMod.IR_calib,2))));
            
            convMod.S = zeros(size(convMod.modalBase,2),1);
            for i = 1:size(convMod.modalBase,2)
                convMod.S(i) = abs(sum(sum(sensing_calib.*convMod.convBase(:,:,i))));
            end
            
            % ============================================================
            %                 Set Optical Gains to Identity
            % ============================================================  
            
            % Residual Phase optical Gains
            convMod.Gcomp_cam = eye(size(convMod.modalBase,2));
            convMod.Gopt_cam = eye(size(convMod.modalBase,2));
            
        end
        
        % ------------------------ METHODS -----------------------------
        
        % ============================================================
        % ============================================================
        %              MODAL GAIN COMPUTATION with IR - PROJECTION
        % ============================================================
        % ============================================================
        
        
        %_____________________________________________________________
        %
        %          with Residual Phases from MODULATION CAMERA
        %_____________________________________________________________
              
        function computeGainsCam(convMod,phiRes)
            
           nPx = convMod.tel.resolution; 
           if size(phiRes,3) == 1
                phiRes = padarray(phiRes,[(convMod.pwfs.c-0.5)*nPx ...
                ,(convMod.pwfs.c-0.5)*nPx]);
                PSF = abs(fftshift(fft2(fftshift(exp(1j*phiRes).*convMod.p)))).^2;
            else
                PSF1 = zeros(2*convMod.pwfs.c*nPx);
                for screen = 1:size(phiRes,3)
                    phiRes1 = padarray(phiRes(:,:,screen),[(convMod.pwfs.c-0.5)*nPx ...
                ,(convMod.pwfs.c-0.5)*nPx]);
                    PSF1 = PSF1 + abs(fftshift(fft2(fftshift(exp(1j*phiRes1).*convMod.p)))).^2;
                end
                PSF = PSF1./size(phiRes,3);
           end

            % Modulation Circle ----------------------------------------
            convMod.psf_cam = PSF;
            convMod.w_cam = fftshift(ifft2(fft2(convMod.w).*fft2(convMod.psf_cam)));
            convMod.w_cam = convMod.w_cam/sum(convMod.w_cam(:));
            convMod.IR_cam = impulseResp(convMod.m,convMod.w_cam);
            % -------------------------------------------------------------
            
            % Scalar Product ----------------------------------------------
            sensing = fftshift(ifft2(fft2(convMod.IR_cam).*fft2(rot90(convMod.IR_calib,2))));
            
            Gains = zeros(size(convMod.modalBase,2),1);
            
            for i = 1:size(convMod.modalBase,2)
                Gains(i) = abs(sum(sum(sensing.*convMod.convBase(:,:,i))));
            end
            Gains = Gains./convMod.S;
            % -------------------------------------------------------------

            %============= Optical Gains =============
            convMod.Gopt_cam = diag(Gains);
            convMod.Gcomp_cam = diag(1./Gains);
           
        end
    end  
end

function [ out ] = impulseResp(mask,weight)
%IMPULSERES Compute impulse function of WFS - Formula 
%from FAUVARQUE et al 2019
    mb = fftshift(fft2(fftshift(mask)));
    wb = fftshift(fft2(fftshift(weight)));
    out = 2*imag(conj(mb).*fftshift(ifft2(fft2(mb).*fft2(wb))));
end