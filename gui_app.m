classdef gui_app < matlab.apps.AppBase
    % public properties

    % Properties that correspond to app components
    properties (Access = private)
        LegoDemo                matlab.ui.Figure
        camview_webcam          matlab.ui.control.UIAxes
        camview_laser           matlab.ui.control.UIAxes
        camview_multispectral   matlab.ui.control.UIAxes
        camview_infrared        matlab.ui.control.UIAxes
        text2                   matlab.ui.control.Label
        text3                   matlab.ui.control.Label
        text4                   matlab.ui.control.Label
        text5                   matlab.ui.control.Label
        live_webcam             matlab.ui.control.Button
        live_laser              matlab.ui.control.Button
        live_multispectral      matlab.ui.control.Button
        live_infrared           matlab.ui.control.Button
        stop_webcam             matlab.ui.control.Button
        snapshot_webcam         matlab.ui.control.Button
        stop_laser              matlab.ui.control.Button
        stop_multispectral      matlab.ui.control.Button
        snapshot_multispectral  matlab.ui.control.Button
        stop_infrared           matlab.ui.control.Button
        snapshot_infrared       matlab.ui.control.Button
        battery_label           matlab.ui.control.Label
        uibuttongroup2          matlab.ui.container.ButtonGroup
        train_dir_left          matlab.ui.control.RadioButton
        train_dir_right         matlab.ui.control.RadioButton
        train_speed             matlab.ui.control.Slider
        train_speed_label       matlab.ui.control.Label
        text12                  matlab.ui.control.Label
        uibuttongroup3          matlab.ui.container.ButtonGroup
        halo1                   matlab.ui.control.RadioButton
        halo0                   matlab.ui.control.RadioButton
        haloA                   matlab.ui.control.RadioButton
        uibuttongroup4          matlab.ui.container.ButtonGroup
        led0                    matlab.ui.control.RadioButton
        led1                    matlab.ui.control.RadioButton
        led2                    matlab.ui.control.RadioButton
        led3                    matlab.ui.control.RadioButton
        ledA                    matlab.ui.control.RadioButton
        qr_text                 matlab.ui.control.Label
        text11                  matlab.ui.control.Label
        qr_button               matlab.ui.control.Button
        capture_start           matlab.ui.control.Button
        capture_calc            matlab.ui.control.Button
        camera_init             matlab.ui.control.Button
        image_slider            matlab.ui.control.Slider
        cut_begin               matlab.ui.control.Button
        cut_end                 matlab.ui.control.Button
        capture_stop            matlab.ui.control.Button
        demomode                matlab.ui.control.StateButton
        img_count               matlab.ui.control.Label
        connect_serial_port     matlab.ui.control.Button
    end

    
    methods (Access = public)
        function handle = config_laser_start(app, handle, demomode)
                triggerconfig(handle, 'hardware', 'DeviceSpecific', 'DeviceSpecific');
            
                % remove all images in cache
                if handle.FramesAvailable > 0
                    handle.FramesPerTrigger = handle.FramesAvailable;
                    getdata(handle);
                end
            
                if demomode
                    handle.FramesPerTrigger = 500;
                else
                    handle.FramesPerTrigger = 500;
                end
            
                src = getselectedsource(handle);
                src.TriggerMode = 'On';
            
                start(handle);
        end
        
        function handles = enable_infrared(app, handles, value)
                if ~is_infrared(handles) || app.demo
                    return;
                end
            
                app.live_infrared.Enable = value;
                app.stop_infrared.Enable = value;
                app.snapshot_infrared.Enable = value;
            
                if is_serial_port(handles)
                    app.demomode.Enable = value;
                end
        end
        
        function handles = enable_laser(app, handles, value)
                if ~is_laser(handles) || app.demo
                    return;
                end
            
                app.live_laser.Enable = value;
                app.stop_laser.Enable = value;
                app.capture_start.Enable = value;
                app.capture_stop.Enable = value;
                app.capture_calc.Enable = value;
            
                if is_serial_port(handles)
                    app.demomode.Enable = value;
                end
        end
        
        function handles = enable_multispectral(app, handles, value)
                if ~is_multispectral(handles) || app.demo
                    return;
                end
            
                app.live_multispectral.Enable = value;
                app.stop_multispectral.Enable = value;
                app.snapshot_multispectral.Enable = value;
            
                if is_serial_port(handles)
                    app.demomode.Enable = value;
                end
        end
        
        function handles = enable_serial(app, handles, value)
                if ~app.demo
                    app.train_dir_left.Enable = value;
                    app.train_dir_right.Enable = value;
                    app.train_speed.Enable = value;
            
                    app.led0.Enable = value;
                    app.led1.Enable = value;
                    app.led2.Enable = value;
                    app.led3.Enable = value;
                    app.ledA.Enable = value;
            
                    app.halo0.Enable = value;
                    app.halo1.Enable = value;
                    app.haloA.Enable = value;
                end
            
                app.demomode.Enable = value;
        end
        
        function handles = enable_webcam(app, handles, value)
                if ~is_webcam(handles) || app.demo
                    return;
                end
            
                app.live_webcam.Enable = value;
                app.stop_webcam.Enable = value;
                app.snapshot_webcam.Enable = value;
                app.qr_button.Enable = value;
            
                if is_serial_port(handles)
                    app.demomode.Enable = value;
                end
        end
        
        function [handle, images] = get_images(app, handle)
                stop(handle);
                count = handle.FramesAvailable;
            
                handle.FramesPerTrigger = count;
                images = getdata(handle);
            
                triggerconfig(handle, 'manual');
            
                src = getselectedsource(handle);
                src.TriggerMode = 'Off';
                handle.FramesPerTrigger = 1;
        end
        
        function img = infrared_adjust(app, img)
                img = normalize_adjust_255(img);
                img = imrotate(img, 90);
        end
        
        function enabled = is_infrared(app, handles)
                enabled = isfield(handles, 'infrared') && isa(app.infrared, 'class_videoinput');
        end
        
        function enabled = is_laser(app, handles)
                enabled = isfield(handles, 'laser') && isa(app.laser, 'class_videoinput');
        end
        
        function enabled = is_multispectral(app, handles)
                enabled = isfield(handles, 'multispectral') && isa(app.multispectral, 'class_gigecam');
        end
        
        function enabled = is_serial_port(app, handles)
                enabled = isfield(handles, 'serial') && isa(app.serial, 'class_serial_port');
        end
        
        function enabled = is_webcam(app, handles)
                enabled = isfield(handles, 'webcam') && isa(app.webcam, 'class_videoinput');
        end
        
        function img = normalize_adjust(app, img)
                img = double(img);
                minv = min(img(:));
                maxv = max(img(:));
                diff = maxv - minv;
                img = (img - minv) ./ diff;
        end
        
        function img = normalize_adjust_255(app, img)
                img = normalize_adjust(img) .* 255;
        end
        
        function preview_gray(app, ~, event, himage)
                himage.CData = event.Data(:,:,1);
        end
        
        function preview_infrared_adjust(app, ~, event, himage)
                img = (normalize_adjust(event.Data) .* 64);
                img = imrotate(img, 90);
                himage.CData = img;
        end
        
        function preview_normalize_adjust_255(app, ~, event, himage)
                himage.CData = normalize_adjust_255(event.Data);
        end
        
        function serial_callback(app, type, parameter, hObject)
            % hObject   handle to figure
            % type      type of the message as string
            % parameter depends on the type
            %           if type is 'bat': train battery charging state
                handles = guidata(hObject);
            
                switch(type)
                    case 'prelap1'
                        if app.demo
                            if is_laser(handles)
                                capture_start_Callback(app.capture_start, [], handles);
                                handles = guidata(hObject);
            
                                pause(12);
            
                                capture_stop_Callback(app.capture_stop, [], handles);
                                handles = guidata(hObject);
            
                                capture_calc_Callback(app.capture_calc, [], handles);
                                handles = guidata(hObject);
                            end
                        end
                    case 'lap1'
                    case 'prelap0'
                    case 'lap0'
                        if app.demo
                            % Camera often crashes Matlab
                            if is_multispectral(handles) && app.haloA.Value ~= 1
                                snapshot_multispectral_Callback(app.snapshot_multispectral, [], handles);
                                handles = guidata(hObject);
                            end
            
                            if is_webcam(handles) && app.ledA.Value ~= 1
                                snapshot_webcam_Callback(app.snapshot_webcam, [], handles);
                                handles = guidata(hObject);
            
                                qr_button_Callback(app.qr_button, [], handles);
                                handles = guidata(hObject);
                            end
                        end
                    case 'halo'
                        if app.demo
                            % Camera often crashes Matlab
                            if is_multispectral(handles)
                                pause(0.2);
                                snapshot_multispectral_Callback(app.snapshot_multispectral, [], handles);
                                handles = guidata(hObject);
                            end
                        end
                    case 'led'
                        if app.demo
                            if is_webcam(handles)
                                snapshot_webcam_Callback(app.snapshot_webcam, [], handles);
                                handles = guidata(hObject);
            
                                qr_button_Callback(app.qr_button, [], handles);
                                handles = guidata(hObject);
                            end
                        end
                    case 'bat'
                        app.battery_label.String = sprintf('Akku: %s', parameter);
                    otherwise
                        error('Unknown SerialPort Callback "%s".', type);
                end
            
                % Update handles structure
                guidata(hObject, handles);
        end
        
        function camview = set_camview_default(app, camview)
                camview.XTick = [];
                camview.YTick = [];
                camview.CLim = [0, 255];
                camview.CLimMode = 'manual';
                camview.DataAspectRatio = [1, 1, 1];
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function gui_OpeningFcn(app)
%             % This function has no output args, see OutputFcn.
%             % hObject    handle to figure
%             % eventdata  reserved - to be defined in a future version of MATLAB
%             % handles    structure with handles and user data (see GUIDATA)
%             % varargin   command line arguments to gui (see VARARGIN)
%             
%                 % Choose default command line output for gui
%                 app.output = hObject;
%             
%                 % load java files for QR-Code decoding
%                 javaaddpath('core-1.7.jar')
%                 javaaddpath('javase-1.7.jar')
%             
%                 % Load parameter functions
%                 app.param = parameter();
%             
%                 % Set axes palette
%                 colormap(app.camview_infrared, 'jet');
%             
%                 % load images to axes
%                 img = imread('QRCode.png');
%                 image(img, 'parent', app.camview_webcam);
%                 app.camview_webcam = set_camview_default(app.camview_webcam);
%                 img = imread('laser.png');
%                 image(img, 'parent', app.camview_laser);
%                 app.camview_laser = set_camview_default(app.camview_laser);
%                 img = imread('multispectral.jpg');
%                 image(img, 'parent', app.camview_multispectral);
%                 app.camview_multispectral = set_camview_default(app.camview_multispectral);
%                 img = imread('infrared.jpg');
%                 image(img, 'parent', app.camview_infrared);
%                 app.camview_infrared = set_camview_default(app.camview_infrared);
%             
%                 % no laser images captured at start
%                 app.laser_images = false;
%             
%                 % disable demo mode at start
%                 app.demo = false;
%             
%                 % Update handles structure
%                 guidata(hObject, handles);
%             
%                 % UIWAIT makes gui wait for user response (see UIRESUME)
%                 % uiwait(app.LegoDemo);
        end

        % Close request function: LegoDemo
        function LegoDemo_CloseRequestFcn(app, event)
            % hObject    handle to LegoDemo (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hint: delete(hObject) closes the figure
                if is_serial_port(handles)
                    delete(app.serial);
                end
            
                if is_webcam(handles)
                    delete(app.webcam);
                end
            
                if is_laser(handles)
                    delete(app.laser);
                end
            
                if is_infrared(handles)
                    delete(app.infrared);
                end
            
                if is_multispectral(handles)
                    delete(app.multispectral);
                end
            
                delete(hObject);
        end

        % Button pushed function: camera_init
        function camera_init_Callback(app, event)
            % hObject    handle to camera_init (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                app.camera_init.Enable = 'off';
            
                % Update handles structure
                guidata(hObject, handles);
                drawnow();
            
                all_success = true;
            
                if isfield(handles, 'gigelist') == false || istable(app.gigelist) == false
                    try
                        app.gigelist = gigecamlist(); % speed up gigecam initialization
                    catch e
                        all_success = false;
                        warning('Exception in gigecamlist(): %s', getReport(e));
                    end
                end
            
                if ~is_webcam(handles)
                    try
                        app.webcam = app.param.camera_webcam();
                        handles = enable_webcam(handles, 'on');
                    catch e
                        all_success = false;
                        warning('Exception in camera_webcam(): %s', getReport(e));
                    end
                end
            
                if ~is_laser(handles)
                    try
                        app.laser = app.param.camera_laser();
                        handles = enable_laser(handles, 'on');
                    catch e
                        all_success = false;
                        warning('Exception in camera_laser(): %s', getReport(e));
                    end
                end
            
                if ~is_infrared(handles)
                    try
                        app.infrared = app.param.camera_infrared();
                        handles = enable_infrared(handles, 'on');
                    catch e
                        all_success = false;
                        warning('Exception in camera_infrared(): %s', getReport(e));
                    end
                end
            
                if ~is_multispectral(handles)
                    try
                        app.multispectral = app.param.camera_multispectral(app.gigelist);
                        handles = enable_multispectral(handles, 'on');
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
            
                % Update handles structure
                guidata(hObject, handles);
        end

        % Button pushed function: capture_calc
        function capture_calc_Callback(app, event)
            % hObject    handle to capture_calc (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_laser(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                if ~islogical(app.laser_images)
                    n = size(app.laser_images, 4);
                else
                    n = 0;
                end
            
                if n < 10
                    if ~app.demo
                        waitfor(msgbox('Zu wenige Bilder für 3D-Bild Berechnung.', 'Fehler', 'warn'));
                    end
            
                    handles = enable_laser(handles, 'on');
                    guidata(hObject, handles);
                    return;
                end
            
                try
                    Threshold = 100;             % Gray value threshold for backgound extraction
                    % pre calibatrion data - use the program laserschnittverfahren3 to calibrate your system
                    ps = 0.054381;              % Pixel relative size (mm/pixel)
                    alpha = 13.844982;          % Triangulation angle in (Â°)
                    LinCoef = 0;                % Linear coefficient 105
                    AngCoef = 0;                % Angular coefficient
                    data3d = get3D(app.laser_images, Threshold, ps, alpha, LinCoef, AngCoef);
            
                    app.img_count.String = sprintf('Bilder: %d', n);
            
                    colormap(app.camview_laser, 'jet');
                    mesh(data3d, 'parent', app.camview_laser);
                    app.camview_laser.YTick = [];
                    app.camview_laser.XTick = [];
                    app.camview_laser.ZTick = [];
                    min3d = min(min(data3d));
                    app.camview_laser.DataAspectRatio = [15, 4.5, 1.5];
                    app.camview_laser.CLim = [min3d, 0];
                    app.camview_laser.CLimMode = 'manual';
                    rotate3d(app.camview_laser, 'on');
                    guidata(hObject, handles);
                    drawnow();
                catch e
                    warning('3D calc exception: %s', getReport(e));
                    waitfor(msgbox('Interner Fehler während der 3D-Bild Berechnung.', 'Fehler', 'warn'));
                end
            
                handles = enable_laser(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: capture_start
        function capture_start_Callback(app, event)
            % hObject    handle to capture_start (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_laser(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                if app.laser.stoppreview() == false || app.laser.config({@config_laser_start, app.demo}) == false
                    waitfor(msgbox('Interner Fehler während der Laserlinienbild-Aufnahmekonfiguration.', 'Fehler', 'warn'));
            
                    handles = enable_laser(handles, 'on');
                    guidata(hObject, handles);
                    return;
                end
            
                if ~app.demo
                    app.capture_stop.Enable = 'on';
                end
            
                % Update handles structure
                guidata(hObject, handles);
        end

        % Button pushed function: capture_stop
        function capture_stop_Callback(app, event)
            % hObject    handle to capture_stop (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_laser(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                [success, images] = app.laser.config(@get_images);
                if success && ~islogical(images)
                    n = size(images, 4);
                    app.laser_images = images;
            
                    colormap(app.camview_laser, 'gray');
                    app.image_slider.Enable = 'on';
                    app.image_slider.Min = 1;
                    app.image_slider.Max = n;
                    app.image_slider.SliderStep = [1 / (n - 1), 1 / (n - 1)];
                    for i = 1:n
                        if app.demo && mod(i, 5) ~= 0
                            continue;
                        end
                        capture_img = app.laser_images(:, :, 1, i);
                        image(capture_img, 'parent', app.camview_laser);
                        app.camview_laser = set_camview_default(app.camview_laser);
                        app.image_slider.Value = i;
                        app.img_count.String = sprintf('%d von %d', i, n);
                        guidata(hObject, handles);
                        drawnow();
                        pause(0.001);
                    end
            
                    app.cut_begin.Enable = 'on';
                    app.cut_end.Enable = 'on';
                else
                    n = 0;
                    app.laser_images = false;
                    app.image_slider.Enable = 'off';
                    app.cut_begin.Enable = 'off';
                    app.cut_end.Enable = 'off';
                end
            
                app.img_count.String = sprintf('Bilder: %d', n);
            
                handles = enable_laser(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: connect_serial_port
        function connect_serial_port_Callback(app, event)
            % hObject    handle to connect_serial_port (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                app.connect_serial_port.Enable = 'off';
            
                % Update handles structure
                guidata(hObject, handles);
                drawnow();
            
                % Initialize serial port
                if is_serial_port(handles) == false
                    try
                        app.serial = app.param.serial_port({@serial_callback, hObject});
                    catch e
                        warning('Exception in camera_webcam(): %s', getReport(e));
                    end
                end
            
                % connect
                success = false;
                try
                    success = app.serial.connect();
                catch e
                    warning('Exception in serial.connect: %s', getReport(e));
                end
            
                if success == true
                    handles = enable_serial(handles, 'on');
                else
                    % warn that connecting failed
                    waitfor(msgbox('Verbindung konnte nicht hergestellt werden.', 'Fehler', 'warn'));
                    app.connect_serial_port.Enable = 'on';
                end
            
                % Update handles structure
                guidata(hObject, handles);
        end

        % Button pushed function: cut_begin
        function cut_begin_Callback(app, event)
            % hObject    handle to cut_begin (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                n = size(app.laser_images, 4);
                first = app.image_slider.Value;
                app.laser_images = app.laser_images(:, :, 1, first:n);
                n = size(app.laser_images, 4);
            
                app.image_slider.Min = 1;
                app.image_slider.Max = n;
                if n > 1
                    step = 1 / (n - 1);
                else
                    step = 1;
                end
                app.image_slider.Value = 1;
                app.image_slider.SliderStep = [step, step];
                app.image_slider.Value = 1;
                app.img_count.String = sprintf('%d von %d', app.image_slider.Value, n);
            
                guidata(hObject, handles);
        end

        % Button pushed function: cut_end
        function cut_end_Callback(app, event)
            % hObject    handle to cut_end (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                last = app.image_slider.Value;
                app.laser_images = app.laser_images(:, :, 1, 1:last);
                n = size(app.laser_images, 4);
            
                app.image_slider.Min = 1;
                app.image_slider.Max = n;
                if n > 1
                    step = 1 / (n - 1);
                else
                    step = 1;
                end
                app.image_slider.Value = 1;
                app.image_slider.SliderStep = [step, step];
                app.image_slider.Value = n;
                app.img_count.String = sprintf('%d von %d', app.image_slider.Value, n);
            
                guidata(hObject, handles);
        end

        % Value changed function: demomode
        function demomode_Callback(app, event)
            % hObject    handle to demomode (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                % Set train speed
                if app.demomode.Value == 0
                    app.train_speed.Value = 0;
                else
                    app.train_speed.Value = 9;
                    app.train_dir_left.Value = 1;
                end
                train_speed_Callback(app.train_speed, [], handles);
                handles = guidata(hObject);
            
                handles = enable_serial(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                try
                    if app.demomode.Value == 0
                        app.serial.setDemoMode(0);
            
                        stop_infrared_Callback(app.snapshot_infrared, [], handles);
                        handles = guidata(hObject);
            
                        app.demo = false;
            
                        handles = enable_webcam(handles, 'on');
                        handles = enable_laser(handles, 'on');
                        handles = enable_infrared(handles, 'on');
                        handles = enable_multispectral(handles, 'on');
                    else
                        app.serial.setDemoMode(1);
            
                        live_infrared_Callback(app.snapshot_infrared, [], handles);
                        handles = guidata(hObject);
            
                        handles = enable_webcam(handles, 'off');
                        handles = enable_laser(handles, 'off');
                        handles = enable_infrared(handles, 'off');
                        handles = enable_multispectral(handles, 'off');
            
                        app.demo = true;
                    end
                catch e
                    warning('DemoMode exception: %s', getReport(e));
                    waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
                end
            
                % Update handles structure
                handles = enable_serial(handles, 'on');
                guidata(hObject, handles);
        end

        % Value changed function: image_slider
        function image_slider_Callback(app, event)
            % hObject    handle to image_slider (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'Value') returns position of slider
            %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
                try
                    val = round(hObject.Value);
                    hObject.Value = val;
            
                    if ~islogical(app.laser_images)
                        app.img_count.String = sprintf('%d von %d', val, size(app.laser_images, 4));
            
                        colormap(app.camview_laser, 'gray');
                        image(app.laser_images(:, :, 1, val), 'parent', app.camview_laser);
                        app.camview_laser = set_camview_default(app.camview_laser);
                    end
                catch e
                    warning('Laser silder exception: %s', getReport(e));
                end
            
                guidata(hObject, handles);
        end

        % Button pushed function: live_infrared
        function live_infrared_Callback(app, event)
            % hObject    handle to live_infrared (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_infrared(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                if ~app.infrared.preview(@preview_infrared_adjust, app.camview_infrared, true)
                    waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
                end
            
                handles = enable_infrared(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: live_laser
        function live_laser_Callback(app, event)
            % hObject    handle to live_laser (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_laser(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                colormap(app.camview_laser, 'gray');
                if ~app.laser.preview(@preview_normalize_adjust_255, app.camview_laser)
                    waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
                end
            
                handles = enable_laser(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: live_multispectral
        function live_multispectral_Callback(app, event)
            % hObject    handle to live_multispectral (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_multispectral(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                colormap(app.camview_multispectral, 'hot');
                if ~app.multispectral.preview(@preview_gray, app.camview_multispectral)
                    waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
                end
            
                handles = enable_multispectral(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: live_webcam
        function live_webcam_Callback(app, event)
            % hObject    handle to live_webcam (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_webcam(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                if ~app.webcam.preview(false, app.camview_webcam)
                    waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
                end
            
                handles = enable_webcam(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: qr_button
        function qr_button_Callback(app, event)
            % hObject    handle to qr_button (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_webcam(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                try
                    img = getimage(app.camview_webcam);
            
                    text = decode_qr(img);
                    if isempty(text)
                        color = [1, 0, 0];
                        text = 'Nichts erkannt ...';
                    else
                        color = [0, 1, 0];
                    end
                    app.qr_text.String = text;
                    app.qr_text.ForegroundColor = color;
                catch e
                    warning('QR-Code exception: %s', getReport(e));
                    waitfor(msgbox('Interner Fehler während der QR-Code-Erkennung.', 'Fehler', 'warn'));
                end
            
                % Update handles structure
                handles = enable_webcam(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: snapshot_infrared
        function snapshot_infrared_Callback(app, event)
            % hObject    handle to snapshot_infrared (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_infrared(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                fprintf('Infrared start\n');
                if ~app.infrared.snapshot(@infrared_adjust, app.camview_infrared)
                    waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
                end
                app.camview_infrared = set_camview_default(app.camview_infrared);
                fprintf('Infrared end\n');
            
                handles = enable_infrared(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: snapshot_multispectral
        function snapshot_multispectral_Callback(app, event)
            % hObject    handle to snapshot_multispectral (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_multispectral(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                fprintf('Multispectral start\n');
                colormap(app.camview_multispectral, 'hot');
                if ~app.multispectral.snapshot(false, app.camview_multispectral)
                    waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
                end
                fprintf('Multispectral end\n');
            
                handles = enable_multispectral(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: snapshot_webcam
        function snapshot_webcam_Callback(app, event)
            % hObject    handle to snapshot_webcam (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_webcam(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                fprintf('Webcam start\n');
                if ~app.webcam.snapshot(false, app.camview_webcam)
                    waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
                end
                fprintf('Webcam end\n');
            
                handles = enable_webcam(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: stop_infrared
        function stop_infrared_Callback(app, event)
            % hObject    handle to stop_infrared (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_infrared(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                if ~app.infrared.stoppreview()
                    waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
                end
            
                handles = enable_infrared(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: stop_laser
        function stop_laser_Callback(app, event)
            % hObject    handle to stop_laser (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_laser(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                if ~app.laser.stoppreview()
                    waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
                end
            
                handles = enable_laser(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: stop_multispectral
        function stop_multispectral_Callback(app, event)
            % hObject    handle to stop_multispectral (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_multispectral(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                if ~app.multispectral.stoppreview()
                    waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
                end
            
                handles = enable_multispectral(handles, 'on');
                guidata(hObject, handles);
        end

        % Button pushed function: stop_webcam
        function stop_webcam_Callback(app, event)
            % hObject    handle to stop_webcam (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                handles = enable_webcam(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                if ~app.webcam.stoppreview()
                    waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
                end
            
                handles = enable_webcam(handles, 'on');
                guidata(hObject, handles);
        end

        % Value changed function: train_speed
        function train_speed_Callback(app, event)
            % hObject    handle to train_speed (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'Value') returns position of slider
            %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
                handles = enable_serial(handles, 'off');
                guidata(hObject, handles);
                drawnow();
            
                try
                    val = round(hObject.Value);
                    hObject.Value = val;
            
                    app.train_speed_label.String = sprintf('%d', val);
                    app.serial.setTrainSpeed(val, app.train_dir_left.Value == 0);
                catch e
                    warning('Train exception: %s', getReport(e));
                    waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
                end
            
                % Update handles structure
                handles = enable_serial(handles, 'on');
                guidata(hObject, handles);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create LegoDemo and hide until all components are created
            app.LegoDemo = uifigure('Visible', 'off');
            app.LegoDemo.IntegerHandle = 'on';
            app.LegoDemo.NumberTitle = 'on';
            app.LegoDemo.Position = [0 29 1585 921];
            app.LegoDemo.Name = 'gui';
            app.LegoDemo.CloseRequestFcn = createCallbackFcn(app, @LegoDemo_CloseRequestFcn, true);

            % Create camview_webcam
            app.camview_webcam = uiaxes(app.LegoDemo);
            app.camview_webcam.FontSize = 17;
            app.camview_webcam.CLim = [0 256];
            app.camview_webcam.GridLineStyle = 'none';
            app.camview_webcam.XTick = [];
            app.camview_webcam.YColor = [0.15 0.15 0.15];
            app.camview_webcam.YTick = [];
            app.camview_webcam.NextPlot = 'replace';
            app.camview_webcam.Position = [19 547 406 311];

            % Create camview_laser
            app.camview_laser = uiaxes(app.LegoDemo);
            app.camview_laser.FontSize = 17;
            app.camview_laser.CLim = [0 256];
            app.camview_laser.GridLineStyle = 'none';
            app.camview_laser.XTick = [];
            app.camview_laser.YTick = [];
            app.camview_laser.NextPlot = 'replace';
            app.camview_laser.Position = [561 547 466 304];

            % Create camview_multispectral
            app.camview_multispectral = uiaxes(app.LegoDemo);
            app.camview_multispectral.FontSize = 17;
            app.camview_multispectral.CLim = [0 256];
            app.camview_multispectral.GridLineStyle = 'none';
            app.camview_multispectral.XTick = [];
            app.camview_multispectral.YTick = [];
            app.camview_multispectral.NextPlot = 'replace';
            app.camview_multispectral.Position = [19 21 406 320];

            % Create camview_infrared
            app.camview_infrared = uiaxes(app.LegoDemo);
            app.camview_infrared.FontSize = 17;
            app.camview_infrared.CLim = [0 256];
            app.camview_infrared.GridLineStyle = 'none';
            app.camview_infrared.XTick = [];
            app.camview_infrared.YTick = [];
            app.camview_infrared.NextPlot = 'replace';
            app.camview_infrared.Position = [567 21 460 318];

            % Create text2
            app.text2 = uilabel(app.LegoDemo);
            app.text2.HorizontalAlignment = 'center';
            app.text2.FontSize = 26;
            app.text2.Position = [0 860 425 48];
            app.text2.Text = 'Webcam QR-Code';

            % Create text3
            app.text3 = uilabel(app.LegoDemo);
            app.text3.HorizontalAlignment = 'center';
            app.text3.FontSize = 26;
            app.text3.Position = [561 860 466 48];
            app.text3.Text = '3D via Laserlinie';

            % Create text4
            app.text4 = uilabel(app.LegoDemo);
            app.text4.HorizontalAlignment = 'center';
            app.text4.FontSize = 26;
            app.text4.Position = [19 355 421 49];
            app.text4.Text = 'Multispektral';

            % Create text5
            app.text5 = uilabel(app.LegoDemo);
            app.text5.HorizontalAlignment = 'center';
            app.text5.FontSize = 26;
            app.text5.Position = [567 355 460 48];
            app.text5.Text = 'Infrarot';

            % Create live_webcam
            app.live_webcam = uibutton(app.LegoDemo, 'push');
            app.live_webcam.ButtonPushedFcn = createCallbackFcn(app, @live_webcam_Callback, true);
            app.live_webcam.FontSize = 16;
            app.live_webcam.Enable = 'off';
            app.live_webcam.Position = [439 790 94 44];
            app.live_webcam.Text = 'Livebild';

            % Create live_laser
            app.live_laser = uibutton(app.LegoDemo, 'push');
            app.live_laser.ButtonPushedFcn = createCallbackFcn(app, @live_laser_Callback, true);
            app.live_laser.FontSize = 16;
            app.live_laser.Enable = 'off';
            app.live_laser.Position = [1034 790 94 44];
            app.live_laser.Text = 'Livebild';

            % Create live_multispectral
            app.live_multispectral = uibutton(app.LegoDemo, 'push');
            app.live_multispectral.ButtonPushedFcn = createCallbackFcn(app, @live_multispectral_Callback, true);
            app.live_multispectral.FontSize = 16;
            app.live_multispectral.Enable = 'off';
            app.live_multispectral.Position = [439 180 94 39];
            app.live_multispectral.Text = 'Livebild';

            % Create live_infrared
            app.live_infrared = uibutton(app.LegoDemo, 'push');
            app.live_infrared.ButtonPushedFcn = createCallbackFcn(app, @live_infrared_Callback, true);
            app.live_infrared.FontSize = 16;
            app.live_infrared.Enable = 'off';
            app.live_infrared.Position = [1034 280 94 41];
            app.live_infrared.Text = 'Livebild';

            % Create stop_webcam
            app.stop_webcam = uibutton(app.LegoDemo, 'push');
            app.stop_webcam.ButtonPushedFcn = createCallbackFcn(app, @stop_webcam_Callback, true);
            app.stop_webcam.FontSize = 16;
            app.stop_webcam.Enable = 'off';
            app.stop_webcam.Position = [439 740 94 41];
            app.stop_webcam.Text = 'Stopp';

            % Create snapshot_webcam
            app.snapshot_webcam = uibutton(app.LegoDemo, 'push');
            app.snapshot_webcam.ButtonPushedFcn = createCallbackFcn(app, @snapshot_webcam_Callback, true);
            app.snapshot_webcam.FontSize = 16;
            app.snapshot_webcam.Enable = 'off';
            app.snapshot_webcam.Position = [439 640 94 44];
            app.snapshot_webcam.Text = 'Einzelbild';

            % Create stop_laser
            app.stop_laser = uibutton(app.LegoDemo, 'push');
            app.stop_laser.ButtonPushedFcn = createCallbackFcn(app, @stop_laser_Callback, true);
            app.stop_laser.FontSize = 16;
            app.stop_laser.Enable = 'off';
            app.stop_laser.Position = [1034 740 94 41];
            app.stop_laser.Text = 'Stopp';

            % Create stop_multispectral
            app.stop_multispectral = uibutton(app.LegoDemo, 'push');
            app.stop_multispectral.ButtonPushedFcn = createCallbackFcn(app, @stop_multispectral_Callback, true);
            app.stop_multispectral.FontSize = 16;
            app.stop_multispectral.Enable = 'off';
            app.stop_multispectral.Position = [439 280 94 41];
            app.stop_multispectral.Text = 'Stopp';

            % Create snapshot_multispectral
            app.snapshot_multispectral = uibutton(app.LegoDemo, 'push');
            app.snapshot_multispectral.ButtonPushedFcn = createCallbackFcn(app, @snapshot_multispectral_Callback, true);
            app.snapshot_multispectral.FontSize = 16;
            app.snapshot_multispectral.Enable = 'off';
            app.snapshot_multispectral.Position = [439 230 94 41];
            app.snapshot_multispectral.Text = 'Einzelbild';

            % Create stop_infrared
            app.stop_infrared = uibutton(app.LegoDemo, 'push');
            app.stop_infrared.ButtonPushedFcn = createCallbackFcn(app, @stop_infrared_Callback, true);
            app.stop_infrared.FontSize = 16;
            app.stop_infrared.Enable = 'off';
            app.stop_infrared.Position = [1034 230 94 41];
            app.stop_infrared.Text = 'Stopp';

            % Create snapshot_infrared
            app.snapshot_infrared = uibutton(app.LegoDemo, 'push');
            app.snapshot_infrared.ButtonPushedFcn = createCallbackFcn(app, @snapshot_infrared_Callback, true);
            app.snapshot_infrared.FontSize = 16;
            app.snapshot_infrared.Enable = 'off';
            app.snapshot_infrared.Position = [1034 180 94 39];
            app.snapshot_infrared.Text = 'Einzelbild';

            % Create battery_label
            app.battery_label = uilabel(app.LegoDemo);
            app.battery_label.HorizontalAlignment = 'center';
            app.battery_label.FontSize = 26;
            app.battery_label.Position = [1223 600 339 48];
            app.battery_label.Text = 'Akku: Unbekannt';

            % Create uibuttongroup2
            app.uibuttongroup2 = uibuttongroup(app.LegoDemo);
            app.uibuttongroup2.Title = 'Eisenbahn';
            app.uibuttongroup2.FontSize = 26;
            app.uibuttongroup2.Position = [1223 658 339 184];

            % Create train_dir_left
            app.train_dir_left = uiradiobutton(app.uibuttongroup2);
            app.train_dir_left.Enable = 'off';
            app.train_dir_left.Text = 'Links';
            app.train_dir_left.FontSize = 26;
            app.train_dir_left.Position = [23 94 118 29];
            app.train_dir_left.Value = true;

            % Create train_dir_right
            app.train_dir_right = uiradiobutton(app.uibuttongroup2);
            app.train_dir_right.Enable = 'off';
            app.train_dir_right.Text = 'Rechts';
            app.train_dir_right.FontSize = 26;
            app.train_dir_right.Position = [187 94 140 29];

            % Create train_speed
            app.train_speed = uislider(app.uibuttongroup2);
            app.train_speed.Limits = [0 10];
            app.train_speed.MajorTicks = [];
            app.train_speed.ValueChangedFcn = createCallbackFcn(app, @train_speed_Callback, true);
            app.train_speed.MinorTicks = [];
            app.train_speed.Enable = 'off';
            app.train_speed.FontSize = 11;
            app.train_speed.Position = [23 20 304 3];

            % Create train_speed_label
            app.train_speed_label = uilabel(app.uibuttongroup2);
            app.train_speed_label.HorizontalAlignment = 'center';
            app.train_speed_label.VerticalAlignment = 'top';
            app.train_speed_label.FontSize = 26;
            app.train_speed_label.Position = [232 49 52 34];
            app.train_speed_label.Text = '0';

            % Create text12
            app.text12 = uilabel(app.uibuttongroup2);
            app.text12.FontSize = 26;
            app.text12.Position = [23 50 210 33];
            app.text12.Text = 'Geschwindigkeit:';

            % Create uibuttongroup3
            app.uibuttongroup3 = uibuttongroup(app.LegoDemo);
            app.uibuttongroup3.Title = 'Halogenlampe';
            app.uibuttongroup3.FontSize = 26;
            app.uibuttongroup3.Position = [1223 270 339 149];

            % Create halo1
            app.halo1 = uiradiobutton(app.uibuttongroup3);
            app.halo1.Enable = 'off';
            app.halo1.Text = 'An';
            app.halo1.FontSize = 26;
            app.halo1.Position = [23 13 80 28];

            % Create halo0
            app.halo0 = uiradiobutton(app.uibuttongroup3);
            app.halo0.Enable = 'off';
            app.halo0.Text = 'Aus';
            app.halo0.FontSize = 26;
            app.halo0.Position = [23 59 80 28];
            app.halo0.Value = true;

            % Create haloA
            app.haloA = uiradiobutton(app.uibuttongroup3);
            app.haloA.Enable = 'off';
            app.haloA.Text = 'Auto';
            app.haloA.FontSize = 26;
            app.haloA.Position = [146 59 87 28];

            % Create uibuttongroup4
            app.uibuttongroup4 = uibuttongroup(app.LegoDemo);
            app.uibuttongroup4.Title = 'Led';
            app.uibuttongroup4.FontSize = 26;
            app.uibuttongroup4.Position = [1223 436 339 157];

            % Create led0
            app.led0 = uiradiobutton(app.uibuttongroup4);
            app.led0.Enable = 'off';
            app.led0.Text = 'Aus';
            app.led0.FontSize = 26;
            app.led0.Position = [16 89 87 23];
            app.led0.Value = true;

            % Create led1
            app.led1 = uiradiobutton(app.uibuttongroup4);
            app.led1.Enable = 'off';
            app.led1.Text = 'Led 1';
            app.led1.FontSize = 26;
            app.led1.Position = [16 55 87 23];

            % Create led2
            app.led2 = uiradiobutton(app.uibuttongroup4);
            app.led2.Enable = 'off';
            app.led2.Text = 'Led 2';
            app.led2.FontSize = 26;
            app.led2.Position = [16 18 87 23];

            % Create led3
            app.led3 = uiradiobutton(app.uibuttongroup4);
            app.led3.Enable = 'off';
            app.led3.Text = 'Beide';
            app.led3.FontSize = 26;
            app.led3.Position = [146 55 87 23];

            % Create ledA
            app.ledA = uiradiobutton(app.uibuttongroup4);
            app.ledA.Enable = 'off';
            app.ledA.Text = 'Auto';
            app.ledA.FontSize = 26;
            app.ledA.Position = [146 18 87 23];

            % Create qr_text
            app.qr_text = uilabel(app.LegoDemo);
            app.qr_text.HorizontalAlignment = 'center';
            app.qr_text.FontSize = 21;
            app.qr_text.FontWeight = 'bold';
            app.qr_text.FontColor = [0 1 0];
            app.qr_text.Position = [93 512 332 30];
            app.qr_text.Text = '';

            % Create text11
            app.text11 = uilabel(app.LegoDemo);
            app.text11.HorizontalAlignment = 'center';
            app.text11.VerticalAlignment = 'top';
            app.text11.FontSize = 20;
            app.text11.Position = [18 509 91 26];
            app.text11.Text = 'Text:';

            % Create qr_button
            app.qr_button = uibutton(app.LegoDemo, 'push');
            app.qr_button.ButtonPushedFcn = createCallbackFcn(app, @qr_button_Callback, true);
            app.qr_button.FontSize = 16;
            app.qr_button.Enable = 'off';
            app.qr_button.Position = [439 690 94 43];
            app.qr_button.Text = 'Erkennen';

            % Create capture_start
            app.capture_start = uibutton(app.LegoDemo, 'push');
            app.capture_start.ButtonPushedFcn = createCallbackFcn(app, @capture_start_Callback, true);
            app.capture_start.FontSize = 16;
            app.capture_start.Enable = 'off';
            app.capture_start.Position = [1034 658 130 43];
            app.capture_start.Text = 'Bildaufnahme';

            % Create capture_calc
            app.capture_calc = uibutton(app.LegoDemo, 'push');
            app.capture_calc.ButtonPushedFcn = createCallbackFcn(app, @capture_calc_Callback, true);
            app.capture_calc.FontSize = 16;
            app.capture_calc.Enable = 'off';
            app.capture_calc.Position = [1034 547 130 46];
            app.capture_calc.Text = '3D-Berechnung';

            % Create camera_init
            app.camera_init = uibutton(app.LegoDemo, 'push');
            app.camera_init.ButtonPushedFcn = createCallbackFcn(app, @camera_init_Callback, true);
            app.camera_init.FontSize = 16;
            app.camera_init.Position = [1223 857 165 51];
            app.camera_init.Text = 'Kameras initialisieren';

            % Create image_slider
            app.image_slider = uislider(app.LegoDemo);
            app.image_slider.Limits = [0 1];
            app.image_slider.MajorTicks = [];
            app.image_slider.ValueChangedFcn = createCallbackFcn(app, @image_slider_Callback, true);
            app.image_slider.MinorTicks = [];
            app.image_slider.Enable = 'off';
            app.image_slider.FontSize = 11;
            app.image_slider.Position = [610 523 369 3];

            % Create cut_begin
            app.cut_begin = uibutton(app.LegoDemo, 'push');
            app.cut_begin.ButtonPushedFcn = createCallbackFcn(app, @cut_begin_Callback, true);
            app.cut_begin.FontSize = 20;
            app.cut_begin.Enable = 'off';
            app.cut_begin.Position = [561 509 37 33];
            app.cut_begin.Text = 'X';

            % Create cut_end
            app.cut_end = uibutton(app.LegoDemo, 'push');
            app.cut_end.ButtonPushedFcn = createCallbackFcn(app, @cut_end_Callback, true);
            app.cut_end.FontSize = 20;
            app.cut_end.Enable = 'off';
            app.cut_end.Position = [992 509 35 33];
            app.cut_end.Text = 'X';

            % Create capture_stop
            app.capture_stop = uibutton(app.LegoDemo, 'push');
            app.capture_stop.ButtonPushedFcn = createCallbackFcn(app, @capture_stop_Callback, true);
            app.capture_stop.FontSize = 16;
            app.capture_stop.Enable = 'off';
            app.capture_stop.Position = [1034 604 130 44];
            app.capture_stop.Text = 'Aufnahmestopp';

            % Create demomode
            app.demomode = uibutton(app.LegoDemo, 'state');
            app.demomode.ValueChangedFcn = createCallbackFcn(app, @demomode_Callback, true);
            app.demomode.Enable = 'off';
            app.demomode.Text = 'Demo Modus';
            app.demomode.FontSize = 20;
            app.demomode.FontWeight = 'bold';
            app.demomode.Position = [1223 194 339 61];

            % Create img_count
            app.img_count = uilabel(app.LegoDemo);
            app.img_count.HorizontalAlignment = 'center';
            app.img_count.FontSize = 20;
            app.img_count.Position = [1034 509 130 28];
            app.img_count.Text = 'Bilder: 0';

            % Create connect_serial_port
            app.connect_serial_port = uibutton(app.LegoDemo, 'push');
            app.connect_serial_port.ButtonPushedFcn = createCallbackFcn(app, @connect_serial_port_Callback, true);
            app.connect_serial_port.FontSize = 16;
            app.connect_serial_port.Position = [1397 857 165 51];
            app.connect_serial_port.Text = 'COM-Port verbinden';

            % Show the figure after all components are created
            app.LegoDemo.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gui_app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.LegoDemo)

            % Execute the startup function
            runStartupFcn(app, @gui_OpeningFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.LegoDemo)
        end
    end
end