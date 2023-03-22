function [modalModulation] = Digital_modulation_pyr(app)
resol       = [2160, 3840];

dTheta = linspace(0,2*pi,app.Nstep+1);

[modalModulation] =  Mod_WFS_mask(app,app.LambdaOverD,app.Nstep);% modulation (RESOL SLM, Radio Px, Frames)
end