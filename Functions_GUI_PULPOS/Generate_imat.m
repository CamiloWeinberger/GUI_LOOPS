 function [sp,sm,I_0] = Generate_imat(app)
            if app.ZnOrKL == 1
                app = Check_ZernRec(app);
                zern = reshape(app.zernRec(:,1:app.number_modes+1),[app.npx*2 app.npx*2 app.number_modes+1]);
            elseif app.ZnOrKL == 2
                app = Check_KLbasis(app);
                zern = reshape(app.KLbasis(:,1:app.number_modes+1),[app.npx*2 app.npx*2 app.number_modes+1]);
                %display('KL mode, not yet!!')
            end
           

            app = Check_GigeCam(app);
            v = app.v;
            v.FramesPerTrigger = inf;
            start(v);
            sp = [];
            sm=[]; 
            for idx = 1:app.number_modes+1

                if app.Digi_modu == 0
                    for signo = [1 -1]
                        modalBasis_aux  = signo*app.amp_imat*zern(:,:,idx);
                        modalBasis = Pupil2SLM(app,modalBasis_aux);
                        
                        app.UIAxes7.Title.String = ['SLM Bitmap mode = ' num2str(idx-1)];
                        if app.Display_phase == 1
                            imagesc(app.UIAxes7,modalBasis);
                            drawnow;
                        end
                        
                        data = [];
                        while v.FramesAvailable == 0
                            pause(1/30)
                            v.FramesAvailable;
                        end
                        data1 = getdata(v, v.FramesAvailable);
                        data  = data1(:,:,end);
                        datasize = size(data);
                            if signo ==1
                            sp =  [sp data(:)];
                        elseif signo ==-1
                            sm =  [sm data(:)];
                        end
                    end
                else  % DIGITAL MODULATION INIT

                    if idx == 1
                        if app.Digi_modu == 1
                            modalModul = Digital_modulation(app);
                        elseif app.Digi_modu == 3
                            modalModul = Digital_modulation_pyr(app);
                        end
                    end
                    spsm = [1 -1];
                  
                    for signo = spsm
                        modalBasis0  = signo*app.amp_imat*zern(:,:,idx);


                        for idT = 1:app.Nstep

                            if app.Digi_modu == 1
                                modalBasis_aux = modalModul(:,:,idT)+modalBasis0;
                                modalBasis  = Pupil2SLM(app,modalBasis_aux);
                            elseif app.Digi_modu == 2
                                if idT == 1
                                    dTheta = linspace(-1,1,app.Nstep+1);
                                    modalBasis  = Pupil2SLM(app,modalBasis0);
                                end
                                app.DMangAmp(1) = app.LambdaOverD;%/18.8; % corrected and calibrated!!!!!!!!
                                app.DMangAmp(2) = dTheta(idT);
                                DM_write(app.hdl,app.zernCode,app.Zernike_ini,app.zernikePattern,app.DMangAmp);
                                pause(5e-3)

                            elseif app.Digi_modu == 3
                                modalBasis  = Pupil2SLM(app,modalBasis0);
                                app.slm.bitmap = modalModul(:,:,idT);

                            end


                        app.UIAxes7.Title.String = ['SLM Bitmap mode = ' num2str(idx-1)];
                        if app.Display_phase ==1
                            imagesc(app.UIAxes7,modalBasis);
                            drawnow;
                        end
                        
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
                        end
                        
                        if app.Display_camera == 1
                            imagesc(app.UIAxes_Cpupils,data);
                            drawnow;
                        end

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

                        if signo ==1
                            sp =  [sp sMean(:)];
                        elseif signo ==-1
                            sm =  [sm sMean(:)];
                        end
                    end
                
                end




            end


            stop(v);
            I_0 = reshape(sp(:,1),[datasize]);
            app.I_0 = I_0;
            imagesc(app.UIAxes_Cpupils,app.I_0); drawnow;
            app.UIAxes_Cpupils.Position = app.cam_resol2;
            app.UIAxes_Cpupils.XLim = [1 size(app.I_0,2)];
            app.UIAxes_Cpupils.YLim = [1 size(app.I_0,1)];
            sp = sp(:,2:end);
            sm = sm(:,2:end);
        end