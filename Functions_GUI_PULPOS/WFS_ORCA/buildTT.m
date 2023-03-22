function [ tip_tilt ] = buildTT( nPx,step,Nx,Ny)
% building a cube with TIP-TILT for each point in Camera with:
%    - step in Lambda/D
%    - Nx and Ny being the FoV in x and y.ex: FoV = Nx*step in Lambda/D

    tip_tilt = [];
    % nPx is the number of pixel in SLM
    l = linspace(-nPx/2,nPx/2,nPx);
    [X,Y] = meshgrid(l,l);
    compt = 0;
    for i=-Ny/2:Ny/2
        for j=-Nx/2:Nx/2
            
            compt = compt +1;
            % Indicate the central pixel
            if i == 0 && j == 0
                disp(compt)
            end
            
            ls = (2*pi/nPx)*(i*step*X+j*step*Y);
            
           tip_tilt= cat(3,tip_tilt,ls);
           
           
        end
    end

end

