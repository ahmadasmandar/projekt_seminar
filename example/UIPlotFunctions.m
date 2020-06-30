classdef UIPlotFunctions < handle
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
    end

    % private properties
    properties (Access = private)
        Headline   matlab.ui.control.Label
        ValueL     matlab.ui.control.Label
        Value      matlab.ui.control.Spinner
        View       matlab.ui.control.UIAxes
        PlotLinear matlab.ui.control.Button
        PlotSinus  matlab.ui.control.Button
        Exit_b     matlab.ui.control.Button
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function obj = UIPlotFunctions(UI, parent, id)
            % set the superior window (uifigure)
            obj.UI = UI;

            % create the main layout with the given element as parent
            obj.Container = uigridlayout(parent);

            % make a grid layour with 5 rows and 3 columns
            obj.Container.RowHeight = {20, 22, 22, 22, 22,'1x'};
            obj.Container.ColumnWidth = {'1x', 10, 70};

            % headline of the element
            obj.Headline = uilabel(obj.Container);
            obj.Headline.Text = "Plot a function! ID(" + id + ")";
            obj.Headline.FontWeight = "bold";
            obj.Headline.FontSize = 16;
            obj.Headline.HorizontalAlignment = "center";
            obj.Headline.Layout.Row = 1;
            obj.Headline.Layout.Column = [1, 3];

            % axes on which plotting takes place
            obj.View = uiaxes(obj.Container);
            obj.View.Layout.Row = [2, 6];
            obj.View.Layout.Column = 1;

            % spinner to get an value from the user
            obj.ValueL = uilabel(obj.Container);
            obj.ValueL.Text = "A:";
            obj.ValueL.Layout.Row = 2;
            obj.ValueL.Layout.Column = 2;

            obj.Value = uispinner(obj.Container);
            obj.Value.Value = 1;
            obj.Value.Layout.Row = 2;
            obj.Value.Layout.Column = 3;

            % button to plot a linear function
            obj.PlotLinear = uibutton(obj.Container);
            obj.PlotLinear.Text = "f(x) = A * x";
            obj.PlotLinear.Layout.Row = 3;
            obj.PlotLinear.Layout.Column = [2, 3];
            obj.PlotLinear.ButtonPushedFcn = @(~, ~) obj.onPlotLinear();

            % button to plot a sinus function
            obj.PlotSinus = uibutton(obj.Container);
            obj.PlotSinus.Text = "f(x) = sin(A * x)";
            obj.PlotSinus.Layout.Row = 4;
            obj.PlotSinus.Layout.Column = [2, 3];
            obj.PlotSinus.ButtonPushedFcn = @(~, ~) obj.onPlotSinus();
            
            
            % button to exit function
            obj.Exit_b = uibutton(obj.Container);
            obj.Exit_b.Text = "EXit";
            obj.Exit_b.Layout.Row = 5;
            obj.Exit_b.Layout.Column = [2, 3];
            obj.Exit_b.ButtonPushedFcn = @(~, ~) obj.onExit();
        
        
        end
    end

    % private methods
    methods (Access = public)
        function StartupFcn(obj,mainapp)
            % Store main app object
            obj.CallingApp = mainapp;
        
            % Process sz and c inputs
            ...
        end
        function value_all= onPlotLinear(obj)
            % get user variable A
            a = obj.Value.Value;

            % calculate plot data
            x = -5:0.1:5;
            y = a * x;
            % show data

            plot(obj.View, x, y);
        end

        function onPlotSinus(obj)
            % get user variable A
            a = obj.Value.Value;

            % calculate plot data
            x = -5:0.1:5;
            y = sin(a * x);

            % show data
            plot(obj.View, x, y);
            
        end
        
        function onExit(event)
            % get user variable A
            clear;
            clc;
            closereq;
            clear;
        end
    end
end
