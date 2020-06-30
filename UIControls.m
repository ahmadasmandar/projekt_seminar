classdef UIControls < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        
    end

    % private properties
    properties (Access = public)
        
        UIInitialize_Obj    UIInitialize
        UIBattery_Obj       UIBattery
        UIRailway_Obj       UIRailway
        UILeds_Obj          UILeds
        UIHalogenLamp_Obj   UIHalogenLamp
        UIDemoMode_Obj      UIDemoMode
        Cameras_Obj
           
        
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        % ***************************************
        % here we receive the Cameras object from UILegoCity.m line 61
        function app = UIControls(UI, parent, Cameras_object)
            % create a new window
            app.UI = UI;

            % *************************
            % here we init the received Cameras object from LegocityUI line 61
            app.Cameras_Obj=Cameras_object;

            % create the main layout for the window
            app.Container = uigridlayout(parent);
            app.Container.RowHeight = {'1.5x', '0.8x', '1x', '1x', '1x', '1x' , '1x', '1x', '1x', '1x', '1x', '1x'};
            app.Container.ColumnWidth = {'1x'};
            
            % the Battery component
            app.UIBattery_Obj = UIBattery(app.UI, app.Container);
            app.UIBattery_Obj.Container.Layout.Row = 2;
            app.UIBattery_Obj.Container.Layout.Column = 1;
            
            % the Railway component
            app.UIRailway_Obj = UIRailway(app.UI, app.Container);
            app.UIRailway_Obj.Container.Layout.Row = [3 5];
            app.UIRailway_Obj.Container.Layout.Column = 1;
            
            % the Leds component
            app.UILeds_Obj = UILeds(app.UI, app.Container);
            app.UILeds_Obj.Container.Layout.Row = [6 8];
            app.UILeds_Obj.Container.Layout.Column = 1;
            
            % the HalogenLamp component
            app.UIHalogenLamp_Obj = UIHalogenLamp(app.UI, app.Container);
            app.UIHalogenLamp_Obj.Container.Layout.Row = [9 10];
            app.UIHalogenLamp_Obj.Container.Layout.Column = 1;
            
            % the DemoMode component
            app.UIDemoMode_Obj = UIDemoMode(app.UI, app.Container);
            app.UIDemoMode_Obj.Container.Layout.Row = 11;
            app.UIDemoMode_Obj.Container.Layout.Column = 1;
            
            % the Initialize component
            % **************************
            % here we send the hole object to the UIInitialize app 

            app.UIInitialize_Obj = UIInitialize(app.UI,app.Container,app);

            app.UIInitialize_Obj.Container.Layout.Row = 1;
            app.UIInitialize_Obj.Container.Layout.Column = 1;

            
        end
    end
end
