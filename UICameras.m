classdef UICameras < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout   
        connect       
    end

    % private properties
    properties (Access = public)
        Component1  UIQRCode
        Component2  UILaser
        Component3  UIMultiSpectral
        Component4  UIInfraRed
        
        
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function obj = UICameras(UI, parent, id)
            % create a new window
            obj.UI = UI;
            %obj.UI.Name = "Cameras";

            % create the main layout for the window
            obj.Container = uigridlayout(parent);
            obj.Container.RowHeight = {'1x' , '1x','0x'};
            obj.Container.ColumnWidth = {'1x', '1x','0x'};

            % the first GUI component
            obj.Component1 = UIQRCode(obj.UI, obj.Container);
            obj.Component1.Container.Layout.Row = 1;
            obj.Component1.Container.Layout.Column = 1;


            % the second GUI component
            obj.Component2 = UILaser(obj.UI, obj.Container);
            obj.Component2.Container.Layout.Row = 1;
            obj.Component2.Container.Layout.Column = 2;

            
            % the third GUI component
            obj.Component3 = UIMultiSpectral(obj.UI, obj.Container);
            obj.Component3.Container.Layout.Row = 2;
            obj.Component3.Container.Layout.Column = 1;



            % the fourth GUI component
            obj.Component4 = UIInfraRed(obj.UI, obj.Container);
            obj.Component4.Container.Layout.Row = 2;
            obj.Component4.Container.Layout.Column = 2;
            % send the objects to the Initialize
            obj.connect=UIControls(obj.UI,obj.Container,obj);
            obj.connect.Container.Layout.Row = 3;
            obj.connect.Container.Layout.Column = 3;
            % obj.connect.Visible='off';
            


            
        end
    end
end
