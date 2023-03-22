function [zernike_coef2,maximos]=DM_calibrate(vid,vid1,hdl,zernikes,zernike_coef,zernikePattern,zernike_Ini)
maximos=zeros(12,100);
ref=0;val=-0.05;
for j=1:12
    imax=0;
    iter=1;
    val0=10;%display(j)
    part=1;
    while val~=val0
        %    display('diferente')
        
        val0=val;
        zernike_coef = zeros(1,12);k=1;
        Img_Zero=zeros(40,40);
        zernike_coef(1,j) = val0;
        zernike_coef = zernike_coef + zernike_Ini;
        DM_write(hdl,zernikes,zernike_coef,zernikePattern);
        pause(0.001);
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
        if m2<15000
            val=ajuste(val,0.1,-1);
        
        elseif m2<25000 && m2>=15000
       if imax<1.5
            val=ajuste(val,(10*0.01+0.01/part)/11,-1);
            part=1+part;
       end
       if imax<2.5 && imax>=1.5
            val=ajuste(val,0.0027,-1);
       end
        end
        %display([m2])
        if m2>=25000
            if imax-ref>=0.005
                val=ajuste(val,0.000001,1);
                iter=iter+1;ref=imax; %fin
            end
            if imax-ref<-0.005
                if iter<100
                    val=ajuste(val,0.00001,-1);   
                    iter=iter+1; ref=imax;%fin                   
                else
                    val=val0;
                end
            end
            display(['Iteracion:               ' num2str(iter)])
        end 
    maximos(j,iter)=val0;       
    end
    zernike_coef2(1,j)=val;
    zernike_Ini(1,j)=val;
    % display([val val0])
end

pause(1)
DM_write(hdl,zernikes,zernike_coef2,zernikePattern);
display(zernike_coef2');
return

