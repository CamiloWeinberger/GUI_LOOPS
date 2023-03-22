function [X_s,Y_p,Y_0] = Generate_experiment_data(app )

app = Check_GigeCam(app);
v = app.v;
v.FramesPerTrigger = inf;
start(v);
Y_p = 0*(app.Y_z);
I_o = app.I_0/sum(app.I_0(:));
%% Check if the valaue is an bitmap or a single map
X_phase = app.X_phase;
if isa(X_phase,'single')
    type_case = 1;
elseif isa(X_phase,'double')
    type_case = 1;
elseif isa(X_phase,'uint8')
    type_case = 2;
end


%% Identify if is a bitmap or a pupil phasemap
if size(X_phase,1) == size(X_phase,2)
    image_case = 1; % pupil
elseif sum(size(X_phase)) == app.SLMresolution_X
    image_case = 2; % bitmap
end

for idx = 1:size(X_phase,3)
    phase = X_phase(:,:,idx);
    app.prgressLabel.Text = [num2str(idx*100/size(X_phase,3)) '%'];
    % Case if pupil phase, full image phase, full image bitmap

for idT = 1:app.Nstep

    if app.Digi_modu == 2
        if idT == 1
            dTheta = linspace(-1,1,app.Nstep+1);
            if image_case == 1
                Pupil2SLM(app,phase);
            elseif image_case == 2
                if type_case == 1
                    Phase2SLM(app,phase);
                elseif type_case == 2
                    SLM_write(app,phase);
                end
            end
        end
        app.DMangAmp(1) = app.LambdaOverD;%/18.8; % corrected and calibrated!!!!!!!!
        app.DMangAmp(2) = dTheta(idT);
        DM_write(app.hdl,app.zernCode,app.Zernike_ini,app.zernikePattern,app.DMangAmp);
    else
        Pupil2SLM(app,phase);
    end
    data = [];


    
    while v.FramesAvailable == 0
        pause(1/30)
%         display(['Frames in camera = ' num2str(v.FramesAvailable)])
    end
    data1 = getdata(v, v.FramesAvailable);
    data  = data1(:,:,end);
    if ~isempty(app.r_i)
        data = data(app.r_i(1):app.r_i(2),app.r_i(3):app.r_i(4));
    end
    dat(:,:,idT) = data;
end
camFrame        = mean(dat,3);
X_s(:,:,idx)    = camFrame;
%idx
%imagesc(camFrame);drawnow
Y_0 = app.Y_z(idx,:);
if app.Display_prediction == 1
    camFrame = camFrame/sum(camFrame(:)) - I_o;
    Y_pred  = app.pyr2mode*camFrame(:);
    Y_p(:,idx) = Y_pred(:);
    xlim = min([length(Y_0) length(Y_pred)])
    plot(app.UIPrediciton,1:length(Y_0),Y_0,'b',1:length(Y_pred),Y_pred,'r','LineWidth',2);
    app.UIPrediciton.XLim = [1 xlim];
    app.UIPrediciton.YLim = [-max(abs(Y_0)) max(abs(Y_0))];
    legend(app.UIPrediciton,[{'Ground Truth'},{'Pyramid prediction'}]);
    drawnow;
end

if app.Correction_Exp == 1
    if app.ZnOrKL == 1
        app = Check_ZernRec(app);
        zern = reshape(app.zernRec(:,1:app.number_modes+1),[app.npx*2 app.npx*2 app.number_modes+1]);
        recon = app.zernRec(:,2:length(Y_pred)+1)*Y_p;
    elseif app.ZnOrKL == 2
        app = Check_KLbasis(app);
        zern = reshape(app.KLbasis(:,1:app.number_modes+1),[app.npx*2 app.npx*2 app.number_modes+1]);
        recon = app.KLbasis(:,2:length(Y_pred)+1)*Y_p;
    end
recon = X_phase-recon;
recon = recon;
Pupil2SLM(app,recon)
end

if app.Pause_Exp == 1
    stop(v)
    pause
    start(v)
end

end




return