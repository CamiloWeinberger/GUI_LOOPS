function [zernike_Ini,zernike_coef,zernikes,zernikePattern,angAmp,expo]=DM_zernike_state

zernike_coef = double(zeros(1,12));
zernike_coef(2) = 0;
MAX_SEGMENTS = 40;
zernikes = 4294967295; % 0xFFFFFFFF Z_All_Flag;
A1 = libpointer('doublePtr',zernike_coef);  %z4 -> z15
zernikePattern = libpointer('doublePtr',double(1:MAX_SEGMENTS));

expo = -0.58496;% -7.5850 2.4136
gain=0;
z4  = -0.06;z5  = -0.18;
z6  = -0.01;z7  = 0.00;z8  = 0.00;
z9  = 0.00;z10 = 0.00;z11 = 0.00;
z12 = 0.00;z13 = 0.00;z14 = 0.00;
z15 = 0.00;
amp = 0.00;ang = 0.00;
angAmp = [amp, ang];
zernike_Ini = [z4, z5, z6, z7, z8, z9, z10, z11, z12, z13, z14, z15];

return