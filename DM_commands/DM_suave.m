function [zernike_coef2,maximos]=DM_suave(vid,vid1,hdl,zernikes,zernike_coef,zernikePattern,zernike_Ini)
maximos=zeros(12,100);
ref=0;
base=zernike_coef;
tic
for j=1:6
    imax=0;
    iter=1;   
zernike_coef=base;
    part=1;
    
    for val=-0.2:0.0005:0.2
        %    display('diferente')
        val0=val;
        zernike_coef = zeros(1,12);k=1;
        Img_Zero=zeros(40,40);
        zernike_coef(1,j) = val0;
        zernike_coef = zernike_coef + zernike_Ini;
        DM_write(hdl,zernikes,zernike_coef,zernikePattern);
       % pause(0.001);
        figure(4);[foto,foto2]=view_cameras(vid,vid1);axis image; title([num2str(k)]);    
        espejo1(k,:)=foto(:);espejo2(k,:)=foto2(:);       
        figure(5);title([num2str(j)]);    
        t=(j-1)*2+floor(i+1)+1;
        figure(7);[imax,m2]=maxima(foto,foto2);
        %imax=mean(imax(:)+m2(:))/2;   
        %display([imax m2]);

        
                
        display(['---------------------------------------------------------']);
        display(['Informacion del ajuste ']);
        display(['Modo zernike:           ' num2str(j)]);
        display(['Grado:                  ' num2str(val)]); 
        display(['Razon maximo/cercano:   ' num2str(imax)]);
        display(['Maximo:                 ' num2str(m2)]);
        display(['Tiempo:                 ' num2str(toc/60)])
        
        iter=iter+1;val=val+0.0005;  
        zernike_coef2(j,iter,1)=val;
    zernike_coef2(j,iter,2)=imax;
    zernike_coef2(j,iter,3)=m2;
    
    end

    % display([val val0])
end

pause(1)
%DM_write(hdl,zernikes,zernike_coef2,zernikePattern);
%display(zernike_coef2');
toc
display(toc/60/60)
return

