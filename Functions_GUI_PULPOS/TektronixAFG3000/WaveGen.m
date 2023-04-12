classdef WaveGen < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    %   For more information ask to camilo.weinberger.c@mail.pucv.cl

    properties
        Mod;  % Modulation, automatic voltaje control
        Voltage1 = 0; % Manual V1
        Voltage2 = 0; % Manual V2
        Frequency = 30; % Frequency from V1 and V2
        Phase = 75; % phase V2
        Status = 0; % 1/2 on/off
        deviceObj;
        tag = 'Wave signal generator USB control';


    end

    methods
        function obj = WaveGen
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            Dev = visadevlist;
            prompt = 'Witch WaveGen (number): ';
            display(visadevlist)
            visa_f = Dev.ResourceName(1);
            interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', visa_f, 'Tag', '');
            if isempty(interfaceObj)
                interfaceObj = visa('NI', [visa_f]);
                
            else
                fclose(interfaceObj);
                interfaceObj = interfaceObj(1);
            end

            % Connect to instrument object, obj1.
            %fopen(interfaceObj);


            % dev obj
            deviceObj = icdevice('tek_afg3000.mdd', interfaceObj);

            connect(deviceObj);
            obj.deviceObj = deviceObj;
            
            turn_off(obj);
            display(obj);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%  Convert the modulation into Voltages values (Edit here)%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function out = conv_mod(obj,input)
            
            amp_fact1 = input*.1085+.1587; % editable factor Volt 1
            amp_fact2 = input*.1694+.2642; % editable factor Volt 2
            
            out = [amp_fact1, amp_fact2];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function display(obj)
            fprintf('____ %s ____\n',obj.tag)
            fprintf('Model: Tektronix AFG3022C dual chanel\n')
            fprintf('----------------------------------------\n')
        end
        
        
        
        %%%%%%% Do not modify %%%%%%%%%%%
      
        function out = turn_off(obj)
            deviceObj = obj.deviceObj;
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            set(deviceObj.Voltage(1), 'Amplitude','min');
            set(deviceObj.Voltage(2), 'Amplitude','min');
            pause(1/30);
            set(deviceObj.Output(1), 'State', 'off');
            set(deviceObj.Output(2), 'State', 'off');
            set(deviceObj.Frequency(1), 'ConcurrentState', 'off');
            set(deviceObj.Frequency(2), 'ConcurrentState', 'off');
            set(deviceObj.Phase(2), 'Adjust', 0/180*pi);
        end

        function out = turn_on(obj)
            deviceObj = obj.deviceObj;
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            set(deviceObj.Waveform(1), 'Shape', 'sin');
            set(deviceObj.Waveform(2), 'Shape', 'sin');
            set(deviceObj.Frequency(1), 'ConcurrentState', 'on');
            set(deviceObj.Frequency(2), 'ConcurrentState', 'on');
            set(deviceObj.Output(1), 'State', 'on');
            set(deviceObj.Output(2), 'State', 'on');
        end
        
        function obj = write(obj)
            deviceObj = obj.deviceObj;
            set(deviceObj.Voltage(1), 'Amplitude', obj.Voltage1);
            set(deviceObj.Voltage(2), 'Amplitude', obj.Voltage2);
            set(deviceObj.Frequency(1), 'Frequency', obj.Frequency);
            set(deviceObj.Frequency(2), 'Frequency', obj.Frequency);
            set(deviceObj.Phase(2), 'Adjust', obj.Phase/180*pi);
        end

        function obj = set.Mod(obj,value)
            mod = value;
            obj.Mod = value;
            if mod > 0
                obj.Status = 1;
                vals = conv_mod(obj,mod);
                obj.Voltage1 = vals(1); % Manual V1
                obj.Voltage2 = vals(2); % Manual V2
                turn_on(obj);
                obj = write(obj);
            elseif mod == 0
                obj.Status = 0;
                obj.Voltage1 = 0; % Manual V1
                obj.Voltage2 = 0; % Manual V2
                obj = write(obj);
                turn_off(obj);
            end
        end
        
        function obj = set.Frequency(obj,value)
            obj.Frequency = value;
            obj = write(obj);
        end
        
        function obj = set.Voltage1(obj,value)
            obj.Voltage1 = value;
            obj = write(obj);
        end
        
        function obj = set.Voltage2(obj,value)
            obj.Voltage2 = value;
            obj = write(obj);
        end
        
        function obj = set.Phase(obj,value)
            obj.Phase = value;
            obj = write(obj);
        end
        
        function out = get.Status(obj)
            if obj.Status == 1
                display('Status: ON')
            else
                display('Status: OFF')
            end
        end
        
        

    end
end