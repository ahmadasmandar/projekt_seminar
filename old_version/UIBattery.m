classdef UIBattery < handle
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
    end

    % private properties
    properties (Access = private)
        
        battery_label           matlab.ui.control.Label
        
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function obj = UIBattery(UI, parent, id)
            % set the superior window (uifigure)
            obj.UI = UI;

            % create the main layout with the given element as parent
            obj.Container = uigridlayout(parent);

            % make a grid layour with 7 rows and 4 columns
            obj.Container.RowHeight = {'1x'};
            obj.Container.ColumnWidth = {'1x'};
            
            % Create battery_label
            obj.battery_label = uilabel(obj.Container);
            obj.battery_label.HorizontalAlignment = 'left';
            obj.battery_label.FontSize = 26;
            obj.battery_label.Layout.Row = 1;
            obj.battery_label.Layout.Column = 1;
            obj.battery_label.Text = 'Akku: Unbekannt';

            
            obj.Container.Padding = [10 10 10 10];


          

        end
    end
end
