classdef UIMultiSpectral < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
    end

    % private properties
    properties (Access = public)
        Headline                matlab.ui.control.Label
        %Image                  matlab.ui.control.Image
        camview_multispectral   matlab.ui.control.UIAxes
        LiveView                matlab.ui.control.Button
        StopView                matlab.ui.control.Button
        TakePic                 matlab.ui.control.Button
    
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function obj = UIMultiSpectral(UI, parent, id)
            % set the superior window (uifigure)
            obj.UI = UI;

            % create the main layout with the given element as parent
            obj.Container = uigridlayout(parent);

            % make a grid layour with 7 rows and 2 columns
            %obj.Container.RowHeight = {30, 30, 30, 30, 30, '1x', 30};
            %obj.Container.ColumnWidth = {'2x', 130};
            
            %dynamic
            obj.Container.RowHeight = {'0.2x', '0.2x', '0.2x', '0.2x', '0.2x', '1x', '0.2x'};
            obj.Container.ColumnWidth = {'3x', '1x'};
            
            img_multispectral= imread("multispectral.jpg");

            % headline of the element
            obj.Headline = uilabel(obj.Container);
            obj.Headline.Text = "Multispektral";
            %obj.Headline.FontWeight = "bold";
            obj.Headline.FontSize = 26;
            obj.Headline.HorizontalAlignment = "center";
            obj.Headline.Layout.Row = 1;
            obj.Headline.Layout.Column = 1;
            
            % axes on which plotting takes place
            obj.camview_multispectral = uiaxes(obj.Container);
            obj.camview_multispectral.Layout.Row = [2, 6];
            obj.camview_multispectral.Layout.Column = 1;
            % set image to show on the Axes on startup
            imshow(img_multispectral,'Parent',obj.camview_multispectral);
            
            % Create Image
            %obj.Image = uiimage(obj.Container);
            %obj.Image.ScaleMethod = 'none';
            %obj.Image.Layout.Row = [2, 6];
            %obj.Image.Layout.Column = 2;
            %obj.Image.ImageSource = 'multispectral.jpg';


            % button to live view
            obj.LiveView = uibutton(obj.Container);
            obj.LiveView.Text = "Livebild";
            obj.LiveView.Enable='off';
            obj.LiveView.FontSize = 16;
            obj.LiveView.Layout.Row = 2;
            obj.LiveView.Layout.Column = 2;



            % button to stop the view
            obj.StopView = uibutton(obj.Container);
            obj.StopView.Text = "Stopp";
            obj.StopView.Enable='off';
            obj.StopView.FontSize = 16;
            obj.StopView.Layout.Row = 3;
            obj.StopView.Layout.Column = 2;


            % button to take a pic
            obj.TakePic = uibutton(obj.Container);
            obj.TakePic.Text = "Einzelbild";
            obj.TakePic.Enable='off';
            obj.TakePic.FontSize = 16;
            obj.TakePic.Layout.Row = 4;
            obj.TakePic.Layout.Column = 2;

            obj.Container.Padding = [10 10 10 10];
            


        end
        
    end 
    
end
