function modalBasis = Pupil2SLM(app,input)
input = single(input);
%             modalBasis  = padarray(input,[app.SLMresolution_Y-app.npx-app.Cy app.SLMresolution_X-app.npx-app.Cx],0,'post');
%             modalBasis  = padarray(modalBasis,[app.Cy-app.npx app.Cx-app.npx],0,'pre');
            modalBasis  = padarray(input,[app.SLMresolution_Y-size(input,1)/2-app.Cy app.SLMresolution_X-size(input,1)/2-app.Cx],0,'post');
            modalBasis  = padarray(modalBasis,[app.Cy-size(input,1)/2 app.Cx-size(input,1)/2],0,'pre');
            phaseTotal  = exp(i*(pi*modalBasis + app.im_corr -pi));
            if app.add_tel_mask == 1
                phaseTotal = phaseTotal.*app.tel_mask;
            end
            modalBasis  = app.ampFactor*(angle(phaseTotal)/pi+1)/2; % uint8
            
            SLM_write(app,modalBasis);
            
end