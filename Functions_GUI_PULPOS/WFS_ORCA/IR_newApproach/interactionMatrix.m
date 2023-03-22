function [ iMat ] = interactionMatrix(ngs,tel,wfs,modalBasis,signal,refPhase)
% Compute intereaction matrix
% - signal: slopes or full frame
% - refPhase: reference phase around which to build the interaction matrix
    
    amplitude = 0.001;
    

    referencePhase = repmat(refPhase,1,1,size(modalBasis,3));

    
    % ------- PUSH ---------
    ngs = ngs.*tel;
    ngs.phase = amplitude*modalBasis +referencePhase;
    ngs = ngs*wfs;
    
    if signal == 0
        sp = wfs.slopes;
    else 
        sp = wfs.intensityFrame;
    end
    
    % ------- PULL ---------
    ngs = ngs.*tel;
    ngs.phase = -amplitude*modalBasis +referencePhase;
    ngs = ngs*wfs;
    
    if signal == 0
        sm = wfs.slopes;
    else 
        sm = wfs.intensityFrame;
    end
    
    
    % PUSH-PULL
    ngs = ngs.*tel;
    iMat=0.5*(sp-sm)/amplitude;

end

