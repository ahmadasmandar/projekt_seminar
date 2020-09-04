classdef UILaser < matlab.apps.AppBase

% the publich properties
    properties (Access = public)
        UI                      matlab.ui.Figure
        Container               matlab.ui.container.GridLayout
        CData
        laser_images
    end


% private properties
    properties (Access = public)
        % Titels 
        text3                   matlab.ui.control.Label
        img_count               matlab.ui.control.Label

        % Axes
        camview_laser           matlab.ui.control.UIAxes

        %Buttons
        live_laser              matlab.ui.control.Button
        stop_laser              matlab.ui.control.Button
        capture_start           matlab.ui.control.Button
        capture_stop            matlab.ui.control.Button
        capture_calc            matlab.ui.control.Button

        %Slider
        image_slider            matlab.ui.control.Slider
        cut_begin               matlab.ui.control.Button
        cut_end                 matlab.ui.control.Button
        %
        % App objects
        init_app

    end

    %public Methods
    methods (Access = public)

        %constructor
        function app= UILaser(UI, parent, id)
            
            app.UI= UI;
            app.Container=uigridlayout(parent);
            app.laser_images = false;


            %app.Container.RowHeight = {30,30,30,30,30,30,'1x',40,30};
            %app.Container.ColumnWidth = {40,'1x',40,130};
            
            
            %dynamic
            app.Container.RowHeight = {'0.35x','0.35x','0.35x','0.35x','0.35x','0.35x','1x','0.4x','0.3x'};
            app.Container.ColumnWidth = {'0.25x','3x','0.25x','1.2x'};



            %%%%%%%%%% ###########   Labels ########## %%%%%%%%%%%%%
         
         % text3 of the element
         app.text3 = uilabel(app.Container);
         app.text3.Text = "3D via Laserlinie";
         %app.text3.FontWeight = "bold";
         app.text3.FontSize = 26;
         app.text3.HorizontalAlignment = "center";
         % app.text3.VerticalAlignment = 'top';
         app.text3.Layout.Row = 1;
         app.text3.Layout.Column = [1,3];
         %############################# test ##########
         
         
         
         %############################# test ##########
         % Create img_count
         app.img_count = uilabel(app.Container);
         app.img_count.HorizontalAlignment = 'center';
         % app.img_count.VerticalAlignment = 'top';
         app.img_count.Text = 'Bilder: 0';
         app.img_count.FontSize = 20;
         app.img_count.FontWeight = "bold";
         app.img_count.Layout.Row = 8;
         app.img_count.Layout.Column =4;
         
         %%%%%%%%%% ###########   Axes ########## %%%%%%%%%%%%%
         
         % axes on which plotting takes place
         app.camview_laser = uiaxes(app.Container);
         app.camview_laser.Layout.Row = [2, 7];
         app.camview_laser.Layout.Column = 2;
         % set image to show on the Axes on startup
         laser_img= imread("images/laser.png");
         imshow(laser_img,'Parent',app.camview_laser);
         
         
         
         %%%%%%%%%% ###########   Buttons ########## %%%%%%%%%%%%%
         
         % button to live_laser function
         app.live_laser = uibutton(app.Container);
         app.live_laser.Text = "Livebild";
         app.live_laser.Enable='off';
         app.live_laser.FontSize = 16;
         app.live_laser.Layout.Row = 2;
         app.live_laser.Layout.Column =4;
         app.live_laser.ButtonPushedFcn = createCallbackFcn(app, @live_laser_Callback, true);
         
         
         
         % button to stop_laser function
         app.stop_laser = uibutton(app.Container);
         app.stop_laser.Text = "Stopp";
         app.stop_laser.Enable='off';
         app.stop_laser.FontSize = 16;
         app.stop_laser.Layout.Row = 3;
         app.stop_laser.Layout.Column =4;
         app.stop_laser.ButtonPushedFcn = createCallbackFcn(app, @stop_laser_Callback, true);
         
         % button to Bilaufnahme function
         app.capture_start = uibutton(app.Container);
         app.capture_start.Text = "Bildaufnahme";
         app.capture_start.Enable='off';
         app.capture_start.FontSize = 16;
         app.capture_start.Layout.Row = 4;
         app.capture_start.Layout.Column =4;
         app.capture_start.ButtonPushedFcn = createCallbackFcn(app, @capture_start_Callback, true);
         
         % button to Bilaufnahme-Stop function
         app.capture_stop = uibutton(app.Container);
         app.capture_stop.Text = "Aufnahmestopp";
         app.capture_stop.Enable='off';
         app.capture_stop.FontSize = 16;
         app.capture_stop.Layout.Row = 5;
         app.capture_stop.Layout.Column =4;
         app.capture_stop.ButtonPushedFcn = createCallbackFcn(app, @capture_stop_Callback, true);
         
         
         % button to 3D-Berechnungen function
         app.capture_calc = uibutton(app.Container);
         app.capture_calc.Text = "3D-Berechnung";
         app.capture_calc.Enable='off';
         app.capture_calc.FontSize = 16;
         app.capture_calc.Layout.Row = 6;
         app.capture_calc.Layout.Column =4;
         app.capture_calc.ButtonPushedFcn =  createCallbackFcn(app, @capture_calc_Callback, true);

         %%%%%%%%%% ###########   Buttons + Slider  ########## %%%%%%%%%%%%%
         
         % Image Slider function
         app.image_slider = uislider(app.Container);
         app.image_slider.Layout.Row = 8;
         app.image_slider.Enable='off';
         app.image_slider.Limits = [0 300];
         app.image_slider.Layout.Column =2;
         app.image_slider.MajorTicks = [0 30 60 90 120 150 180 210 240 270 300];
         app.image_slider.MinorTicks = [0 30 60 90 120 150 180 210 240 270 300];

        % button to Start cut function
        app.cut_begin = uibutton(app.Container);
        app.cut_begin.Text = "x";
        app.cut_begin.Enable='off';
        app.cut_begin.FontSize = 16;
        app.cut_begin.Layout.Row = 8;
        app.cut_begin.Layout.Column =1;

        app.cut_begin.ButtonPushedFcn = createCallbackFcn(app, @cut_begin_Callback, true);

        % button to End cut function
        app.cut_end  = uibutton(app.Container);
        app.cut_end.Text = "x";
        app.cut_end.Enable='off';
        app.cut_end.FontSize = 16;
        app.cut_end.Layout.Row = 8;
        app.cut_end.Layout.Column =3;
        app.cut_end.ButtonPushedFcn = createCallbackFcn(app, @cut_end_Callback, true);

             app.Container.Padding = [10 10 10 10];
        end
        
    end

    % *******************************
    % the Buttonfuctions

    % app.init_app.laser try to call the Fuctions in the Laser object > parameter > videoinput class

    methods(Access = public)
    % --- Executes on button press in live_laser.
    function live_laser_Callback(app, ~)

            enable_laser(app.init_app, 'off');

            colormap(app.camview_laser, 'gray');
            if ~app.init_app.laser.preview(app, app.camview_laser)
                waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
            end
        
            enable_laser(app.init_app, 'on');

        end


    % --- Executes on button press in stop_laser.
    function stop_laser_Callback(app, ~)

        enable_laser(app.init_app, 'off');

        if ~app.init_app.laser.stoppreview()
            waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
        end
        enable_laser(app.init_app, 'on');
    end

    % --- Executes on button press in capture_start.
    function capture_start_Callback(app, ~)

        enable_laser(app.init_app, 'off');
    
        if app.init_app.laser.stoppreview() == false || app.init_app.laser.config(@app.config_laser_start) == false
            waitfor(msgbox('Interner Fehler während der Laserlinienbild-Aufnahmekonfiguration.', 'Fehler', 'warn'));
    
            enable_laser(app.init_app, 'on');
            return;
        end
    
        if ~app.init_app.demo
                app.capture_stop.Enable = 'on';
        end

    end

    % 
    % --- Executes on button press in capture_stop.
    function capture_stop_Callback(app, ~)

        enable_laser(app.init_app, 'off');
    
        [success, images] = app.init_app.laser.config(@app.get_images);
        if success && ~islogical(images)
            n = size(images, 4);
            app.laser_images = images;
            save('laserimages','images');
            colormap(app.camview_laser, 'gray');
            app.image_slider.Enable = 'on';
            app.image_slider.Limits = [1 n];
            % app.image_slider.Min = 1;
            % app.image_slider.Max = n;
            % app.image_slider.SliderStep = [1 / (n - 1), 1 / (n - 1)];
            for i = 1:n
                if app.init_app.demo && mod(i, 5) ~= 0
                    continue;
                end
                capture_img = app.laser_images(:, :, 1, i);
                image(capture_img, 'parent', app.camview_laser);
                app.camview_laser = set_camview_default(app,app.camview_laser);
                app.image_slider.Value = i;
                app.img_count.Text = sprintf('%d von %d', i, n);
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
    
        app.img_count.Text = sprintf('Bilder: %d', n);
        % save('applaserimages','app.laser_images');
       enable_laser(app.init_app, 'on');

    end
    % *******
        % --- Executes on button press in capture_calc.
    function capture_calc_Callback(app, ~)

        enable_laser(app.init_app, 'off');

    
        if ~islogical(app.laser_images)
            n = size(app.laser_images, 4);
        else
            n = 0;
        end
    
        if n < 10
            if ~app.init_app.demo
                waitfor(msgbox('Zu wenige Bilder f�r 3D-Bild Berechnung.', 'Fehler', 'warn'));
            end
    
            enable_laser(app.init_app, 'on');

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
    
            app.img_count.Text = sprintf('Bilder: %d', n);
    
            mesh(data3d, 'parent', app.camview_laser);
            % mesh(data3d);
            colormap(app.camview_laser, 'jet');
            app.camview_laser.YTick = [];
            app.camview_laser.XTick = [];
            app.camview_laser.ZTick = [];
            min3d = min(min(data3d));
            app.camview_laser.DataAspectRatio = [15, 4.5, 1.5];
            app.camview_laser.CLim = [min3d, 0];
            app.camview_laser.CLimMode = 'manual';
            rotate3d(app.camview_laser, 'on');
        catch e
            warning('3D calc exception: %s', getReport(e));
            waitfor(msgbox('Interner Fehler während der 3D-Bild Berechnung.', 'Fehler', 'warn'));
        end

            enable_laser(app.init_app, 'on');
    end
    % ********

    % *********
    % --- Executes on button press in cut_begin.
    function cut_begin_Callback(app, ~)

        n = size(app.laser_images, 4);
        first = app.image_slider.Value;
        app.laser_images = app.laser_images(:, :, 1, first:n);
        n = size(app.laser_images, 4);
        app.image_slider.Limits = [1 n];
        % app.image_slider.Min = 1;
        % app.image_slider.Max = n;
        if n > 1
            step = 1 / (n - 1);
        else
            step = 1;
        end
        app.image_slider.Value = 1;
        % app.image_slider.SliderStep = [step, step];
        app.image_slider.Value = 1;
        app.img_count.Text = sprintf('%d von %d', app.image_slider.Value, n);

    end

    % ***********
    % --- Executes on button press in cut_end.
    function cut_end_Callback(app, ~) 

        last = app.image_slider.Value;
        app.laser_images = app.laser_images(:, :, 1, 1:last);
        n = size(app.laser_images, 4);
        app.image_slider.Limits = [1 n];
        % app.image_slider.Min = 1;
        % app.image_slider.Max = n;
        if n > 1
            step = 1 / (n - 1);
        else
            step = 1;
        end
        app.image_slider.Value = 1;
        % app.image_slider.SliderStep = [step, step];
        app.image_slider.Value = n;
        app.img_count.Text = sprintf('%d von %d', app.image_slider.Value, n);
    
    end

    % 
    
    %  ------ Receive the UIInitiaialize app from UIInitialize
    function receive_init_from_UIInitialize(app, app_obj)
        app.init_app=app_obj;
    end

    % 
    % image processing functions:
    % ----------------------------

    function preview_normalize_adjust_255(app,~, event, himage)
        himage.CData = app.normalize_adjust_255(event.Data);
    end
  

    function img = normalize_adjust(app,img)
        img = double(img);
        minv = min(img(:));
        maxv = max(img(:));
        diff = maxv - minv;
        img = (img - minv) ./ diff;
    end

    function camview = set_camview_default(app,camview)
        camview.XTick = [];
        camview.YTick = [];
        camview.CLim = [0, 255];
        camview.CLimMode = 'manual';
        camview.DataAspectRatio = [1, 1, 1];
    end
    
    function img = normalize_adjust_255(app, img)
        img = normalize_adjust(app, img) .* 255;
    end

    % ##########################################
    function handle = config_laser_start(app,handle)
        triggerconfig(handle, 'hardware', 'DeviceSpecific', 'DeviceSpecific');
        % triggerconfig(app.init_app.laser, 'manual');
        demomode=false;
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


    function [handle, images] = get_images(app,handle)
        stop(handle);
        count = handle.FramesAvailable;
    
        handle.FramesPerTrigger = count;
        images = getdata(handle);
    
        triggerconfig(handle, 'manual');
    
        src = getselectedsource(handle);
        src.TriggerMode = 'Off';
        handle.FramesPerTrigger = 1;
    end

    % end the methods
    end




end
        