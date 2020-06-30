classdef UIControls < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        Cameras
    end

    % private properties
    properties (Access = private)
        
        Component1  UIInitialize
        Component2  UIBattery
        Component3  UIRailway
        Component4  UILeds
        Component5  UIHalogenLamp
        Component6  UIDemoMode
           
        
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function obj = UIControls(UI, parent, obj_rec)
            % create a new window
            obj.UI = UI;
            %obj.UI.Name = "Controls";
            obj.Cameras=obj_rec;

            % create the main layout for the window
            obj.Container = uigridlayout(parent);
            obj.Container.RowHeight = {'1.5x', '0.8x', '1x', '1x', '1x', '1x' , '1x', '1x', '1x', '1x', '1x', '1x'};
            obj.Container.ColumnWidth = {'1x'};
            
            % the 6th GUI component
            obj.Component2 = UIBattery(obj.UI, obj.Container);
            obj.Component2.Container.Layout.Row = 2;
            obj.Component2.Container.Layout.Column = 1;
            
            % the 7th GUI component
            obj.Component3 = UIRailway(obj.UI, obj.Container);
            obj.Component3.Container.Layout.Row = [3 5];
            obj.Component3.Container.Layout.Column = 1;
            
            % the 8th GUI component
            obj.Component4 = UILeds(obj.UI, obj.Container);
            obj.Component4.Container.Layout.Row = [6 8];
            obj.Component4.Container.Layout.Column = 1;
            
            % the 9th GUI component
            obj.Component5 = UIHalogenLamp(obj.UI, obj.Container);
            obj.Component5.Container.Layout.Row = [9 10];
            obj.Component5.Container.Layout.Column = 1;
            
            % the 10th GUI component
            obj.Component6 = UIDemoMode(obj.UI, obj.Container);
            obj.Component6.Container.Layout.Row = 11;
            obj.Component6.Container.Layout.Column = 1;
            
            % the third GUI component
            obj.Component1 = UIInitialize(obj.UI,obj.Container,obj.Component2,obj.Component3,obj.Component4,obj.Component5,obj.Component6,obj.Cameras);
            obj.Component1.Container.Layout.Row = 1;
            obj.Component1.Container.Layout.Column = 1;

            
        end
    end
end
