classdef UIProjectName < handle
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
    end

    % private properties
    properties (Access = private)
        Component1 UIPlotFunctions
        Component2 UIPlotFunctions
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function obj = UIProjectName()
            % create a new window
            obj.UI = uifigure();
            obj.UI.Name = "Project name";

            % create the main layout for the window
            obj.Container = uigridlayout(obj.UI);
            obj.Container.RowHeight = {'1x'};
            obj.Container.ColumnWidth = {'1x', '2x'};

            % the first GUI component
            obj.Component1 = UIPlotFunctions(obj.UI, obj.Container, 1);
            obj.Component1.Container.Padding = 0;

            % the second GUI component
            obj.Component2 = UIPlotFunctions(obj.UI, obj.Container, 2);
            obj.Component2.Container.Padding = 0;
        end
    end
end
