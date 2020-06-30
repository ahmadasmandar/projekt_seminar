classdef UILaser < matlab.apps.AppBase

% the publich properties
    properties (Access = public)
        UI                      matlab.ui.Figure
        Container               matlab.ui.container.GridLayout
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

    end

    %public Methods
    methods (Access = public)

        %constructor
        function obj= UILaser(UI, parent, id)
            
            obj.UI= UI;
            obj.Container=uigridlayout(parent);


            %obj.Container.RowHeight = {30,30,30,30,30,30,'1x',40,30};
            %obj.Container.ColumnWidth = {40,'1x',40,130};
            
            
            %dynamic
            obj.Container.RowHeight = {'0.35x','0.35x','0.35x','0.35x','0.35x','0.35x','1x','0.4x','0.3x'};
            obj.Container.ColumnWidth = {'0.25x','3x','0.25x','1.2x'};



            %%%%%%%%%% ###########   Labels ########## %%%%%%%%%%%%%
         
         % text3 of the element
         obj.text3 = uilabel(obj.Container);
         obj.text3.Text = "3D via Laserlinie";
         %obj.text3.FontWeight = "bold";
         obj.text3.FontSize = 26;
         obj.text3.HorizontalAlignment = "center";
         % obj.text3.VerticalAlignment = 'top';
         obj.text3.Layout.Row = 1;
         obj.text3.Layout.Column = [1,3];
         %############################# test ##########
         
         
         
         %############################# test ##########
         % Create img_count
         obj.img_count = uilabel(obj.Container);
         obj.img_count.HorizontalAlignment = 'center';
         % obj.img_count.VerticalAlignment = 'top';
         obj.img_count.Text = 'Bilder: 0';
         obj.img_count.FontSize = 20;
         obj.img_count.FontWeight = "bold";
         obj.img_count.Layout.Row = 8;
         obj.img_count.Layout.Column =4;
         
         %%%%%%%%%% ###########   Axes ########## %%%%%%%%%%%%%
         
         % axes on which plotting takes place
         obj.camview_laser = uiaxes(obj.Container);
         obj.camview_laser.Layout.Row = [2, 7];
         obj.camview_laser.Layout.Column = 2;
         % set image to show on the Axes on startup
         laser_img= imread("laser.png");
         imshow(laser_img,'Parent',obj.camview_laser);
         
         
         
         %%%%%%%%%% ###########   Buttons ########## %%%%%%%%%%%%%
         
         % button to live_laser function
         obj.live_laser = uibutton(obj.Container);
         obj.live_laser.Text = "Livebild";
         obj.live_laser.Enable='off';
         obj.live_laser.FontSize = 16;
         obj.live_laser.Layout.Row = 2;
         obj.live_laser.Layout.Column =4;
         obj.live_laser.ButtonPushedFcn = @(~, ~) obj.live_laser_callback();
         
         
         
         % button to stop_laser function
         obj.stop_laser = uibutton(obj.Container);
         obj.stop_laser.Text = "Stopp";
         obj.stop_laser.Enable='off';
         obj.stop_laser.FontSize = 16;
         obj.stop_laser.Layout.Row = 3;
         obj.stop_laser.Layout.Column =4;
         obj.stop_laser.ButtonPushedFcn = @(~, ~) obj.stop_laser_callback();
         
         % button to Bilaufnahme function
         obj.capture_start = uibutton(obj.Container);
         obj.capture_start.Text = "Bildaufnahme";
         obj.capture_start.Enable='off';
         obj.capture_start.FontSize = 16;
         obj.capture_start.Layout.Row = 4;
         obj.capture_start.Layout.Column =4;
         obj.capture_start.ButtonPushedFcn = @(~, ~) obj.capture_start_callback();
         
         % button to Bilaufnahme function
         obj.capture_stop = uibutton(obj.Container);
         obj.capture_stop.Text = "Aufnahmestopp";
         obj.capture_stop.Enable='off';
         obj.capture_stop.FontSize = 16;
         obj.capture_stop.Layout.Row = 5;
         obj.capture_stop.Layout.Column =4;
         obj.capture_stop.ButtonPushedFcn = @(~, ~) obj.capture_stop_callback();
         
         
         % button to Bilaufnahme function
         obj.capture_calc = uibutton(obj.Container);
         obj.capture_calc.Text = "3D-Berechnung";
         obj.capture_calc.Enable='off';
         obj.capture_calc.FontSize = 16;
         obj.capture_calc.Layout.Row = 6;
         obj.capture_calc.Layout.Column =4;
         obj.capture_calc.ButtonPushedFcn = @(~, ~) obj.capture_calc_callback();
         %%%%%%%%%% ###########   Buttons ########## %%%%%%%%%%%%%
         
         % Image Slider function
         obj.image_slider = uislider(obj.Container);
         obj.image_slider.Layout.Row = 8;
         obj.image_slider.Enable='off';
         obj.image_slider.Limits = [0 300];
         obj.image_slider.Layout.Column =2;
         obj.image_slider.MajorTicks = [0 30 60 90 120 150 180 210 240 270 300];
         obj.image_slider.MinorTicks = [0 30 60 90 120 150 180 210 240 270 300];

              % button to Start cut function
              obj.cut_begin = uibutton(obj.Container);
              obj.cut_begin.Text = "x";
              obj.cut_begin.Enable='off';
              obj.cut_begin.FontSize = 16;
              obj.cut_begin.Layout.Row = 8;
              obj.cut_begin.Layout.Column =1;

              obj.cut_begin.ButtonPushedFcn = @(~, ~) obj.cut_begin_callback();

              % button to End cut function
              obj.cut_end  = uibutton(obj.Container);
              obj.cut_end.Text = "x";
              obj.cut_end.Enable='off';
              obj.cut_end.FontSize = 16;
              obj.cut_end.Layout.Row = 8;
              obj.cut_end.Layout.Column =3;
              obj.cut_end.ButtonPushedFcn = @(~, ~) obj.cut_end_callback();


             obj.Container.Padding = [10 10 10 10];




             

        end
        
    end

    % the functions
    % private methods
    methods (Access = private)

        % Handles:
        % If you were developing your GUI with GUIDE, this would typically be a structure called handles which is usually an input parameter to all callbacks

        % gcbo, GCBO

        % Handle of object whose callback is executing
        % Syntax
        
        % h = gcbo
        % [h,figure] = gcbo
        % Description
        
        % h = gcbo returns the handle of the graphics object whose callback is executing.
        
        % [h,figure] = gcbo returns the handle of the current callback object and the handle of the figure containing this object.



        % External Functions are used with Laser
        function connect_serial_port_Callback(obj, event)
            % obj    handle to connect_serial_port (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
                obj.connect_serial_port.Enable = 'off';
            
                % Update handles structure
                guidata(obj, handles);
                drawnow();
            
                % Initialize serial port
                if is_serial_port(handles) == false
                    try
                        obj.serial = obj.param.serial_port({@serial_callback, obj});
                    catch e
                        warning('Exception in camera_webcam(): %s', getReport(e));
                    end
                end
            
                % connect
                success = false;
                try
                    success = obj.serial.connect();
                catch e
                    warning('Exception in serial.connect: %s', getReport(e));
                end
            
                if success == true
                    handles = enable_serial(handles, 'on');
                else
                    % warn that connecting failed
                    waitfor(msgbox('Verbindung konnte nicht hergestellt werden.', 'Fehler', 'warn'));
                    obj.connect_serial_port.Enable = 'on';
                end
            
                % Update handles structure
                guidata(obj, handles);
        end



        % we need to use Serial Object (creat one)



        % ******************************%

        function enabled = is_serial_port(obj, handles)
            enabled = isfield(handles, 'serial') && isa(obj.serial, 'class_serial_port');
        end


        % ########### Enable_laser  :
        function handles = enable_laser(obj, handles, value)
            if ~is_laser(handles) || obj.demo
                return;
            end
        
            obj.live_laser.Enable = value;
            obj.stop_laser.Enable = value;
            obj.capture_start.Enable = value;
            obj.capture_stop.Enable = value;
            obj.capture_calc.Enable = value;
        
            if is_serial_port(handles)
                obj.demomode.Enable = value;
            end
        end
        % *****************Ende Enable_laser*************%

        function enabled = is_laser(handles)
            enabled = isfield(handles, 'laser') && isa(handles.laser, 'class_videoinput');
        end

        function preview_normalize_adjust_255(obj, ~, event, himage)
            himage.CData = normalize_adjust_255(event.Data);
        end

        %######################
        function [handle, images] = get_images(handle)
            stop(handle);
            count = handle.FramesAvailable;
        
            handle.FramesPerTrigger = count;
            images = getdata(handle);
        
            triggerconfig(handle, 'manual');
        
            src = getselectedsource(handle);
            src.TriggerMode = 'Off';
            handle.FramesPerTrigger = 1;
        end


        % the local Functions

        % ########### the Live_Laser Function  :

        function live_laser_callback(obj,~,handles)
            handles = enable_laser(handles, 'off');
            guidata(obj, handles);
            % guidata
            % Store or retrieve UI data
            % Description
            % guidata(obj,data) stores the specified data in the application data of obj if it is a figure, or the parent figure of obj if it is another component. For more information, see How guidata Manages Data.
            % data = guidata(obj) returns previously stored data, or an empty matrix if nothing is stored.

            drawnow();
            % Description
            % drawnow updates figures and processes any pending callbacks. Use this command if you modify graphics objects and want to see the updates on the screen immediately.

            colormap(handles.camview_laser, 'gray');

            if ~handles.laser.preview(@preview_normalize_adjust_255, handles.camview_laser)
                waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
            end

            handles = enable_laser(handles, 'on');
            guidata(obj, handles);
        end

        % ################### Ende LIVE_LASER ##########################





        % ########### stop_laser_callback  :
        function stop_laser_callback(obj,~,handles)
            % obj    handle to stop_laser (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            handles = enable_laser(handles, 'off');
            guidata(obj, handles);
            drawnow();
        
            if ~handles.laser.stoppreview()
                waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
            end
            handles = enable_laser(handles, 'on');
            guidata(obj, handles);
        end

        % ################### Ende stop_laser_callbacke ##########################

        % ################### function capture_start_callback:
        function capture_start_callback(obj,~,handles)
            handles = enable_laser(handles, 'off');
            guidata(obj, handles);
            drawnow();
            
            if handles.laser.stoppreview() == false || handles.laser.config({@config_laser_start, handles.demo}) == false
                waitfor(msgbox('Interner Fehler während der Laserlinienbild-Aufnahmekonfiguration.', 'Fehler', 'warn'));
                
                handles = enable_laser(handles, 'on');
                guidata(obj, handles);
                return;
            end
            
            if ~handles.demo
                handles.capture_stop.Enable = 'on';
            end
            % Update handles structure
            guidata(obj, handles);
        end
        % ################### Ende function capture_start_callback ##########################
        
        
        % ################### function capture_Stop_callback:
        function capture_stop_callback(obj,~,handles)
            handles = enable_laser(handles, 'off');
            guidata(obj, handles);
            drawnow();
            
            [success, images] = handles.laser.config(@get_images);
            if success && ~islogical(images)
                n = size(images, 4);
                handles.laser_images = images;
                
                colormap(handles.camview_laser, 'gray');
                handles.image_slider.Enable = 'on';
                handles.image_slider.Min = 1;
                handles.image_slider.Max = n;
                handles.image_slider.SliderStep = [1 / (n - 1), 1 / (n - 1)];
                for i = 1:n
                    if handles.demo && mod(i, 5) ~= 0
                        continue;
                    end
                    capture_img = handles.laser_images(:, :, 1, i);
                    image(capture_img, 'parent', handles.camview_laser);
                    handles.camview_laser = set_camview_default(handles.camview_laser);
                    handles.image_slider.Value = i;
                    handles.img_count.String = sprintf('%d von %d', i, n);
                    guidata(obj, handles);
                    drawnow();
                    pause(0.001);
                end
                
                handles.cut_begin.Enable = 'on';
                handles.cut_end.Enable = 'on';
            else
                n = 0;
                handles.laser_images = false;
                handles.image_slider.Enable = 'off';
                handles.cut_begin.Enable = 'off';
                handles.cut_end.Enable = 'off';
            end
            
            handles.img_count.String = sprintf('Bilder: %d', n);
            
            handles = enable_laser(handles, 'on');
            guidata(obj, handles);
        end
        
        %######################### End Capture
        
        % ################### function 3D_callback:
        function capture_calc_callback(obj,~,handles)
            handles = enable_laser(handles, 'off');
            guidata(obj, handles);
            drawnow();
            
            if ~islogical(handles.laser_images)
                n = size(handles.laser_images, 4);
            else
                n = 0;
            end
            
            if n < 10
                if ~handles.demo
                    waitfor(msgbox('Zu wenige Bilder für 3D-Bild Berechnung.', 'Fehler', 'warn'));
                end
                
                handles = enable_laser(handles, 'on');
                guidata(obj, handles);
                return;
            end
            
            try
                Threshold = 100;             % Gray value threshold for backgound extraction
                % pre calibatrion data - use the program laserschnittverfahren3 to calibrate your system
                ps = 0.054381;              % Pixel relative size (mm/pixel)
                alpha = 13.844982;          % Triangulation angle in (Â°)
                LinCoef = 0;                % Linear coefficient 105
                AngCoef = 0;                % Angular coefficient
                data3d = get3D(handles.laser_images, Threshold, ps, alpha, LinCoef, AngCoef);
                
                handles.img_count.String = sprintf('Bilder: %d', n);
                
                colormap(handles.camview_laser, 'jet');
                mesh(data3d, 'parent', handles.camview_laser);
                handles.camview_laser.YTick = [];
                handles.camview_laser.XTick = [];
                handles.camview_laser.ZTick = [];
                min3d = min(min(data3d));
                handles.camview_laser.DataAspectRatio = [15, 4.5, 1.5];
                handles.camview_laser.CLim = [min3d, 0];
                handles.camview_laser.CLimMode = 'manual';
                rotate3d(handles.camview_laser, 'on');
                guidata(obj, handles);
                drawnow();
            catch e
                warning('3D calc exception: %s', getReport(e));
                waitfor(msgbox('Interner Fehler während der 3D-Bild Berechnung.', 'Fehler', 'warn'));
            end
            
            handles = enable_laser(handles, 'on');
            guidata(obj, handles);
        end
        %######################### End Capture
        
        %######################### Function Cut_Beginn: 
        function cut_begin_callback(obj,~,handles)
            n = size(handles.laser_images, 4);
            first = handles.image_slider.Value;
            handles.laser_images = handles.laser_images(:, :, 1, first:n);
            n = size(handles.laser_images, 4);
            
            handles.image_slider.Min = 1;
            handles.image_slider.Max = n;
            if n > 1
                step = 1 / (n - 1);
            else
                step = 1;
            end
            handles.image_slider.Value = 1;
            handles.image_slider.SliderStep = [step, step];
            handles.image_slider.Value = 1;
            handles.img_count.String = sprintf('%d von %d', handles.image_slider.Value, n);
            
            guidata(obj, handles);
        end
        %######################### End Cut_begin
        
        function cut_end_callback(obj,~,handles)
            last = handles.image_slider.Value;
            handles.laser_images = handles.laser_images(:, :, 1, 1:last);
            n = size(handles.laser_images, 4);
        
            handles.image_slider.Min = 1;
            handles.image_slider.Max = n;
            if n > 1
                step = 1 / (n - 1);
            else
                step = 1;
            end
            handles.image_slider.Value = 1;
            handles.image_slider.SliderStep = [step, step];
            handles.image_slider.Value = n;
            handles.img_count.String = sprintf('%d von %d', handles.image_slider.Value, n);
        
            guidata(obj, handles);
        end
    end

end
        