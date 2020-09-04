classdef UICameras < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        % * Objct to send data to other apps   
        connect       
    end

    % private properties
    properties (Access = public)
        QRCode  UIQRCode
        Laser  UILaser
        MultiSpectral  UIMultiSpectral
        InfraRed  UIInfraRed
        
        
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
            obj.QRCode = UIQRCode(obj.UI, obj.Container);
            obj.QRCode.Container.Layout.Row = 1;
            obj.QRCode.Container.Layout.Column = 1;


            % the second GUI component
            obj.Laser = UILaser(obj.UI, obj.Container);
            obj.Laser.Container.Layout.Row = 1;
            obj.Laser.Container.Layout.Column = 2;

            
            % the third GUI component
            obj.MultiSpectral = UIMultiSpectral(obj.UI, obj.Container);
            obj.MultiSpectral.Container.Layout.Row = 2;
            obj.MultiSpectral.Container.Layout.Column = 1;



            % the fourth GUI component
            obj.InfraRed = UIInfraRed(obj.UI, obj.Container);
            obj.InfraRed.Container.Layout.Row = 2;
            obj.InfraRed.Container.Layout.Column = 2;


            % send the objects to the Initialize
            % obj.connect=UIControls(obj.UI,obj.Container,obj);
            % obj.connect.Container.Layout.Row = 3;
            % obj.connect.Container.Layout.Column = 3;
            % % obj.connect.Visible='off';
            


            
        end
    end
end
