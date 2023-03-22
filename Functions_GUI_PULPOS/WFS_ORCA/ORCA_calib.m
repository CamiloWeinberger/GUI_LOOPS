%% Calibration 
ampCalibrationSLM = 0.4;
nAv = 1;
frameRef = 0;
modesNumberSLM = nModes;
intMat = calibrateSLMStyle(wfs,dmSLM,tel,ampCalibrationSLM,...
    zeros(modesNumberSLM,1),2,frameRef,nAv);
dmSLM.coefs=0;
