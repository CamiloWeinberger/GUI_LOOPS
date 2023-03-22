function relaxdm(hdl)

MAX_SEGMENTS = 40;
isFirstStep  = 1;
reload       = 1;
TLDFM_Target.T_Mirror = 0;
TLDFM_Target.T_Tilt = 1;
TLDFM_Target.T_Both = 2;
relaxPattern = libpointer('doublePtr',double(1:MAX_SEGMENTS)); 
remainingRelaxSteps = libpointer('longPtr',0); 
disp('Relaxing')
calllib('TLDFMX_64','TLDFMX_relax',hdl.value,TLDFM_Target.T_Mirror,isFirstStep,reload,relaxPattern,0,remainingRelaxSteps);
calllib('TLDFM_64','TLDFM_set_segment_voltages',hdl.value,relaxPattern);
isFirstStep = 0;
while remainingRelaxSteps.value > 0
calllib('TLDFMX_64','TLDFMX_relax',hdl.value,TLDFM_Target.T_Mirror,isFirstStep,reload,relaxPattern,0,remainingRelaxSteps);
calllib('TLDFM_64','TLDFM_set_segment_voltages',hdl.value,relaxPattern);
end
disp('Finished Relax')