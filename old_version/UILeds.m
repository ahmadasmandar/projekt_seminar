classdef UILeds < matlab.apps.AppBase
% the publich properties
    properties (Access = public)
    UI                              matlab.ui.Figure
    Container                       matlab.ui.container.GridLayout
    end
% private properties
    properties (Access = public)
        uibuttongroup4          matlab.ui.container.ButtonGroup
        led0                    matlab.ui.control.RadioButton
        led1                    matlab.ui.control.RadioButton
        led2                    matlab.ui.control.RadioButton
        led3                    matlab.ui.control.RadioButton
        ledA                    matlab.ui.control.RadioButton
        serial_handler
    end

    methods (Access = private)

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            selectedButton = app.uibuttongroup4.SelectedObject;
            try
                switch(selectedButton.Text)
                    case 'Aus'
                        val = 0;
                    case 'Led 1'
                        val = 1;
                    case 'Led 2'
                        val = 2;
                    case 'Beide'
                        val = 3;
                    case 'Auto'
                        val = 4;
                    otherwise
                        error('Unknown LED Radio Button checked.');
                end
                disp(val)
                app.serial_handler.setLed(val);
                disp('serial data sent successfully')
            catch e
                warning('LED exception: %s', getReport(e));
                waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
            end
        end
    end

    methods (Access = public)

        % % Receive Serial Object from mainapp
        function receive_serial_handler(app,serial_handler_ext)
            app.serial_handler=serial_handler_ext;
            disp('serial object received successfully')
        end
    end

    %public Methods
    methods (Access = public)

        %constructor
        function app= UILeds(UI,parent, id)
            
            app.UI= UI;
            app.Container=uigridlayout(parent);
            app.Container.RowHeight = {200};
            app.Container.ColumnWidth = {'1x'};
            

            % Create uibuttongroup4
            app.uibuttongroup4 = uibuttongroup(app.Container);
            app.uibuttongroup4.Title = 'Led';
            app.uibuttongroup4.FontSize = 26;
            app.uibuttongroup4.Layout.Row = 1;
            app.uibuttongroup4.Layout.Column = 1;
            app.uibuttongroup4.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            
            % Create led0
            app.led0 = uiradiobutton(app.uibuttongroup4);
            app.led0.Enable = 'off';
            app.led0.Text = 'Aus';
            app.led0.FontSize = 26;
            app.led0.Position = [25 130 114 33];
            app.led0.Value = true;
            
            % Create led1
            app.led1 = uiradiobutton(app.uibuttongroup4);
            app.led1.Enable = 'off';
            app.led1.Text = 'Led 1';
            app.led1.FontSize = 26;
            app.led1.Position = [25 75 138 33];
            app.led1.Value = false;
            
            % Create led2
            app.led2 = uiradiobutton(app.uibuttongroup4);
            app.led2.Enable = 'off';
            app.led2.Text = 'Led 2';
            app.led2.FontSize = 26;
            app.led2.Position = [25 20 138 33];
            app.led2.Value = false;
            
            % Create led3
            app.led3 = uiradiobutton(app.uibuttongroup4);
            app.led3.Enable = 'off';
            app.led3.Text = 'Beide';
            app.led3.FontSize = 26;
            app.led3.Position = [200 75 138 33];
            app.led3.Value = false;
            
            % Create ledA
            app.ledA = uiradiobutton(app.uibuttongroup4);
            app.ledA.Enable = 'off';
            app.ledA.Text = 'Auto';
            app.ledA.FontSize = 26;
            app.ledA.Position = [200 20 138 33];
            app.ledA.Value = false;

      
             app.Container.Padding = [10 0 10 0];

        end  
    end
end
        