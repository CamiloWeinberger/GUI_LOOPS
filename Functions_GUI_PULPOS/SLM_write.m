function SLM_write(app, modalBasis)
            Bytes = app.depth/12;
            board_number = app.board_number;
            app.height = calllib('Blink_C_wrapper', 'Get_image_height', board_number);
            app.width = calllib('Blink_C_wrapper', 'Get_image_width', board_number);
            app.depth = calllib('Blink_C_wrapper', 'Get_image_depth', board_number); 
            height = app.height;
            width = app.width;
            depth = app.depth;
            wait_For_Trigger = app.wait_For_Trigger;
            OutputPulseImageFlip = app.OutputPulseImageFlip;
            OutputPulseImageRefresh = app.OutputPulseImageRefresh;
            flip_immediate = app.flip_immediate;
            timeout_ms = app.timeout_ms;
            modalBasis1 = modalBasis';
            calllib('Blink_C_wrapper', 'Write_image', board_number, modalBasis1(:), width*height, wait_For_Trigger, flip_immediate, OutputPulseImageFlip, OutputPulseImageRefresh, timeout_ms);
            calllib('Blink_C_wrapper', 'ImageWriteComplete', board_number, timeout_ms);
            
return