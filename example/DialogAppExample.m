classdef DialogAppExample < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        SampleSizeEditFieldLabel  matlab.ui.control.Label
        EditField                 matlab.ui.control.NumericEditField
        ColormapDropDownLabel     matlab.ui.control.Label
        DropDown                  matlab.ui.control.DropDown
        Button                    matlab.ui.control.Button
    end


    properties (Access = private)
        CallingApp   % Main app object
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function StartupFcn(app, mainapp, sz, c)
            % Store main app in property for CloseRequestFcn to use
            app.CallingApp = mainapp;
            
            % Update UI with input values
            app.EditField.Value = sz;
            app.DropDown.Value = c;
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            % Call main app's public function
            updateplot(app.CallingApp, app.EditField.Value, app.DropDown.Value);
            
            % Delete the dialog box
            delete(app)
        end

        % Close request function: UIFigure
        function DialogAppCloseRequest(app, event)
            % Enable the Plot Opions button in main app
            app.CallingApp.OptionsButton.Enable = 'on';
            
            % Delete the dialog box 
            delete(app)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'on');
            app.UIFigure.Position = [600 100 392 248];
            app.UIFigure.Name = 'Options';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @DialogAppCloseRequest, true);

            % Create SampleSizeEditFieldLabel
            app.SampleSizeEditFieldLabel = uilabel(app.UIFigure);
            app.SampleSizeEditFieldLabel.HorizontalAlignment = 'right';
            app.SampleSizeEditFieldLabel.VerticalAlignment = 'top';
            app.SampleSizeEditFieldLabel.Position = [102 160 74 15];
            app.SampleSizeEditFieldLabel.Text = 'Sample Size';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'numeric');
            app.EditField.Limits = [2 1000];
            app.EditField.Position = [191 156 100 22];
            app.EditField.Value = 35;

            % Create ColormapDropDownLabel
            app.ColormapDropDownLabel = uilabel(app.UIFigure);
            app.ColormapDropDownLabel.HorizontalAlignment = 'right';
            app.ColormapDropDownLabel.VerticalAlignment = 'top';
            app.ColormapDropDownLabel.Position = [117 106 59 15];
            app.ColormapDropDownLabel.Text = 'Colormap';

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = {'Parula', 'Jet', 'Winter', 'Cool'};
            app.DropDown.Position = [191 102 100 22];
            app.DropDown.Value = 'Parula';

            % Create Button
            app.Button = uibutton(app.UIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [116 43 174 22];
            app.Button.Text = 'OK';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DialogAppExample(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)StartupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end