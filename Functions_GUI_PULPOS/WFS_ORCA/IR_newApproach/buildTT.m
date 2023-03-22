function [ tip_tilt ] = buildTT( nPx,c,FoV )
% building a cube with TIP-TILT for each point in V. 
    tip_tilt = [];
    
    l = linspace(-nPx/2,nPx/2,nPx);
    [X,Y] = meshgrid(l,l);
    
    compt = 0;
    for i=1:2*c*nPx
        for j=1:2*c*nPx
            compt = compt +1;
            if i == 2*c*nPx/2+1 && j == 2*c*nPx/2+1
                disp(compt)
            end
            
            ls = 2*pi/(2*c*nPx)*((i-(2*c*nPx)/2-1)*X+(j-(2*c*nPx)/2-1)*Y);
            
           tip_tilt= cat(3,tip_tilt,ls);
           
           
        end
    end

end

