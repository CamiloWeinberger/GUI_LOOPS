function [prediction,zernike_Ini]=DM_AO_zernike(net,vid1,hdl,zernikes,zernike_Ini,zernikePattern,angAmp,L,val)
%L=100;%prediccion con imagen de 220x220;
%prediction=zeros(1,14);
zernike_coef=zeros(1,12);
[foto2]=view_cameras(vid1);
%figure(4);imagesc(foto2);axis image
[m n]=size(foto2);
x=(m-L)/2+1:(m+L)/2;
y=(n-L)/2+1:(n+L)/2;
prediction=predict(net,im2double(foto2(x,y)));
zernike_coef = -val*prediction(:)'+zernike_Ini;
DM_write(hdl,zernikes,zernike_coef,zernikePattern,angAmp);
zernike_Ini=zernike_coef;
end
