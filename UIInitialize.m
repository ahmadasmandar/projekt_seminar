classdef UIInitialize < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        serial
        battery
        train
        leds
        halo
        demo_app
        demo
        webcam_obj              
        infrared_obj
        multispectral_obj
        laser_obj
        cameras_app
    end
    
    % private properties
    properties (Access = private)
        
        connect_serial_port     matlab.ui.control.Button
        camera_init             matlab.ui.control.Button
 
        param
        webcam
        infrared
        multispectral
        laser
        
    end
    methods (Access = private)
        % Close request function: UIFigure
        function MainAppCloseRequest(app, event)
            % Delete both apps
            delete(app.battery);
            delete(app.train);
            delete(app.leds);
            delete(app.halo);
            delete(app.demo_app);
            delete(app);
            fclose all;
            close all Force;
        end
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        %  Controls Construcotr
        % function app = UIInitialize(UI, parent,battery,train_par,leds,halo,demo_par)
        function app = UIInitialize(varargin)
        % set the superior window (uifigure)
            disp('constructor created')
            if nargin>5
                disp('first constructor created')
                % app.UI = UI;
                app.UI = varargin{1};
                app.demo=false;
                app.param=parameter();
                % create the main layout with the given element as parent
                app.Container = uigridlayout(varargin{2});

                % make a grid layour with 7 rows and 4 columns
                app.Container.RowHeight = {40, 40};
                app.Container.ColumnWidth = {'1x'};
                % button to com_port
                app.connect_serial_port = uibutton(app.Container);
                app.connect_serial_port.Text = "COM-Port verbinden";
                app.connect_serial_port.FontSize = 16;
                app.connect_serial_port.Layout.Row = 1;
                app.connect_serial_port.Layout.Column = 1;
                app.connect_serial_port.ButtonPushedFcn =createCallbackFcn(app,@connect_serial_port_Callback,true);

                % button to initilize the cameras
                app.camera_init = uibutton(app.Container);
                app.camera_init.Text = "Kameras initialisieren";
                app.camera_init.FontSize = 16;
                app.camera_init.Layout.Row = 2;
                app.camera_init.Layout.Column = 1;
                app.camera_init.ButtonPushedFcn = createCallbackFcn(app, @camera_init_Callback, true);
                
                app.Container.Padding = [10 10 10 10];

                app.battery=varargin{3};
                app.train=varargin{4};
                app.leds=varargin{5};
                app.halo=varargin{6};
                app.demo_app=varargin{7};
                app.cameras_app=varargin{8};
                app.webcam_obj=app.cameras_app.Component1;
                app.laser_obj=app.cameras_app.Component2;
                app.multispectral_obj=app.cameras_app.Component3;
                app.infrared_obj=app.cameras_app.Component4;
                % disp(varargin)
                app.UI.CloseRequestFcn = createCallbackFcn(app, @MainAppCloseRequest, true);
                
            
            elseif nargin<5 && nargin>0

                disp('second constructor created')
                % the Names refer to the ordet not to the function of name
                app.webcam_obj=varargin{1};
                app.laser_obj=varargin{2};
                app.multispectral_obj=varargin{3};
                app.infrared_obj=varargin{4};
                % disp(varargin)

            end

        end


    end



    methods(Access = public)
        
        function connect_serial_port_Callback(app,event)

                % app.cameras_app.Component1.LiveView.Enable='on';

                app.connect_serial_port.Enable = 'off';
                fclose all ;
                % Initialize serial port
                if is_serial_port(app) == false
                    try
                        app.serial = app.param.serial_port({@serial_callback, app});
                    catch e
                        warning('Exception in camera_webcam(): %s', getReport(e));
                    end
                end
            
                % connect
                success = false;
                try
                    for c=1:5
                            success = app.serial.connect();
                            if success== true
                                break;
                            end
                            pause(1)
                    end
                catch e
                    warning('Exception in serial.connect: %s', getReport(e));
                end
            
                if success == true
                    enable_serial(app, 'on');
                    % send the Serial object to all other app
                    receive_serial_handler(app.leds,app.serial);
                    receive_serial_handler(app.train,app.serial);
                    receive_serial_handler(app.halo,app.serial);
                    % ===== to the demo for test 
                    receive_serial_handler(app.demo_app,app);
                    % send the Whole app to demo_app
                    receive_objects_from_init(app.demo_app, app)

                else
                    % warn that connecting failed
                    waitfor(msgbox('Verbindung konnte nicht hergestellt werden.', 'Fehler', 'warn'));
                    app.connect_serial_port.Enable = 'on';
                end
            end

        function enabled = is_serial_port(app)
            enabled = isfield(app, 'serial') && isa(app.serial, 'class_serial_port');
        end

        function enabled = is_webcam(app)
            enabled = isfield(app, 'webcam') && isa(app.webcam, 'class_videoinput');
        end
        
        function enabled = is_laser(app)
            enabled = isfield(app, 'laser') && isa(app.laser, 'class_videoinput');
        end
        
        function enabled = is_infrared(app)
            enabled = isfield(app, 'infrared') && isa(app.infrared, 'class_videoinput');
        end
        
        function enabled = is_multispectral(app)
            enabled = isfield(app, 'multispectral') && isa(app.multispectral, 'class_gigecam');
        end

        function serial_callback(app, type, parameter)
            
                switch(type)
                        % need to be configured after finishing cams
                    case 'prelap1'
                        if app.demo
                            if is_laser(app)
                                capture_start_Callback(app.laser_obj, [], app);
                                app = guidata(happect);
            
                                pause(12);
            
                                capture_stop_Callback(app.laser_obj, [], app);
                                app = guidata(happect);
            
                                capture_calc_Callback(app.laser_obj, [], app);
                                app = guidata(happect);
                            end
                        end
                    case 'lap1'
                    case 'prelap0'
                    case 'lap0'
                        if app.demo
                            % Camera often crashes Matlab
                            if is_multispectral(app) && app.halo.halo0.Value ~= 1
                                snapshot_multispectral_Callback(app.multispectral_obj, [], app);
                                app = guidata(happect);
                            end
            
                            if is_webcam(app) && app.ledA.Value ~= 1
                                snapshot_webcam_Callback(app.webcam_obj, [], app);
                                app = guidata(happect);
            
                                qr_button_Callback(app.webcam_obj, [], app);
                                app = guidata(happect);
                            end
                        end
                    case 'halo'
                        if app.demo
                            % Camera often crashes Matlab
                            if is_multispectral(app)
                                pause(0.2);
                                snapshot_multispectral_Callback(app.multispectral_obj, [], app);
                                app = guidata(happect);
                            end
                        end
                    case 'led'
                        if app.demo
                            if is_webcam(app)
                                snapshot_webcam_Callback(app.webcam_obj, [], app);
                                app = guidata(happect);
            
                                qr_button_Callback(app.webcam_obj, [], app);
                                app = guidata(happect);
                            end
                        end
                    case 'bat'
                        app.battery_label.String = sprintf('Akku: %s', parameter);
                    otherwise
                        error('Unknown SerialPort Callback "%s".', type);
                end
            
                % Update app structure
        end

        function app = enable_serial(app, value)
            if ~app.demo
                app.train.train_dir_left.Enable = value;
                app.train.train_dir_right.Enable = value;
                app.train.train_speed.Enable = value;
                app.train.text12.Enable = value;
                app.train.train_speed_label.Enable = value;
        
                app.leds.led0.Enable = value;
                app.leds.led1.Enable = value;
                app.leds.led2.Enable = value;
                app.leds.led3.Enable = value;
                app.leds.ledA.Enable = value;
        
                app.halo.halo0.Enable = value;
                app.halo.halo1.Enable = value;
                app.halo.haloA.Enable = value;
            end
        
            app.demo_app.demomode.Enable = value;
            
        end

        function camera_init_Callback(app,event)

            app.camera_init.Enable='off';

            all_success = true;

            if isfield(app, 'gigelist') == false || istable(app.gigelist) == false
                try
                    app.gigelist = gigecamlist(); % speed up gigecam initialization
                catch e
                    all_success = false;
                    warning('Exception in gigecamlist(): %s', getReport(e));
                end
            end

            if ~is_webcam(app)
                try
                    app.webcam = app.param.camera_webcam();
                    enable_webcam(app, 'on');
                catch e
                    all_success = false;
                    warning('Exception in camera_webcam(): %s', getReport(e));
                end
            end

            if ~is_laser(app)
                try
                    app.laser = app.param.camera_laser();
                    enable_laser(app, 'on');
                catch e
                    all_success = false;
                    warning('Exception in camera_laser(): %s', getReport(e));
                end
            end

            if ~is_infrared(app)
                try
                    app.infrared = app.param.camera_infrared();
                    enable_infrared(app, 'on');
                catch e
                    all_success = false;
                    warning('Exception in camera_infrared(): %s', getReport(e));
                end
            end

            if ~is_multispectral(app)
                try
                    app.multispectral = app.param.camera_multispectral(app.gigelist);
                    enable_multispectral(app, 'on');
                catch e
                    all_success = false;
                    warning('Exception in camera_multispectral(): %s', getReport(e));
                end
            end

            % Set preview data to native camera bit depth (default is 8 bit)
            imaqmex('feature', '-previewFullBitDepth', true);

            if all_success == false
                app.camera_init.Enable = 'on';
            end


        end

        function app = enable_webcam(app, value)
            if ~is_webcam(app) || app.demo
                return;
            end
        
            app.webcam_obj.LiveView.Enable=value;
            app.webcam_obj.StopView.Enable=value;
            app.webcam_obj.TakePic.Enable=value;
            app.webcam_obj.DetectPic.Enable=value;
        
            if is_serial_port(app)
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_laser(app, value)
            if ~is_laser(app ) || app .demo
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
        
            if is_serial_port(app )
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_multispectral(app, value)
            if ~is_laser(app ) || app .demo
                return;
            end
        

            app.multispectral_obj.LiveView.Enable=value;
            app.multispectral_obj.StopView.Enable=value;
            app.multispectral_obj.TakePic.Enable=value;
        
            if is_serial_port(app )
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_infrared(app, value)
            if ~is_laser(app ) || app .demo
                return;
            end
        
            app.infrared_obj.live_infrared.Enable=value;
            app.infrared_obj.stop_infrared.Enable=value;
            app.infrared_obj.snapshot_infrared.Enable=value;
        
            if is_serial_port(app )
                app.demo_app.demomode.Enable = value;
            end
        end

    end

end
