classdef UIDemoMode < matlab.apps.AppBase
% the publich properties
    properties (Access = public)
    UI                              matlab.ui.Figure
    Container                       matlab.ui.container.GridLayout
    demomode                        matlab.ui.control.StateButton
    % objects from other apps
    init_app
    serial_handler
    webcam_obj              
    infrared_obj
    multispectral_obj
    laser_obj

    demo
end

methods (Access = public)

    % Receive Serial Object from mainapp
    function receive_serial_handler(app,serial_handler_ext)
        app.serial_handler=serial_handler_ext;
        disp('demoButton_serial object received successfully')
    end

end
% private properties
methods (Access = private)

    % --- Executes on button press in demomode.
function demomode_Callback(app,event)

        % Set train speed
        if app.demomode.Value==0
            app.init_app.train.train_speed.Value = 0;
        else
            app.init_app.train.train_speed.Value = 9;
            app.init_app.train.train_dir_left.Value = 1;
        end
        train_speed_Callback(app.init_app.train, app);
        enable_serial(app.init_app, 'off');
    
        try
            if app.demomode.Value==0
                disp('demomode value is 0');
                app.init_app.serial.setDemoMode(0);
                % we need to config from infrared function 
                stop_infrared_Callback(app.snapshot_infrared, app);
    
                app.init_app.demo = false;
    
                app = enable_webcam(app, 'on');
                app = enable_laser(app, 'on');
                app = enable_infrared(app, 'on');
                app = enable_multispectral(app, 'on');
            else
                app.init_app.serial.setDemoMode(1);
                disp('demomode value is 1');
                live_infrared_Callback(handles.snapshot_infrared, [], handles);
                app = enable_webcam(app, 'off');
                app = enable_laser(app, 'off');
                app = enable_infrared(app, 'off');
                app = enable_multispectral(app, 'off');
    
                app.init_app.demo = true;
            end
        catch e
            warning('DemoMode exception: %s', getReport(e));
            waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
        end
    
        % Update handles structure
        enable_serial(app.init_app, 'on');

    end
end
% private properties
    methods (Access = public)
        
    % Receive INit Object with Cameras and Controls objects
        function receive_objects_from_init(app,init_app_ext)
            app.init_app=init_app_ext;
            app.webcam_obj=app.init_app.webcam_obj;              
            app.infrared_obj=app.init_app.infrared_obj;
            app.multispectral_obj=app.init_app.multispectral_obj;
            app.laser_obj=app.init_app.laser_obj;
            app.demo=app.init_app.demo;
            disp('demo flag received and the value is ')
            disp(app.demo)
        end
        
        function app = enable_webcam(app, value)
            if ~is_webcam(app.init_app) || app.demo
                return;
            end
        
            app.webcam_obj.LiveView.Enable=value;
            app.webcam_obj.StopView.Enable=value;
            app.webcam_obj.TakePic.Enable=value;
            app.webcam_obj.DetectPic.Enable=value;
        
            if is_serial_port(app.init_app)
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_laser(app, value)
            if ~is_laser(app.init_app) || app .demo
                return;
            end
        
            app.laser_obj.live_laser.Enable=value;
            app.laser_obj.stop_laser.Enable=value;
            app.laser_obj.capture_start.Enable=value;
            app.laser_obj.capture_stop.Enable=value;
            app.laser_obj.capture_calc.Enable=value;
            app.laser_obj.image_slider.Enable=value;
            app.laser_obj.cut_begin.Enable=value;
            app.laser_obj.cut_end.Enable=value;
        
            if is_serial_port(app.init_app)
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_multispectral(app, value)
            if ~is_laser(app.init_app) || app .demo
                return;
            end
        

            app.multispectral_obj.LiveView.Enable=value;
            app.multispectral_obj.StopView.Enable=value;
            app.multispectral_obj.TakePic.Enable=value;
        
            if is_serial_port(app.init_app)
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_infrared(app, value)
            if ~is_laser(app.init_app) || app .demo
                return;
            end
        
            app.infrared_obj.live_infrared.Enable=value;
            app.infrared_obj.stop_infrared.Enable=value;
            app.infrared_obj.snapshot_infrared.Enable=value;
        
            if is_serial_port(app.init_app)
                app.demo_app.demomode.Enable = value;
            end
        end
    end

    %public Methods
    methods (Access = public)

        %constructor
        function app= UIDemoMode(UI,parent, id)
            
            app.UI= UI;
            app.Container=uigridlayout(parent);
            app.Container.RowHeight = {40};
            app.Container.ColumnWidth = {'1x'};
            

            % Create demomode
            app.demomode = uibutton(app.Container, 'state');
            app.demomode.Enable = 'off';
            app.demomode.Text = 'Demo Modus';
            app.demomode.FontSize = 16;
            app.demomode.Layout.Row = 1;
            app.demomode.Layout.Column = 1;
            app.demomode.ValueChangedFcn = createCallbackFcn(app, @demomode_Callback, true);

      
             app.Container.Padding = [10 10 10 10];

        end  
    end
end
        