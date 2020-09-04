classdef UIHalogenLamp < matlab.apps.AppBase
% the publich properties
    properties (Access = public)
    UI                              matlab.ui.Figure
    Container                       matlab.ui.container.GridLayout
    uibuttongroup3          matlab.ui.container.ButtonGroup
    halo1                   matlab.ui.control.RadioButton
    halo0                   matlab.ui.control.RadioButton
    haloA                   matlab.ui.control.RadioButton
    serial_handler
    end

    methods (Access = public)

        % Receive Serial Object from mainapp
        function receive_serial_handler(app,serial_handler_ext)
            app.serial_handler=serial_handler_ext;
            disp('halogen_serial object received successfully')
        end
    end

    % private properties
    methods (Access = private)
        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            selectedButton = app.uibuttongroup3.SelectedObject;
            try
                switch(selectedButton.Text)
                    case 'Aus'
                        val = 0;
                    case 'An'
                        val = 1;
                    case 'Auto'
                        val = 4;
                    otherwise
                        error('Unknown Halogen Radio Button checked.');
                end
                app.serial_handler.setHalogen(val);
            catch e
                warning('Halogen exception: %s', getReport(e));
                waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
            end
        end
    end
    %public Methods
    methods (Access = public)

        %constructor
        function app= UIHalogenLamp(UI,parent, id)
            
            app.UI= UI;
            app.Container=uigridlayout(parent);
            app.Container.RowHeight = {150};
            app.Container.ColumnWidth = {'1x'};
            

            app.uibuttongroup3 = uibuttongroup(app.Container);
            app.uibuttongroup3.Title = 'Halogenlampe';
            app.uibuttongroup3.FontSize = 26;
            app.uibuttongroup3.Layout.Row = 1;
            app.uibuttongroup3.Layout.Column = 1;
            app.uibuttongroup3.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);

            % Create halo1
            app.halo1 = uiradiobutton(app.uibuttongroup3);
            app.halo1.Enable = 'off';
            app.halo1.Text = 'An';
            app.halo1.FontSize = 26;
            app.halo1.Position = [25 30 110 30];

            % Create halo0
            app.halo0 = uiradiobutton(app.uibuttongroup3);
            app.halo0.Enable = 'off';
            app.halo0.Text = 'Aus';
            app.halo0.FontSize = 26;
            app.halo0.Position = [25 70 110 30];
            app.halo0.Value = true;

            % Create haloA
            app.haloA = uiradiobutton(app.uibuttongroup3);
            app.haloA.Enable = 'off';
            app.haloA.Text = 'Auto';
            app.haloA.FontSize = 26;
            app.haloA.Position = [200 30 110 30];

      
             app.Container.Padding = [10 0 10 0];

        end  
    end
end
        