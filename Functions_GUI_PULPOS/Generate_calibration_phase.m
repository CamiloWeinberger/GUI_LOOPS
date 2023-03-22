function app = Generate_calibration_phase(app)
            zern = zernike(app.Zernike_calibration_position,'resolution',app.npx*2);
            
            modalBasis = app.amp*reshape(zern.modes,[app.npx*2 app.npx*2]);
            modalBasis  = Pupil2SLM(app,modalBasis);
            imagesc(app.UIAxes7,modalBasis);
            
end