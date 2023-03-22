function [app] = Add_WFS_filter(app)
    resol       = [1024,1280];
    if app.check_slm_pyr == 0
        [slm] = ORCA_slmFocalPlane( faces,angle)
%         app.slm                 = SLM2(resol);
%         app.slm.driver          = @(bitmap,id) fullscreenPupil(bitmap, id);
%         app.slm.driver_display  = 3;
%         
%         TTangle     = 0.85; % 4 TipTilt angle in degrees
%         alpha       = 89.4;%89.4
%         alpha       = 0.7;
%         [bitmap,pyr,TT] =  Mod_pyr_SLM(resol,0,1,alpha, TTangle);% no modulation
%         app.check_slm_pyr = 1;
%         app.TT = TT;
%     else
%         [bitmap,pyr] = Mod_WFS_mask(app,0,1);
%     end
    app.bitmap_WFS = pyr;
    app.slm.bitmap = bitmap;
end