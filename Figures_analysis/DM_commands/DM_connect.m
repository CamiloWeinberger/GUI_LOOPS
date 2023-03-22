function [hdl,res,state,TLDFM_Target,hysteresis,a]=DM_connect
% res=libpointer('int8Ptr',int8('USB0::0x1313::0x8016::M00539427::0::RAW'));
res=libpointer('int8Ptr',int8('USB0::0x1313::0x8016::M00538731::0::RAW'));
hdl=libpointer('ulongPtr',0); 

[a,b,c]=calllib('TLDFMX_64', 'TLDFMX_init', res, 0, 0, hdl);
disp(['Initialize Deformable Mirror Device (0 = correct, rest = error): ', num2str(a)]);

TLDFM_Target.T_Mirror   = 0;
TLDFM_Target.T_Tilt     = 1;
TLDFM_Target.T_Both     = 2;
hysteresis.on           = 1;
hysteresis.off          = 0;
state = libpointer('uint16Ptr',2); 
calllib('TLDFM_64','TLDFM_enable_hysteresis_compensation',hdl.value,TLDFM_Target.T_Both,hysteresis.on);
calllib('TLDFM_64','TLDFM_enabled_hysteresis_compensation',hdl.value,TLDFM_Target.T_Mirror,state); % pregunta
disp(['Hysteresis Compensation Mirror(0 = off, 1 = on): ', num2str(state.value)]); 
calllib('TLDFM_64','TLDFM_enabled_hysteresis_compensation',hdl.value,TLDFM_Target.T_Tilt,state); % pregunta
disp(['Hysteresis Compensation Tilt (0 = off, 1 = on): ', num2str(state.value)]); 
return
