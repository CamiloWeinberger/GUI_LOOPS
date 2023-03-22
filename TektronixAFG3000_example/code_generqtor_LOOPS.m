%% Instrument Connection

% Find a VISA-USB object.
%interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x034A::C014398::0::INSTR', 'Tag', '');
interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x034A::C014398::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = visa('NI', 'USB0::0x0699::0x034A::C014398::0::INSTR');
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

% Connect to instrument object, obj1.
%fopen(interfaceObj);


% dev obj
deviceObj = icdevice('tek_afg3000.mdd', interfaceObj);

connect(deviceObj);

set(deviceObj.Voltage(1), 'Amplitude','min');
set(deviceObj.Voltage(2), 'Amplitude','min');
set(deviceObj.Output(1), 'State', 'off');
set(deviceObj.Output(2), 'State', 'off');

set(deviceObj.Amplitudemodulation(1), 'Enabled', 'off');
set(deviceObj.Amplitudemodulation(2), 'Enabled', 'off');
%%
set(deviceObj.Waveform(1), 'Shape', 'sin');
set(deviceObj.Waveform(2), 'Shape', 'sin');
set(deviceObj.Output(1), 'State', 'on');
set(deviceObj.Output(2), 'State', 'on');
set(deviceObj.Frequency(1), 'ConcurrentState', 'on');
set(deviceObj.Frequency(2), 'ConcurrentState', 'on');


% for idx = -180:180

period = 1000*1e-3;   % ms
frec = 500
mV = 1000; % mV
phase = 60; % -180 to 180
set(deviceObj.Voltage(1), 'Amplitude', mV/1000);
set(deviceObj.Voltage(2), 'Amplitude', 2*mV/1000);
set(deviceObj.Frequency(1), 'Frequency', frec);
set(deviceObj.Frequency(2), 'Frequency', frec);
set(deviceObj.Phase(2), 'Adjust', phase/180*pi);
% end













