function [ IR_TT ] = calib_IR_TT(wfs,slm_pupil,tip_tilt,center,amp,widePx)
%Build IR_TT - Gain scheduling Camera Interaction Matrix
    nPx = size(tip_tilt,1);
    % Pesudo-Dirac with given amplitude
    pseudoDirac = zeros(nPx,nPx);
    pseudoDirac(nPx/2-widePx:nPx/2+1+widePx,nPx/2-widePx:nPx/2+1+widePx) = amp;%size = widePx
    IR_TT = zeros((wfs.resolution)^2,size(tip_tilt,3));
    figure;imagesc(pseudoDirac);
    for r=1:size(tip_tilt,3)
        disp(r)
        % PUSH
        phase = zeros(1024,1280);
        radius = (nPx)/2;
        phase(center(1)-radius:center(1)+radius-1,...
            center(2)-radius:center(2)+radius-1) =...
            pseudoDirac+tip_tilt(:,:,r);
        slm_pupil.phasemap = phase;
        pause(0.1)
        +wfs;
        sp = wfs.intensityFrame;
        % PULL
        phase = zeros(1024,1280);
        radius = (nPx)/2;
        phase(center(1)-radius:center(1)+radius-1,...
            center(2)-radius:center(2)+radius-1) =...
            -pseudoDirac+tip_tilt(:,:,r);
        slm_pupil.phasemap = phase;
        pause(0.1)
        +wfs;
        sm = wfs.intensityFrame;
        
        figure(100)
        imagesc(wfs.camera.frame);
        
        IR_residu = (sp-sm)/(2*amp);
        IR_TT(:,r) = IR_residu;

    end

end

