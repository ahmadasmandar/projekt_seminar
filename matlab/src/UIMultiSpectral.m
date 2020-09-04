classdef UIMultiSpectral < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        init_app
    end

    % public properties
    properties (Access = public)
        Headline                matlab.ui.control.Label
        camview_multispectral   matlab.ui.control.UIAxes
        LiveView                matlab.ui.control.Button
        StopView                matlab.ui.control.Button
        TakePic                 matlab.ui.control.Button
    
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function app = UIMultiSpectral(UI, parent, id)
            % set the superior window (uifigure)
            app.UI = UI;

            % create the main layout with the given element as parent
            app.Container = uigridlayout(parent);

            % make a grid layour with 7 rows and 2 columns
            %app.Container.RowHeight = {30, 30, 30, 30, 30, '1x', 30};
            %app.Container.ColumnWidth = {'2x', 130};
            
            %dynamic
            app.Container.RowHeight = {'0.2x', '0.2x', '0.2x', '0.2x', '0.2x', '1x', '0.2x'};
            app.Container.ColumnWidth = {'3x', '1x'};
            
            img_multispectral= imread("images/multispectral.jpg");

            % headline of the element
            app.Headline = uilabel(app.Container);
            app.Headline.Text = "Multispektral";
            %app.Headline.FontWeight = "bold";
            app.Headline.FontSize = 26;
            app.Headline.HorizontalAlignment = "center";
            app.Headline.Layout.Row = 1;
            app.Headline.Layout.Column = 1;
            
            % axes on which plotting takes place
            app.camview_multispectral = uiaxes(app.Container);
            app.camview_multispectral.Layout.Row = [2, 6];
            app.camview_multispectral.Layout.Column = 1;
            % set image to show on the Axes on startup
            imshow(img_multispectral,'Parent',app.camview_multispectral);
            


            % button to live view
            app.LiveView = uibutton(app.Container);
            app.LiveView.Text = "Livebild";
            app.LiveView.Enable='off';
            app.LiveView.FontSize = 16;
            app.LiveView.Layout.Row = 2;
            app.LiveView.Layout.Column = 2;
            app.LiveView.ButtonPushedFcn = createCallbackFcn(app, @live_multispectral_Callback, true);



            % button to stop the view
            app.StopView = uibutton(app.Container);
            app.StopView.Text = "Stopp";
            app.StopView.Enable='off';
            app.StopView.FontSize = 16;
            app.StopView.Layout.Row = 3;
            app.StopView.Layout.Column = 2;
            app.StopView.ButtonPushedFcn = createCallbackFcn(app, @stop_multispectral_Callback, true);


            % button to take a pic
            app.TakePic = uibutton(app.Container);
            app.TakePic.Text = "Einzelbild";
            app.TakePic.Enable='off';
            app.TakePic.FontSize = 16;
            app.TakePic.Layout.Row = 4;
            app.TakePic.Layout.Column = 2;
            app.TakePic.ButtonPushedFcn = createCallbackFcn(app, @snapshot_multispectral_Callback, true);

            app.Container.Padding = [10 10 10 10];
            


        end
        
    end



    % Functions

    methods(Access = public)
        %  ------ Receive the UIInitiaialize app from UIInitialize
        function receive_init_from_UIInitialize(app, app_app)
            app.init_app=app_app;
        end

        % --- Executes on button press in live_multispectral.
        function live_multispectral_Callback(app, ~)

            enable_multispectral(app, 'off');
        
            if ~app.init_app.multispectral.preview(@app.preview_gray, app.camview_multispectral)
                waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
            end
            
            colormap(app.camview_multispectral, 'hot');
            enable_multispectral(app, 'on');

        end

        % --- Executes on button press in snapshot_multispectral.
        function snapshot_multispectral_Callback(app, ~)

            enable_multispectral(app, 'off');
        
            fprintf('Multispectral start\n');
            if ~app.init_app.multispectral.snapshot(false, app.camview_multispectral)
                waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
            end
            fprintf('Multispectral end\n');
            
            colormap(app.camview_multispectral, 'hot');
            enable_multispectral(app, 'on');
        end

        % --- Executes on button press in stop_multispectral.
        function stop_multispectral_Callback(app, ~) 

            enable_multispectral(app, 'off');

        
            if ~app.init_app.multispectral.stoppreview()
                waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
            end
        
            enable_multispectral(app, 'on');

        end

        % UI Enable 
        function app = enable_multispectral(app, value)

            if ~is_multispectral(app.init_app) || app.init_app.demo
                return;
            end

            app.LiveView.Enable=value;
            app.StopView.Enable=value;
            app.TakePic.Enable=value;

            if is_serial_port(app.init_app)
                app.init_app.demo_app.demomode.Enable = value;
            end
        end

        % Image Processing
        function img = normalize_adjust(app,img)
            img = double(img);
            minv = min(img(:));
            maxv = max(img(:));
            diff = maxv - minv;
            img = (img - minv) ./ diff;
        end
        
        function img = normalize_adjust_255(app,img)
            img = app.normalize_adjust(img) .* 255;
        end
        
        function img = infrared_adjust(app,img)
            img = app.normalize_adjust_255(img);
            img = imrotate(img, 90);
        end
        
        function preview_normalize_adjust_255(app,~, event, himage)
            himage.CData = app.normalize_adjust_255(event.Data);
        end
        
        function preview_gray(app,~, event, himage)
            himage.CData = event.Data(:,:,1);
        end
        
        function preview_infrared_adjust(app,~, event, himage)
            img = (app.normalize_adjust(event.Data) .* 64);
            img = imrotate(img, 90);
            himage.CData = img;
        end
        
        

        function camview = set_camview_default(app,camview)
            camview.XTick = [];
            camview.YTick = [];
            camview.CLim = [0, 255];
            camview.CLimMode = 'manual';
            camview.DataAspectRatio = [1, 1, 1];
        end



    end

    
end
