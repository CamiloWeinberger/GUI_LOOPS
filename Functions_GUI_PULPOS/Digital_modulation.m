function modalModulation = Digital_modulation(app)
            dTheta = linspace(0,2*pi,app.Nstep+1);
            zern = zernike(2:3,'resolution',app.npx*2);
            TipTilt =reshape(zern.modes,[app.npx*2 app.npx*2 2]);
            for idT = 1:app.Nstep
                dT = dTheta(idT);
                modalModulation(:,:,idT) = app.LambdaOverD* (cos(dT)*TipTilt(:,:,1)+sin(dT)*TipTilt(:,:,2));
            end
end