function [out] = Mod_pyr_SLM_preconditioner(resol,r,frames,alpha,TTangle,OL1)

altura = 2;


Xres        = resol(2);Yres = resol(1);
Psize       = 700;
% Psize       = 2160;
px_um       = 3.75; % SLM px size [um]
H_slm       = 0.633; % SLM wight [um]
x           = linspace(-1,1,Psize);
y           = x;
[X,Y]       = meshgrid(x,y);
step        = linspace(0,1,frames+1);

TipTilt     = (X+Y)/2;
alt_TT      = Psize*sqrt(2)*sin(TTangle*pi/180)/H_slm;
TT          = exp(alt_TT*i*TipTilt*2*pi);
Psize2      = size(OL1,1);

OL1         = padarray(OL1,[(Psize-Psize2)/2 (Psize-Psize2)/2],0,'pre');
OL1         = padarray(OL1,[(Psize-Psize2)/2 (Psize-Psize2)/2],0,'post');
% alpha       = 89.5*2;
lambda      = 635; %nm;
z           = 1/sqrt(2)*Psize*tan((alpha/2)*(2*pi)/180);
amp         = z/lambda;
AmpFactor   = 240;
Pyr         = amp*(abs(X)+abs(Y));Pyr = -(Pyr - min(Pyr(:)));

for idx = 1:length(step)-1
xcen        = floor(r*cos(step(idx)*2*pi+pi/4));
ycen        = floor(r*sin(step(idx)*2*pi+pi/4))+altura;
bitmap       = angle(TT.*exp(i*OL1).*exp(i*Pyr))/2/pi;bitmap = AmpFactor*(bitmap-min(bitmap(:)));
PyrF         = padarray(bitmap,[(Yres-Psize)/2+ycen (Xres-Psize)/2+xcen],0,'pre');
PyrF         = padarray(PyrF,[(Yres-Psize)/2-ycen (Xres-Psize)/2-xcen],0,'post');
out(:,:,idx) = uint8(PyrF);
end


