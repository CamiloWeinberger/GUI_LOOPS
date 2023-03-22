function [out] = PyWFS_SLM(RESOL,alpha,TTangle)
altura      = 12;%12
Xres        = resol(2);Yres = resol(1);
Psize       = 700;
% Psize       = 2160;
x           = linspace(-1,1,Psize);
y           = linspace(-1,1,Psize);
[X,Y]       = meshgrid(x,y);

TipTilt     = (X+Y)/2;
alt_TT      = 700*sqrt(2)*sin(TTangle*pi/180);
TT          = exp(alt_TT*i*TipTilt*2*pi);


% alpha       = 89.5*2;
lambda      = 635; %nm;
z           = 1/sqrt(2)*Psize*tan((alpha/2)*(2*pi)/180);
amp         = z/lambda;
AmpFactor   = 256;
Pyr         = amp*(abs(X)+abs(Y));Pyr = -(Pyr - min(Pyr(:)));

out       = angle(TT.*exp(i*Pyr))/2/pi;bitmap = AmpFactor*(bitmap-min(bitmap(:)));





