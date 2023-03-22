function app = Check_ZernRec(app)
            Ntotal = app.number_modes+1;
            if Ntotal > size(app.zernRec,2)
            zern = zernike(1:Ntotal,'resolution',app.npx*2);
            app.zernRec = zern.modes;
            end
            if isempty(app.tel_mask)
            app.tel_mask = reshape(app.zernRec(:,1),[app.npx*2 app.npx*2])~=0;
            end
            imagesc(app.Tel_imag,app.tel_mask);
            app.Tel_imag.XLim = [1 size(app.tel_mask,1)];
            app.Tel_imag.YLim = [1 size(app.tel_mask,1)];
            drawnow;
end