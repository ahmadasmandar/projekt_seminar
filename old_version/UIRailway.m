classdef UIRailway < matlab.apps.AppBase
    % public properties
    properties (Access = public)
        UI         matlab.ui.Figure
        Container  matlab.ui.container.GridLayout
        train_dir_left          matlab.ui.control.RadioButton
        train_dir_right         matlab.ui.control.RadioButton
        train_speed             matlab.ui.control.Slider
        text12                  matlab.ui.control.Label
        train_speed_label       matlab.ui.control.Label
        serial_handler
    end

    methods (Access = public)

        % % Receive Serial Object from mainapp
        function receive_serial_handler(app,serial_handler_ext)
            app.serial_handler=serial_handler_ext;
            disp('train_serial object received successfully')
        end
    end
    % private properties
    properties (Access = private)
        
        uibuttongroup2          matlab.ui.container.ButtonGroup
    end

    % public methods
    methods (Access = public)
        % the class contructor has the same name as the class
        function obj = UIRailway(UI, parent, id, WindowWidth)
            % set the superior window (uifigure)
            obj.UI = UI;

            % create the main layout with the given element as parent
            obj.Container = uigridlayout(parent);
            
            % make a grid layour with 7 rows and 4 columns
            obj.Container.RowHeight = {200};
            obj.Container.ColumnWidth = {'1x'};
            
        


            % Create uibuttongroup2
            obj.uibuttongroup2 = uibuttongroup(obj.Container);
            obj.uibuttongroup2.Title = 'Eisenbahn';
            obj.uibuttongroup2.FontSize = 26;
            obj.uibuttongroup2.Layout.Row = 1;
            obj.uibuttongroup2.Layout.Column = 1;

            % Create train_dir_left
            obj.train_dir_left = uiradiobutton(obj.uibuttongroup2);
            obj.train_dir_left.Enable = 'off';
            obj.train_dir_left.Text = 'Links';
            obj.train_dir_left.FontSize = 26;
            obj.train_dir_left.Position = [23 120 118 33];

            % Create train_dir_right
            obj.train_dir_right = uiradiobutton(obj.uibuttongroup2);
            obj.train_dir_right.Text = 'Rechts';
            obj.train_dir_right.Enable = 'off';
            obj.train_dir_right.FontSize = 26;
            x = get(obj.UI , 'position');
            obj.train_dir_right.Position = [0.1*x(3) 120 140 33];

            % Create train_speed
            obj.train_speed = uislider(obj.uibuttongroup2);
            obj.train_speed.Enable = 'off';
            obj.train_speed.Limits = [0 10];
            obj.train_speed.MajorTicks = [0 1 2 3 4 5 6 7 8 9 10];
            obj.train_speed.MinorTicks = [0 1 2 3 4 5 6 7 8 9 10];
            obj.train_speed.ValueChangedFcn = createCallbackFcn(obj, @train_speed_Callback, true);
            obj.train_speed.FontSize = 11;
            obj.train_speed.Position = [23 50 304 3];

            % Create train_speed_label
            obj.train_speed_label = uilabel(obj.uibuttongroup2);
            obj.train_speed_label.Enable = 'off';
            obj.train_speed_label.HorizontalAlignment = 'center';
            obj.train_speed_label.VerticalAlignment = 'top';
            obj.train_speed_label.FontSize = 26;
            obj.train_speed_label.Position = [232 70 52 34];
            obj.train_speed_label.Text = '0';
            
            % Create text12
            obj.text12 = uilabel(obj.uibuttongroup2);
            obj.text12.Enable = 'off';
            obj.text12.FontSize = 26;
            obj.text12.Position = [23 70 210 33];
            obj.text12.Text = 'Geschwindigkeit:';



            
            obj.Container.Padding = [10 10 10 10];

        end

        function train_speed_Callback(app, ~)
            % hObject    handle to train_speed (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'Value') returns position of slider
            %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
                % enable_serial(app, 'off');

                % disp(event)
                % val = round(app.train_speed.Value);
                % disp(val)

                try
                    val = round(app.train_speed.Value);
                    app.train_speed.Value = val;
            
                    app.train_speed_label.Text = sprintf('%d', val);
                    app.serial_handler.setTrainSpeed(val, app.train_dir_left.Value == 0);
                catch e
                    warning('Train exception: %s', getReport(e));
                    waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
                end
            
                % Update handles structure
                % enable_serial(app, 'on');
        end

    end
end
