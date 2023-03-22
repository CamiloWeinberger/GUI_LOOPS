function [ map, Cphi ] = psdScreen(tel,atm,nActuator,nMap)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


    %====== Frequency space sampling ======
    nPx = tel.resolution;
    N = 4*nPx;
    L = (N-1)*tel.D/(nPx-1);
    [fx,fy]  = freqspace(N,'meshgrid');
    [~,fr]  = cart2pol(fx,fy);
    fr  = fr.*(N-1)/L./2;
    fc = 0.5*(nActuator-1)/tel.D;
    
    % Von Karman
    Cphi = phaseStats.spectrum(fr,atm);
    
    % Fitting correction
    Cphi(fr<fc) = 0;
    
    % Error propagation : PSD from spatialFrequencyAO function

%     load('Cphi_fitting.mat')
%     Cphi = PSD;
%     
%     margeA = zeros(39,252);
%     margeB = zeros(39,252);
%     marge1 = zeros(174,39);
%     marge2 = zeros(174,39);
%     
%     
%     Cphi = horzcat(marge1,Cphi,marge2);
%     Cphi = vertcat(margeA,Cphi,margeB);

    
    % Turbulence screen generation
    map = zeros(nPx,nPx,nMap);
    for m=1:nMap
        WNF = fft2(randn(atm.rngStream,N))./N; % White noise filtering
        [idx] = find(fr==0);
        psdRoot = sqrt(Cphi);
        psdRoot(idx) = 0;
        mapPsd = psdRoot.*WNF;
        mapPsd = real(ifft2(fftshift(mapPsd)).*(1./L)).*N.^2;
        mapPsd = mapPsd(1:nPx,1:nPx);
        map(:,:,m) = mapPsd;
    end
    
end

