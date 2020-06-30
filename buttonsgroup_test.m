classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure     matlab.ui.Figure
        ButtonGroup  matlab.ui.container.ButtonGroup
        Button       matlab.ui.control.RadioButton
        Button2      matlab.ui.control.RadioButton
        Button3      matlab.ui.control.RadioButton
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            selectedButton = app.ButtonGroup.SelectedObject;
            disp(selectedButton.Text);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.UIFigure);
            app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            app.ButtonGroup.Title = 'Button Group';
            app.ButtonGroup.Position = [87 224 198 151];

            % Create Button
            app.Button = uiradiobutton(app.ButtonGroup);
            app.Button.Text = 'Button';
            app.Button.Position = [11 105 58 22];
            app.Button.Value = true;

            % Create Button2
            app.Button2 = uiradiobutton(app.ButtonGroup);
            app.Button2.Text = 'Button2';
            app.Button2.Position = [11 83 65 22];

            % Create Button3
            app.Button3 = uiradiobutton(app.ButtonGroup);
            app.Button3.Text = 'Button3';
            app.Button3.Position = [11 61 65 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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