classdef UIInitialize < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        serial
        % *************

        battery
        train
        leds
        halo
        cameras_app

        % *********
        % demo app object

        demo_app
        % *****
        % the demo flag
        demo

        % *********
        % the cameras objects from UICameras. 
        webcam_obj              
        infrared_obj
        multispectral_obj
        laser_obj
        gigelist

    end
    
    % private properties
    properties (Access = public)
        
        connect_serial_port     matlab.ui.control.Button
        camera_init             matlab.ui.control.Button
        % object to access the paramerter.m 
        param
         % *********
        % the cameras objects from param class >>  videoinput classs
        webcam
        infrared
        multispectral   
        laser
        
    end
    properties (Access = private)
        check
    end
     methods

        function s = struct_app(app,obj)
            s = struct(obj);
        end
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
            delete(app.serial);
            fclose all;
            close all Force;
            instrreset;
            % reset_serial(app);
            delete(app);
            clear all;
        end

        function reset_serial (app)
            % disp("reset serial was called: ...")
            instrreset;
        end

    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        %  Controls Construcotr

        function app = UIInitialize(varargin)
        % set the superior window (uifigure)
            disp('constructor created')
            app.UI = varargin{1};
            
            % the demo flag is set to false 
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
            % ************************
            % Receive the Objects from UIControls line 70
            app.battery=    varargin{3}.UIBattery_Obj;
            app.train=      varargin{3}.UIRailway_Obj;
            app.leds=       varargin{3}.UILeds_Obj;
            app.halo=       varargin{3}.UIHalogenLamp_Obj;
            app.demo_app=   varargin{3}.UIDemoMode_Obj;
            app.cameras_app=varargin{3}.Cameras_Obj;

            % *****************************
            % Init the Cameras objects 4 Cameras 

            app.webcam_obj=app.cameras_app.QRCode;
            app.laser_obj=app.cameras_app.Laser;
            app.multispectral_obj=app.cameras_app.MultiSpectral;
            app.infrared_obj=app.cameras_app.InfraRed;

            % disp(varargin)
            app.UI.CloseRequestFcn = createCallbackFcn(app, @MainAppCloseRequest, true);
            
        end


    end



    methods(Access = public)
        
        function connect_serial_port_Callback(app , ~)

                app.connect_serial_port.Enable = 'off';
                fclose all ;
                % Initialize serial port
                if is_serial_port(app) == false
                    try
                        % app.serial = app.param.serial_port(@serial_callback);

                        app.serial = app.param.serial_port(app);
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

                    % *************************
                    % send the app to the Cameras

                    receive_init_from_UIInitialize(app.webcam_obj, app);
                    receive_init_from_UIInitialize(app.laser_obj, app);
                    receive_init_from_UIInitialize(app.multispectral_obj, app);
                    receive_init_from_UIInitialize(app.infrared_obj, app);


                else
                    % warn that connecting failed
                    waitfor(msgbox('Verbindung konnte nicht hergestellt werden.', 'Fehler', 'warn'));
                    app.connect_serial_port.Enable = 'on';
                end
            end

        function serial_callback(app, parameter,type)
            
            disp("type from serial init")
            disp(type)

                switch(type)

                    case 'prelap1'
                        if app.demo
                            if is_laser(app)
                                capture_start_Callback(app.laser_obj, [], app);
            
                                pause(12);
            
                                capture_stop_Callback(app.laser_obj, [], app);
            
                                capture_calc_Callback(app.laser_obj, [], app);
                            end
                        end
                    case 'lap1'
                    case 'prelap0'
                    case 'lap0'
                        if app.demo
                            %? Camera often crashes Matlab
                            if is_multispectral(app) && app.halo.halo0.Value ~= 1
                                snapshot_multispectral_Callback(app.multispectral_obj, [], app);
                            end
            
                            if is_webcam(app) && app.ledA.Value ~= 1
                                snapshot_webcam_Callback(app.webcam_obj, [], app);
            
                                qr_button_Callback(app.webcam_obj, [], app);
                            end
                        end
                    case 'halo'
                        if app.demo
                            %? Camera often crashes Matlab
                            if is_multispectral(app)
                                pause(0.2);
                                snapshot_multispectral_Callback(app.multispectral_obj, [], app);
                            end
                        end
                    case 'led'
                        if app.demo
                            if is_webcam(app)
                                snapshot_webcam_Callback(app.webcam_obj, [], app);
            
                                qr_button_Callback(app.webcam_obj, [], app);
                            end
                        end
                    case 'bat'
                        app.battery.battery_label.Text = sprintf('Akku: %s', parameter);
                    otherwise
                        error('Unknown SerialPort Callback "%s".', type);
                end

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

        function camera_init_Callback(app,~)

            app.camera_init.Enable='off';

            all_success = true;
            if ~is_webcam(app)
                try
                    app.webcam = app.param.camera_webcam();
                    enable_webcam(app, 'on');
                    disp('success to activate the cameras')
                catch e
                    all_success = false;
                    warning('Exception in camera_webcam(): %s', getReport(e));
                end
            end

            % this options should be disabled to test at home

            % make gigelist to speedup the init process

            % if isfield(app, 'gigelist') == false || istable(app.gigelist) == false
            %     try
            %         app.gigelist = gigecamlist(); % speed up gigecam initialization
            %     catch e
            %         all_success = false;
            %         warning('Exception in gigecamlist(): %s', getReport(e));
            %     end
            % end


            % if ~is_laser(app)
            %     try
            %         app.laser = app.param.camera_laser();
            %         enable_laser(app, 'on');
            %     catch e
            %         all_success = false;
            %         warning('Exception in camera_laser(): %s', getReport(e));
            %     end
            % end

            % if ~is_infrared(app)
            %     try
            %         app.infrared = app.param.camera_infrared(app.gigelist);
            %         enable_infrared(app, 'on');
            %     catch e
            %         all_success = false;
            %         warning('Exception in camera_infrared(): %s', getReport(e));
            %     end
            % end

            % if ~is_multispectral(app)
            %     try
            %         app.multispectral = app.param.camera_multispectral(app.gigelist);
            %         enable_multispectral(app, 'on');
            %     catch e
            %         all_success = false;
            %         warning('Exception in camera_multispectral(): %s', getReport(e));
            %     end
            % end

            % Set preview data to native camera bit depth (default is 8 bit)
            imaqmex('feature', '-previewFullBitDepth', true);

            if all_success == false
                app.camera_init.Enable = 'on';
            end
            

        end

        % the Enables ...

        function app = enable_webcam(app, value)
            if ~is_webcam(app) || app.demo

                disp('is not webcame');
                disp(app.demo);

                return;
            end
            disp('is webcame');
            app.webcam_obj.LiveView.Enable=value;
            app.webcam_obj.StopView.Enable=value;
            app.webcam_obj.TakePic.Enable=value;
            app.webcam_obj.DetectPic.Enable=value;
        
            if is_serial_port(app)
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_laser(app, value)
            if ~is_laser(app) || app .demo
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
        
            if is_serial_port(app)
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_multispectral(app, value)
            if ~is_multispectral(app) || app .demo
                return;
            end
        

            app.multispectral_obj.LiveView.Enable=value;
            app.multispectral_obj.StopView.Enable=value;
            app.multispectral_obj.TakePic.Enable=value;
        
            if is_serial_port(app)
                app.demo_app.demomode.Enable = value;
            end
        end

        function app  = enable_infrared(app, value)
            if ~is_infrared(app) || app .demo
                return;
            end
            app.infrared_obj.live_infrared.Enable=value;
            app.infrared_obj.stop_infrared.Enable=value;
            app.infrared_obj.snapshot_infrared.Enable=value;
        
            if is_serial_port(app)
                app.demo_app.demomode.Enable = value;
            end
        end
        function enabled = is_serial_port(app)
            app.check= any(strcmp(properties(app), 'serial'));
            if(app.check == 1 )
                 enabled= isa(app.serial, 'class_serial_port');
                 disp("success to detect serial");
            else
                disp("failed to detect serial object");
            end
            
        end

        function enabled = is_webcam(app)
            % app.check = struct(app);

            enabled = isfield(app, 'webcam') && isa(app.webcam, 'class_videoinput');
            % disp (app)
            if ~(enabled)
                disp("failed to detect webcam object");
            else
                disp("success to detet webcam");
            end

        end
        
        function enabled = is_laser(app)
            app.check = struct(app);
            enabled = isfield(app.check, 'laser') && isa(app.laser, 'class_videoinput');
        end
        
        function enabled = is_infrared(app)
            app.check = struct(app);
            enabled = isfield(app.check, 'infrared') && isa(app.infrared, 'class_gigecam');
        end
        
        function enabled = is_multispectral(app)
            app.check = struct(app);
            enabled = isfield(app.check, 'multispectral') && isa(app.multispectral, 'class_gigecam');
        end
        % function test_callback(app, parameter,type)
        %     disp("type from test")
        %     disp(type)
        %     disp("parameter from test")
        %     disp(parameter)
        % end

    end

end
