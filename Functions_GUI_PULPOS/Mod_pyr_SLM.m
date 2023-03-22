function [out, pyr,TT] = Mod_pyr_SLM(resol,r,frames,alpha,TTangle)
altura      = -70; %-25 -222
xpos        = 0; %-700
Xres        = resol(2);Yres = resol(1);
Psize       = 700; %700
% Psize       = 2160;
px_um       = 3.75; % SLM px size [um]
H_slm       = 0.633; % SLM wight [um]
lambda      = 0.635; % [um];
x           = linspace(-0.5,0.5,Psize);
y           = x;
[X,Y]       = meshgrid(x,y);
step        = linspace(0,1,frames+1);

TipTilt     = Y;%(X+Y)/2;
alt_TT      = Psize*sqrt(2)*tan(TTangle*pi/180)*px_um;
TT          = exp(alt_TT*i*TipTilt*2*pi/lambda);

z           = 1/sqrt(2)*2*Psize*tan((alpha/2)*pi/180)*px_um; % set high in [um]
amp         = z*2*pi/lambda; % set high in radians
AmpFactor   = 255;
Pyr         = amp*(abs(X)+abs(Y));Pyr = -(Pyr - min(Pyr(:)));
bitmap      = angle(TT.*exp(i*Pyr))/(2*pi);
bitmap      = AmpFactor*(bitmap-min(bitmap(:)));
pyr         = uint8(bitmap); % just for visualization in GUI app image

for idx = 1:length(step)-1
    xcen         = floor(r*cos(step(idx)*2*pi+pi/4))+xpos;
    ycen         = floor(r*sin(step(idx)*2*pi+pi/4))+altura;
    PyrF         = padarray(bitmap,[(Yres-Psize)/2+ycen (Xres-Psize)/2+xcen],0,'pre');
    PyrF         = padarray(PyrF,[(Yres-Psize)/2-ycen (Xres-Psize)/2-xcen],0,'post');
    out(:,:,idx) = uint8(PyrF);
end




