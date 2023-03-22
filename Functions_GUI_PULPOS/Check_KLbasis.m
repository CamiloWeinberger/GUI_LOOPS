function app = Check_KLbasis(app)
            Ntotal = app.number_modes+1;
            if Ntotal > size(app.KLbasis,2)
                tel = telescope(1,'resolution',app.npx*2);
                atm= atmosphere(photometry.I,1,25,'altitude',0);
                app.KLbasis = KL_basis(tel,atm,Ntotal).KL_pure;
            end
            app.tel_mask = reshape(app.KLbasis(:,1),[app.npx*2 app.npx*2])~=0;
            imagesc(app.Tel_imag,app.tel_mask);
            app.Tel_imag.XLim = [1 size(app.tel_mask,1)];
            app.Tel_imag.YLim = [1 size(app.tel_mask,1)];
            drawnow;
end