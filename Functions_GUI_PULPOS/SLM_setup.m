main_path = 'C:\Users\Charlotte\Documents\MATLAB\Pyramid\runningTheBench\';
addpath([main_path])
addpath([main_path 'functionFiles\'])
addpath ([main_path 'WFS_ORCA\'])
addpath(['C:\Users\Charlotte\Documents\MATLAB\Pyramid\OOMAO\external_functions\']);

corrSLM = load([main_path '16032023_new_flatmap_PWFS4'],'new_flat');
corrSLM = corrSLM.new_flat;

%% SLM Setup Variables 03/06/2022
radiusSLM           = 135;
centerSLM           = [630,680];
resol=[1024,1280];
app.npx0            = radiusSLM;     % phasemap pupil radius
app.Cx              = centerSLM(1);       % Position in X-axis
app.Cy              = centerSLM(2);       % position in Y-axis

%%% SLM RESOLUTION
app.SLMresolution_X = resol(1);
app.SLMresolution_Y = resol(2);


%%% SLM
slm_pupil           = SLM([1024, 1280]);
slm_pupil.driver    = @(bitmap,id) fullscreenPupil(bitmap, id);
slm_pupil.driver_display = 2;
slm_pupil.flatmap   = corrSLM;

faces = 4;
angle = -1.25*pi/8;
slm = ORCA_slmFocalPlane(faces,angle);
