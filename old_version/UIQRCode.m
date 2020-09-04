classdef UIQRCode < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        LiveView   matlab.ui.control.Button
        StopView                matlab.ui.control.Button
        TakePic                 matlab.ui.control.Button
        DetectPic               matlab.ui.control.Button
        init_app
    end

    % private properties
    properties (Access = public)
        Headline                matlab.ui.control.Label
        camview_webcam          matlab.ui.control.UIAxes
        TextLabel               matlab.ui.control.Label
        TextLabel2              matlab.ui.control.Label
    end
    

    methods (Access = public)
        % --- Executes on button press in live_webcam.
        % Receive the UIInitiaialize app from UIInitialize
        function receive_init_from_UIInitialize(app, app_obj)
            app.init_app=app_obj;
        end

        function live_webcam_Callback(app, ~) 

            app = enable_webcam(app, 'off');
        
            if ~app.init_app.webcam.preview(false, app.camview_webcam)
                waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
            end
        
            enable_webcam(app, 'on');

        end

        function qr_button_Callback(app, ~)

            app = enable_webcam(app, 'off');

        
            try
                img = getimage(app.camview_webcam);

                text = decode_qr(img);
                if isempty(text)
                    color = [1, 0, 0];
                    text = 'Nichts erkannt ...';
                else
                    color = [0, 1, 0];
                end
                app.TextLabel2.Text = text;
                app.TextLabel2.ForegroundColor = color;
            catch e
                warning('QR-Code exception: %s', getReport(e));
                waitfor(msgbox('Interner Fehler während der QR-Code-Erkennung.', 'Fehler', 'warn'));
            end
        
            enable_webcam(app, 'on');
        end

        % --- Executes on button press in snapshot_webcam.
        function snapshot_webcam_Callback(app, ~)

                app = enable_webcam(app, 'off');

            
                fprintf('Webcam start\n');
                if ~app.init_app.webcam.snapshot(false, app.camview_webcam)
                    waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
                end
                fprintf('Webcam end\n');
            
                enable_webcam(app, 'on');
            end

        % --- Executes on button press in stop_webcam.
        function stop_webcam_Callback(app, ~)

            app = enable_webcam(app, 'off');
        
            if ~app.init_app.webcam.stoppreview()
                waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
            end
        
            enable_webcam(app, 'on');

        end




        % the Enables... 
        function app = enable_webcam(app, value)

            if ~is_webcam(app.init_app) || app.demo
                return;
            end

            app.LiveView.Enable=value;
            app.StopView.Enable=value;
            app.TakePic.Enable=value;
            app.DetectPic.Enable=value;

            if is_serial_port(app.init_app)
                app.init_app.demo_app.demomode.Enable = value;
            end
        end

    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function app = UIQRCode(UI, parent, id)
            % set the superior window (uifigure)
            app.UI = UI;

            % create the main layout with the given element as parent
            app.Container = uigridlayout(parent);

            % make a grid layour with 8 rows and 3 columns
            %app.Container.RowHeight = {30, 30, 30, 30, 30, '1x', 40, 30};
            %app.Container.ColumnWidth = {50, '1x', 130};
            
            %dynamic
            app.Container.RowHeight = {'0.25x', '0.25x', '0.25x', '0.25x', '0.25x', '1x', '0.2x', '0.2x'};
            app.Container.ColumnWidth = {'0.4x', '3x', '1.13x'};
            
            img_webcam= imread("qr_code.png");

            % headline of the element
            app.Headline = uilabel(app.Container);
            app.Headline.Text = "Webcam QR-Code";
            %app.Headline.FontWeight = "bold";
            app.Headline.FontSize = 26;
            app.Headline.HorizontalAlignment = "center";
            app.Headline.Layout.Row = 1;
            app.Headline.Layout.Column = 2;
            
            % axes on which plotting takes place
            app.camview_webcam = uiaxes(app.Container);
            app.camview_webcam.Layout.Row = [2, 6];
            app.camview_webcam.Layout.Column = 2;
            % set image to show on the Axes on startup
            imshow(img_webcam,'Parent',app.camview_webcam);

            


            % button to live view
            app.LiveView = uibutton(app.Container);
            app.LiveView.Text = "Livebild";
            app.LiveView.Enable='off';
            app.LiveView.FontSize = 16;
            app.LiveView.Layout.Row = 2;
            app.LiveView.Layout.Column = 3;
            app.LiveView.ButtonPushedFcn = createCallbackFcn(app, @live_webcam_Callback, true);

            


            % button to stop the live view
            app.StopView = uibutton(app.Container);
            app.StopView.Text = "Stopp";
            app.StopView.Enable='off';
            app.StopView.FontSize = 16;
            app.StopView.Layout.Row = 3;
            app.StopView.Layout.Column = 3;
            app.StopView.ButtonPushedFcn = createCallbackFcn(app, @stop_webcam_Callback, true);
            

            % button to take a pic
            app.TakePic = uibutton(app.Container);
            app.TakePic.Text = "Einzelbild";
            app.TakePic.Enable='off';
            app.TakePic.FontSize = 16;
            app.TakePic.Layout.Row = 4;
            app.TakePic.Layout.Column = 3;
            app.TakePic.ButtonPushedFcn = createCallbackFcn(app, @snapshot_webcam_Callback, true);
            
            
            % button to start recognizing
            app.DetectPic = uibutton(app.Container);
            app.DetectPic.Text = "Erkennen";
            app.DetectPic.Enable='off';
            app.DetectPic.FontSize = 16;
            app.DetectPic.Layout.Row = 5;
            app.DetectPic.Layout.Column = 3;
            app.DetectPic.ButtonPushedFcn = createCallbackFcn(app, @qr_button_Callback, true);
            
            
            % Create TextLabel
            app.TextLabel = uilabel(app.Container);
            app.TextLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.TextLabel.FontSize = 20;
            app.TextLabel.Layout.Row = 7;
            app.TextLabel.Layout.Column = 1;
            app.TextLabel.Text = 'Text :';
            
            % Create TextTextArea
            app.TextLabel2 = uilabel(app.Container);
            app.TextLabel2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.TextLabel2.FontSize = 20;
            app.TextLabel2.Layout.Row = 7;
            app.TextLabel2.Layout.Column = 2;
            app.TextLabel2.Text = ' ';

            app.Container.Padding = [10 10 10 10];
            
                    


        end
    end
end
