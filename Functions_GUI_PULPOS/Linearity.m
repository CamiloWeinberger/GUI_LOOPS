  function sm = Linearity(app)
            data = [];
            
            if app.ZnOrKL == 1
                app = Check_ZernRec(app);
                zern = reshape(app.zernRec,[app.npx*2 app.npx*2 size(app.zernRec,2)]);
            elseif app.ZnOrKL == 2
                display('KL mode, not yet!!')
            end
            
            
            app = Check_GigeCam(app);
            v = app.v;
            v.FramesPerTrigger = inf;
            start(v);
            sm=[]; 
            modalModul = Digital_modulation(app);
            spsm = linspace(-app.amp_linearity,app.amp_linearity,app.LinearitySteps);

             if app.Digi_modu == 1  % DIGITAL MODULATION
                    
                    for signo = spsm  % amplitude
                        modalBasis0  = signo*zern(:,:,str2num(app.Mode4Linearity)+2);
                        for idT = 1:app.Nstep
                        modalBasis_aux = modalModul(:,:,idT)+modalBasis0;
                        modalBasis  = Pupil2SLM(app,modalBasis_aux);
                        drawnow;
                        
                        data = [];
                        while v.FramesAvailable == 0
                            pause(1/30)
                            v.FramesAvailable
                        end
                        
                        data1 = getdata(v, v.FramesAvailable);
                        data = data1(:,:,1,end);
                        size(data);
                        if ~isempty(app.r_i)
                            data = data(app.r_i(1):app.r_i(2),app.r_i(3):app.r_i(4));
                            size(data);
                        end
                        imagesc(app.UIAxes_Cpupils,data);
                        dat(:,:,idT) = data;
                        if ~isempty(app.r_i)
                            app.UIAxes_Cpupils.Position = app.cam_resol2;
                        else
                            app.UIAxes_Cpupils.Position = app.cam_resol;
                        end
                        drawnow;
                        end
                        sMean =  mean(dat,3);
                        datasize = size(sMean);
                        
                        sm =  [sm sMean(:)];
                    end
                
                
                elseif app.Digi_modu == 0
                    spsm = linspace(-app.amp_linearity,app.amp_linearity,app.LinearitySteps);
                    for signo = spsm  % amplitude
                        modalBasis_aux  = signo*zern(:,:,app.Mode4Linearity);
                        modalBasis  = app.Pupil2SLM(modalBasis_aux);
                        drawnow;

                        data = [];
                        while v.FramesAvailable == 0
                            pause(1/30)
                            v.FramesAvailable
                        end

                        data1 = getdata(v, v.FramesAvailable);
                        data  = data1(:,:,end);

                        sm =  [sm modalBasis(:)];

                    end
                end

            stop(v);    
        

        end