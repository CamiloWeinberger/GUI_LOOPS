function [hfile,libname,hdl,res,state,TLDFM_Target,hysteresis]=DM_checking(DM_exist)

% Prueba DM 
if exist('hysteresis')==0;[hfile,libname]=DM_library;[hdl,res,state,TLDFM_Target,hysteresis]=DM_connect;else
end
 