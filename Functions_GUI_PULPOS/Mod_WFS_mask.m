function [out,bitmap] = Mod_WFS_mask(app,r,frames)
    resol       = app.slm.size;
    altura      = -70;%20
    Xres        = resol(2);Yres = resol(1);
    step        = linspace(0,1,frames+1);


    bitmap      = app.bitmap_WFS;
    exc = abs(size(bitmap,1)-size(app.TT,1));
    bitmap  = padarray(bitmap,[exc/2 exc/2],'both');
    if strcmp(class(bitmap),'double')
        if max(bitmap(:))> 2^8-1 | min(bitmap(:))<0
            bitmap = angle(app.TT.*exp(i*bitmap))/2/pi; 
            bitmap = 255*(bitmap-min(bitmap(:)));
        end
        bitmap = uint8(bitmap);
        Psize       = size(bitmap,1);
    elseif strcmp(class(bitmap),'uint8')
        Psize       = size(bitmap,1);
    end

    for idx = 1:length(step)-1
        xcen         = floor(r*cos(step(idx)*2*pi+pi/4));
        ycen         = floor(r*sin(step(idx)*2*pi+pi/4))+altura;
        PyrF         = padarray(bitmap,[(Yres-Psize)/2+ycen (Xres-Psize)/2+xcen],0,'pre');
        PyrF         = padarray(PyrF,[(Yres-Psize)/2-ycen (Xres-Psize)/2-xcen],0,'post');
        out(:,:,idx) = uint8(PyrF);
    end
    
    
    
    
    