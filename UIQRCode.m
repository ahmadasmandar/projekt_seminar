classdef UIQRCode < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        LiveView   matlab.ui.control.Button
        StopView                matlab.ui.control.Button
        TakePic                 matlab.ui.control.Button
        DetectPic               matlab.ui.control.Button
    end

    % private properties
    properties (Access = private)
        Headline                matlab.ui.control.Label
        camview_webcam          matlab.ui.control.UIAxes
        TextLabel               matlab.ui.control.Label
        TextLabel2              matlab.ui.control.Label
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function obj = UIQRCode(UI, parent, id)
            % set the superior window (uifigure)
            obj.UI = UI;

            % create the main layout with the given element as parent
            obj.Container = uigridlayout(parent);

            % make a grid layour with 8 rows and 3 columns
            %obj.Container.RowHeight = {30, 30, 30, 30, 30, '1x', 40, 30};
            %obj.Container.ColumnWidth = {50, '1x', 130};
            
            %dynamic
            obj.Container.RowHeight = {'0.25x', '0.25x', '0.25x', '0.25x', '0.25x', '1x', '0.2x', '0.2x'};
            obj.Container.ColumnWidth = {'0.4x', '3x', '1.13x'};
            
            img_webcam= imread("qr_code.png");

            % headline of the element
            obj.Headline = uilabel(obj.Container);
            obj.Headline.Text = "Webcam QR-Code";
            %obj.Headline.FontWeight = "bold";
            obj.Headline.FontSize = 26;
            obj.Headline.HorizontalAlignment = "center";
            obj.Headline.Layout.Row = 1;
            obj.Headline.Layout.Column = 2;
            
            % axes on which plotting takes place
            obj.camview_webcam = uiaxes(obj.Container);
            obj.camview_webcam.Layout.Row = [2, 6];
            obj.camview_webcam.Layout.Column = 2;
            % set image to show on the Axes on startup
            imshow(img_webcam,'Parent',obj.camview_webcam);

            
            % Create Image
            %obj.Image = uiimage(obj.Container);
            %obj.Image.ScaleMethod = 'fill';
            %obj.Image.Layout.Row = [2, 6];
            %obj.Image.Layout.Column = 2;
            %obj.Image.ImageSource = 'qr-code.png';


            % button to live view
            obj.LiveView = uibutton(obj.Container);
            obj.LiveView.Text = "Livebild";
            obj.LiveView.Enable='off';
            obj.LiveView.FontSize = 16;
            obj.LiveView.Layout.Row = 2;
            obj.LiveView.Layout.Column = 3;
            


            % button to stop the live view
            obj.StopView = uibutton(obj.Container);
            obj.StopView.Text = "Stopp";
            obj.StopView.Enable='off';
            obj.StopView.FontSize = 16;
            obj.StopView.Layout.Row = 3;
            obj.StopView.Layout.Column = 3;
            

            % button to take a pic
            obj.TakePic = uibutton(obj.Container);
            obj.TakePic.Text = "Einzelbild";
            obj.TakePic.Enable='off';
            obj.TakePic.FontSize = 16;
            obj.TakePic.Layout.Row = 4;
            obj.TakePic.Layout.Column = 3;
            
            
            % button to start recognizing
            obj.DetectPic = uibutton(obj.Container);
            obj.DetectPic.Text = "Erkennen";
            obj.DetectPic.Enable='off';
            obj.DetectPic.FontSize = 16;
            obj.DetectPic.Layout.Row = 5;
            obj.DetectPic.Layout.Column = 3;
            
            
            % Create TextLabel
            obj.TextLabel = uilabel(obj.Container);
            obj.TextLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            obj.TextLabel.FontSize = 20;
            obj.TextLabel.Layout.Row = 7;
            obj.TextLabel.Layout.Column = 1;
            obj.TextLabel.Text = 'Text :';
            
            % Create TextTextArea
            obj.TextLabel2 = uilabel(obj.Container);
            obj.TextLabel2.BackgroundColor = [0.9412 0.9412 0.9412];
            obj.TextLabel2.FontSize = 20;
            obj.TextLabel2.Layout.Row = 7;
            obj.TextLabel2.Layout.Column = 2;
            obj.TextLabel2.Text = ' ';

            obj.Container.Padding = [10 10 10 10];
            
                    


        end
    end
end
