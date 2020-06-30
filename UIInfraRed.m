classdef UIInfraRed < matlab.apps.AppBase

% the publich properties
    properties (Access = public)
    UI                              matlab.ui.Figure
    Container                       matlab.ui.container.GridLayout
    end


% private properties
    properties (Access = public)
    % Titels   
    text5                           matlab.ui.control.Label

    %Axes
    camview_infrared                matlab.ui.control.UIAxes

    %Buttons
    live_infrared                   matlab.ui.control.Button
    stop_infrared                   matlab.ui.control.Button
    snapshot_infrared               matlab.ui.control.Button

    end

    %public Methods
    methods (Access = public)

        %constructor
        function obj= UIInfraRed(UI, parent,id)
            
            obj.UI= UI;
            obj.Container=uigridlayout(parent);


            %obj.Container.RowHeight = {30,30,30,30,'1x'};
            %obj.Container.ColumnWidth = {'1x',130};
            
            %dynamic
            obj.Container.RowHeight = {'0.15x','0.15x','0.15x','0.15x','1x'};
            obj.Container.ColumnWidth = {'3x','1x'};
            
            infra_img= imread("infrared.jpg");
            

            % text5 of the element
            obj.text5 = uilabel(obj.Container);
            obj.text5.Text = "Infrarot ";
            %obj.text5.FontWeight = "bold";
            obj.text5.FontSize = 26;
            obj.text5.HorizontalAlignment = "center";
            % obj.text5.VerticalAlignment = 'top';
            obj.text5.Layout.Row = 1;
            obj.text5.Layout.Column = 1;



            % axes on which plotting takes place
            obj.camview_infrared = uiaxes(obj.Container);
            obj.camview_infrared.Layout.Row = [2, 5];
            obj.camview_infrared.Layout.Column = 1;
            % set image to show on the Axes on startup
            imshow(infra_img,'Parent',obj.camview_infrared);

            

            %%%%%%%%%%%%%%%%%%%%%%%% Buttons %%%%%%%%%%%%%%%%%%
             % button to live_infrared function
             obj.live_infrared = uibutton(obj.Container);
             obj.live_infrared.Text = "Livebild";
             obj.live_infrared.Enable='off';
             obj.live_infrared.FontSize = 16;
             obj.live_infrared.Layout.Row = 2;
             obj.live_infrared.Layout.Column = 2;



              % button to Stopp function
            obj.stop_infrared = uibutton(obj.Container);
            obj.stop_infrared.Text = "Stopp";
            obj.stop_infrared.Enable='off';
            obj.stop_infrared.FontSize = 16;
            obj.stop_infrared.Layout.Row = 3;
            obj.stop_infrared.Layout.Column = 2;

             % button to Bilaufnahme function
             obj.snapshot_infrared = uibutton(obj.Container);
             obj.snapshot_infrared.Text = "Einzelbild";
             obj.snapshot_infrared.Enable='off'; 
             obj.snapshot_infrared.FontSize = 16;
             obj.snapshot_infrared.Layout.Row = 4;
             obj.snapshot_infrared.Layout.Column = 2;

             
             
             obj.Container.Padding = [10 10 10 10];




             

        end
        
    end




end
        