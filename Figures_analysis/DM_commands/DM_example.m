
addpath DM_commands\
if ~exist('hysteresis');[hfile,libname] = DM_library;[hdl,res,state,TLDFM_Target,hysteresis] = DM_connect;end
DM_reload(hdl);

[Zernike_ini,zernike_coef,zernikes,zernikePattern,angAmp,expo ] = DM_zernike_state;
DM_write(hdl,zernikes,zernike_coef,zernikePattern,[0 0]);


%%
ang =-1; 
amp = .3;
zernike_coef = zeros(1,12);
zernike_coef(2) = -.23;
zernike_coef(1) = 0.035;

% preview(v)
tic
h = 0;
while 1
    DM_write(hdl,zernikes,zernike_coef,zermikePattern,[amp ang]);
    ang = ang+1/180;
    if floor(ang) == 1
        ang =-1;
        h = [h toc*2];
        
    end
%     drawnow
%     pause(.01);
end
plot(h)