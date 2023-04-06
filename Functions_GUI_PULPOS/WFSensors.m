classdef WFSensors% < handle
    %UNTITLED Summary of this class goes here
    %   Version for HAMAMATSU MATLAB R2019a
    %   run cameras
    
    
    properties (Access = public)
        camNumber;
        vid;
        srce;
        Exposure = 10000;
        ExposureTime = 10000*1e-4;
        FrameRate = 30;
        Gain = 256;
        ROI = [700 700 600 600];
        set_im_dark;
        get_frames;
        im_dark;
        frame;
        rec = 0;
        
        
        tag = 'Camera for Wave Front Sensing';
    end
    
    methods
        function obj = WFSensors(camNumber)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.camNumber = camNumber;
            delete(imaqfind)
            if camNumber == 1
                vid = videoinput('hamamatsu',1,'MONO16_2048x2048_FastMode');
                vid.FramesPerTrigger = 2000;
                vid.TriggerRepeat = 1;
                triggerconfig(vid, 'immediate')
                vid.TriggerCondition;
                srce = getselectedsource(vid);
                srce.TriggerConnector = 'bnc';
                srce.ExposureTime = obj.Exposure*1e-5;
            elseif camNumber == 2
                vid = videoinput('gige', app.camNumber, 'Mono12');
                srce = vid.Source;
                srce.Exposure = obj.Exposure;
                srce.FrameRate = obj.Gain;
                srce.Gain = obj.Gain;
                vid.FramesPerTrigger = 2000;
                srce.Offset = 0;
                srce.PacketSize = 9000;
            end
            obj.vid = vid;
            obj.srce = srce;
            if isempty(obj.ROI)
                obj.ROI = vid.ROIPosition;
            else
                vid.ROIPosition = obj.ROI;
            end
        end
        
        %%%%%%%%%%%%%%%% Dark image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = set.set_im_dark(obj,val)
            im = 0;
            im_bk = 0;
            nAv = val;
            for n=1:nAv
                im_tmp = double(getsnapshot(obj.vid))-im_bk;
                im = im + im_tmp/nAv;
            end
            obj.im_dark = im;
        end
        function out = get.im_dark(obj)
            out = obj.im_dark;
        end
        %%%%%%%%%%%%%%%% Get and set frames  %%%%%%%%%%%%%%%%%%%%%%%
        
        function obj = set.get_frames(obj,value)
            if obj.vid.FramesAvailable == obj.vid.FramesPerTrigger
                obj.rec = 1;
            end
            if obj.vid.FramesAvailable < value
                pause(1/30)
            end
            obj.frame = mean(double(getdata(obj.vid, obj.vid.FramesAvailable)),4);
        end
        
        function obj = set.rec(obj,val)
            if val == 0
                stop(obj.vid)
            else
                start(obj.vid)
            end
            obj.rec = val;
        end
        
        function out = get.frame(obj)
%             if obj.vid.FramesAvailable == obj.vid.FramesPerTrigger
%                 obj.rec = 1;
%             end
            image = getdata(obj.vid,obj.vid.FramesAvailable);
            image = double(image(:,:,1,end));
            if size(image) == size(obj.im_dark)
                out = image-obj.im_dark;
            else
                out = image;
            end
            pause(1e-6)
        end
        
        
        
        %%%%%%%%%%%%% Set cam parameters %%%%%%%%%%%%%%
        function obj = set.Exposure(obj,value)
            if obj.camNumber == 1
                obj.srce.ExposureTime = value*1e-3;
            else
                obj.srce.Exposure = value;
            end
            obj.Exposure = value; % mS
            obj.ExposureTime = value*1e-3; % seg
        end
        
        function obj = set.Gain(obj,value)
            obj.srce.Gain = value;
            obj.Gain = value;
        end
        
        function obj = set.FrameRate(obj,value)
            obj.srce.FrameRate = value;
            obj.FrameRate = value;
        end
        
        function obj = set.ROI(obj,value)
            obj.vid.ROIPosition = value;
            obj.ROI = value;
        end
        
        
    end
end

