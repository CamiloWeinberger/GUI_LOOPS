function [hfile,libname]=DM_library
mainpath = 'C:\Users\optolab\Desktop\PULPOS\PULPOS_Devices_Control_Codes\SLM_Connection&Control_PULPOS\SDK_SLM\GUI_PULPOS_GitHub';
libname='\DM_lib\Win64\Bin\TLDFM_64.dll';
hfile='\DM_lib\Win64\include\TLDFM.h'; 
loadlibrary(libname,hfile,'includepath',[mainpath '\DM_lib\Win64\include\'], 'includepath', ...
    [mainpath '\DM_lib\Win64\Lib_x64\']);
disp('TLDFM_64.dll loaded.');
%
%   Loading the dll and header file into MATLAB TLDFM_64.dll
libname='.\DM_lib\Win64\Bin\TLDFMX_64.dll';
hfile='.\DM_lib\Win64\include\TLDFMX.h'; 
loadlibrary(libname,hfile,'includepath',[mainpath '\DM_lib\Win64\include\'], 'includepath', ...
    [mainpath '\DM_lib\Win64\Lib_x64\']);
disp('TLDFMX_64.dll loaded.');
return