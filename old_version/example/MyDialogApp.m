classdef MyDialogApp < matlab.apps.AppBase

    properties(Access = public)

        UIFigure        matlab.ui.Figure
        Container       matlab.ui.container.GridLayout
        SampleEdite     matlab.ui.control.NumericEditField
        LabelSample     matlab.ui.control.Label
        ColorMapDrop    matlab.ui.control.DropDown
        DropLabel       matlab.ui.control.Label
        Button          matlab.ui.control.Button

        % end properties 1
    end

    properties (Access = private)
        CallingApp

        % end properties 2
    end

    methods(Access = public)

        function app=MyDialogApp(varargin)
            
            % Create the UI 
            app.UIFigure=uifigure('Visible','on');
            app.UIFigure.Name= 'Options';
            app.UIFigure.WindowState = 'normal';
            app.UIFigure.CloseRequestFcn= createCallbackFcn(app,@DialogAppColseRequest, true);
            app.Container=uigridlayout(app.UIFigure);
            app.Container.RowHeight= {30,30,30};
            app.Container.ColumnWidth= {'2x',100,'2x'};
            app.Container.Padding = [10 10 10 10];
            app.UIFigure.Visible='on';
            app.UIFigure.Position=[500 500 350 200];
            
            % Label Samples
            app.LabelSample=uilabel(app.Container);
            app.LabelSample.Layout.Row= 1;
            app.LabelSample.Layout.Column= 1;
            app.LabelSample.FontSize= 18;
            app.LabelSample.Text='Samples';

            % Field Samples
            app.SampleEdite=uieditfield(app.Container, 'numeric');
            app.SampleEdite.Layout.Row=1;
            app.SampleEdite.Layout.Column=3;
            app.SampleEdite.Value=2;
            app.SampleEdite.FontSize= 18;
            app.SampleEdite.Limits=[2 1000];
            app.SampleEdite.HorizontalAlignment='center';

             % Create ColormapDropDownLabel
             app.DropLabel = uilabel(app.Container);
            %  app.DropLabel.HorizontalAlignment = 'right';
            %  app.DropLabel.VerticalAlignment = 'top';
             app.DropLabel.Layout.Row = 2;
             app.DropLabel.Layout.Column = 1;
             app.DropLabel.Text = 'Colormap';
             app.DropLabel.FontSize= 18;
 
             % Create DropDown
             app.ColorMapDrop = uidropdown(app.Container);
             app.ColorMapDrop.Items = {'Parula', 'Jet', 'Winter', 'Cool'};
             app.ColorMapDrop.Layout.Row = 2;
             app.ColorMapDrop.Layout.Column = 3;
             app.ColorMapDrop.Value = 'Parula';
             app.ColorMapDrop.FontSize= 18;
 
             % Create Button
             app.Button = uibutton(app.Container, 'push');
             app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
             app.Button.Layout.Row = 3;
             app.Button.Layout.Column = 2;
             app.Button.Text = 'OK';
             app.Button.FontSize= 18;
 
             % Show the figure after all components are created
            %  app.UIFigure.Visible = 'on';

             StartupFcn(app, varargin{:})

        end

        function delete(app)
            delete(app.UIFigure)
        end

    end

    methods(Access = private)

        function StartupFcn(app, mainapp, sz, c)

            app.CallingApp=mainapp;

            app.SampleEdite.Value=sz;
            app.ColorMapDrop.Value=c;
        end

        function  DialogAppColseRequest(app, event)
            app.CallingApp.OptionsButton.Enable = 'on';
        
            delete(app)
        end

        function ButtonPushed(app, event)
            % Call main app's public function
            updateplot(app.CallingApp, app.SampleEdite.Value, app.ColorMapDrop.Value);
            % Delete the dialog box
            delete(app)
        end
    end




% end class
end