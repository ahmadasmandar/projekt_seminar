classdef UILegoCity < handle
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
    end

    % private properties
    properties (Access = private)
        Component1 UICameras
        Component2 UIControls
    end

    % public methods
    methods (Access = public)
        
        % set the UIPosition to screen size 
        function startupFcn(obj)
              screenSize = get(0,'ScreenSize');
              %screenSize = get(0,'MonitorPositions');
              screenWidth = screenSize(3);
              screenHeight = screenSize(4);
              left = screenWidth*0;
              bottom = screenHeight*0;
              width = screenWidth;
              height = screenHeight;
              drawnow;
              obj.UI.Position = [left bottom width height]; 
          end
        
        % the class contructor has the same name as the class
        function obj = UILegoCity()
            % create a new window
            obj.UI = uifigure('Visible', 'off');
            obj.UI.Name = "Lego-City";
            % set the units to pixels
            set(0,'units','pixels');
            
            % checking the screen resolution
            %before = get(0, 'MonitorPositions')
            %obj.UI.WindowState = 'fullscreen';
            
            startupFcn(obj);
            
            % setting the UI size to FHD resolution
            %obj.UI.Position = [0 0 1920 1080]; 
            
            obj.UI.WindowState = 'maximized';

            
            % create the main layout for the window
            obj.Container = uigridlayout(obj.UI);
            obj.Container.RowHeight = {'1x'};
            obj.Container.ColumnWidth = {'2x', '0.5x'};
                         % the first GUI component
            obj.Component1 = UICameras(obj.UI, obj.Container, 1);
            obj.Component1.Container.Padding = 0;



            % the second GUI component
            obj.Component2 =UIControls(obj.UI, obj.Container, obj.Component1);
            obj.Component2.Container.Padding = 0;
            get(0,'ScreenSize')
            

            % see the changes
            %after = get(0, 'MonitorPositions')
            obj.UI.Visible='on';
            
        end
    end
end
