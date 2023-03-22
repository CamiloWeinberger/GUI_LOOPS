function DM_function(hdl,zernikes,zernikePattern,vid,vid1,zernike_Ini)
k=1;
expo = -0.58496;% -7.5850 2.4136
gain=0;
Img_Zero= zeros(40,40);
for j =1:1:12
   % disp(j)
    for i = [-0.5 0 0.5]   
%         i=0
        zernike_coef = zeros(1,12);
        zernike_coef(1,j) = i; 
        zernike_coef = zernike_coef + zernike_Ini;
     %   if zernike_coef(1,j) > 1 | zernike_coef(1,j) < -1
      %       Dato(:,:,k) = Img_Zero;
     %   else
            
            pause(1);%
            DM_write(hdl,zernikes,zernike_coef,zernikePattern)
            
            figure(4);[foto,foto2]=view_cameras(vid,vid1);axis image; title([num2str(k)])
            espejo1(k,:)=foto(:);espejo2(k,:)=foto2(:);
            t=(j-1)*2+floor(i+1)+1;
            figure(7);maxima(foto,foto2);
            %zernike_coef'
      %  end
        k   = k+1;

    end  

end
return