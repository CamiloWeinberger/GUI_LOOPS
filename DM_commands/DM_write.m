function DM_write(hdl,zernikes,zernike_coef,zernikePattern,angAmp)
tilt_amplitud=angAmp(1);
tilt_angle=angAmp(2)*180;
A1 = libpointer('doublePtr',zernike_coef);  %z4 -> z15
calllib('TLDFMX_64','TLDFMX_calculate_zernike_pattern',hdl.value,zernikes,A1,zernikePattern);
% esp=espejo(zernikePattern.value);
calllib('TLDFM_64','TLDFM_set_tilt_amplitude_angle',hdl.value,tilt_amplitud,tilt_angle);
calllib('TLDFM_64','TLDFM_set_segment_voltages',hdl.value,zernikePattern);                     
end