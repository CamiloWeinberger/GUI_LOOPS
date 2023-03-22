function app = Check_GigeCam(app)
            if app.diffCam ~= 0
                if app.camNumber == 1
                    v = videoinput('hamamatsu',1,'MONO16_2048x2048_FastMode');
                    v.FramesPerTrigger = 1;
                    v.TriggerRepeat = 1;
%                     triggerconfig(v, 'manual');
                    s = getselectedsource(v);
                    s.ExposureTime = 0.2;
                    app.AddCheckBox_2.Enable = 'on';
                elseif app.camNumber == 2
                    v = videoinput('gige', app.camNumber, 'Mono12');
                    s = v.Source;
                    s.Exposure = app.ExposureEditField.Value;
                    s.FrameRate = app.FrameRateEditField.Value;
                    s.Gain = app.GainEditField.Value;
                    v.FramesPerTrigger = inf;
                    s.Offset = 0;
                    s.PacketSize = 9000;
                    app.cameraMem = s;
                end
 
            app.v = v;
            app.s = s;
            end
        end