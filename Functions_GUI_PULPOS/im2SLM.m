function out= im2SLM(resol,input,TTangle)

Xres        = resol(2);Yres = resol(1);
Psize       = size(input,1);
% Psize       = 2160;
x           = linspace(-1,1,Psize);
y           = linspace(-1,1,Psize);
[X,Y]       = meshgrid(x,y);

TipTilt     = (X+Y)/2;
alt_TT      = 700*sqrt(2)*sin(TTangle*pi/180);
TT          = exp(alt_TT*i*TipTilt*2*pi);

% alpha       = 89.5*2;
lambda      = 635; %nm;
AmpFactor   = 240;
xcen = 0; ycen=0;
bitmap       = angle(TT.*exp(i*input))/2/pi;bitmap = AmpFactor*(bitmap-min(bitmap(:)));
PyrF         = padarray(bitmap,[(Yres-Psize)/2+ycen (Xres-Psize)/2+xcen],0,'pre');
PyrF         = padarray(PyrF,[(Yres-Psize)/2-ycen (Xres-Psize)/2-xcen],0,'post');
out      = uint8(PyrF);

