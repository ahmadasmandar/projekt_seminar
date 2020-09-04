classdef class_serial_port < handle
    %CLASS_SERIAL_PORT Communication with hardware via serial port
    %
    properties (SetAccess = immutable)
        port            = '';
        baudrate        = '';
        terminator      = '';
        terminator_text = '';
        battery_log     = false;

        init_app_callback = false;
    end

    properties (Access = private)
        handle = false;
    end

    methods
        % constructor
        function app = class_serial_port(port, baudrate, terminator, init_app_callback)
            app.port = port;
            app.baudrate = baudrate;
            app.terminator = terminator;
            app.init_app_callback = init_app_callback;

            switch terminator
                case 'LF'
                    app.terminator_text = '\n';
                case 'CR'
                    app.terminator_text = '\r';
                case 'CR/LF'
                    app.terminator_text = '\r\n';
                case 'LF/CR'
                    app.terminator_text = '\n\r';
                otherwise
                    error('Unknown COM-PORT terminator string %s', terminator);
            end

            filename = datestr(now,'yymmdd_HHMMSS');
            app.battery_log = fopen(sprintf('battery_log_%s.log', filename),'w');
        end

        function success = connect(app)
            try
                % Find a serial port object.
                app.handle = instrfind('Type', 'serial', 'Port', app.port, 'Tag', '');

                % Create the serial port object if it does not exist
                % otherwise use the object that was found.
                if isempty(app.handle)
                    app.handle = serial(app.port);
                end

                % Configure instrument object, comport.
                set(app.handle, 'BaudRate', app.baudrate);
                set(app.handle, 'Terminator', {app.terminator, app.terminator});
                app.handle.BytesAvailableFcnMode = 'terminator';
                app.handle.BytesAvailableFcn = @app.loop;

                % Connect to instrument object, comport.
                fopen(app.handle);

                if app.isOpen
                    fprintf('Connected to COM-Port %s.\n', app.port);
                    success = true;
                else
                    warning('Connecting to COM-Port %s failed.', app.port);
                    success = false;
                end
            catch e
                warning('Connecting to COM-Port %s failed: %s', app.port, getReport(e));
                success = false;
            end
        end

        function close(app)
            if app.handle ~= false
                app.setDemoMode(0);
                app.setLed(0);
                app.setHalogen(0);
                app.setTrainSpeed(0);
                
                if app.battery_log ~= -1
                    fclose(app.battery_log);
                end

                fclose(app.handle);
                delete(app.handle);
                end

            clear app.handle;

            app.handle = false;

             fprintf('Closed connection to COM-Port %s.\n', app.port);
        end

        function open = isOpen(app)
            open = app.handle ~= false && isvalid(app.handle) && strcmp(get(app.handle, 'Status'), 'open');
        end

        function success = send(app, text)
            if app.isOpen
                fprintf(app.handle, sprintf('%s%s', text, app.terminator_text));
                fprintf('SerialPort write: "%s"\n', text);
                pause(0.05);
                success = true;
            else
                warning('COM-Port %s is not connected, can''t send data.', app.port);
                success = false;
            end
        end

        function success = setLed(app, state)
            if(state < 0 || state > 4)
                error('led state range is 0 - 4');
            end

            fprintf('Set LED state to %d.\n', state);

            success = app.send(sprintf('&L:%d;', state));
        end

        function success = setHalogen(app, state)
            if(state ~= 0 && state ~= 1 && state ~= 4)
                error('halogen states are 0, 1 and 4');
            end

            fprintf('Set Halogen state to %d.\n', state);

            success = app.send(sprintf('&H:%d;', state));
        end

        function success = setDemoMode(app, state)
            if(state ~= 0 && state ~= 1)
                error('demo mode states are 0 and 1');
            end

            fprintf('Set DemoMode state to %d.\n', state);

            success = app.send(sprintf('&d:%d;', state));
        end

        function success = setTrainSpeed(app, speed, left)
            if nargin < 3
                left = true;
            end

            if left == true
                left = 1;
            else
                left = 0;
            end

            if speed < 0 || speed > 10
                error('train speed range is 0 - 10');
            end

            fprintf('Set train speed to %d and direction to %d.\n', speed, left);

            success = app.send(sprintf('&D;%d;%d;', left, speed));
        end

        function loop(app, handle, ~, ~)
            try
                while (handle.BytesAvailable > 0)
                    line = fgetl(handle);
                    fprintf('SerialPort read: "%s"\n', line);

                    switch line
                        case 'PreLap Sensor 1'
                            % (trigger capture for triangulation)
                            app.call_callback('prelap1', false);
                        case 'Lap Sensor 1'
                            % end of round 1
                            app.call_callback('lap1', false);
                        case '...Slow'
                            % (trigger triangulation)
                            app.call_callback('prelap0', false);
                        case '...Stop'
                            % end of round 2
                            % (trigger QR-Code, infrared and multispectral)
                            app.call_callback('lap0', false);
                        case 'Set Halo 1'
                            % end of round 2
                            % (trigger QR-Code, infrared and multispectral)
                            app.call_callback('halo', false);
                        case 'Set LED LED1+2'
                            % end of round 2
                            % (trigger QR-Code, infrared and multispectral)
                            app.call_callback('led', false);
                    end

                    if strncmp(line, 'BAT:', 4)
                        % log battery state
                        if app.battery_log ~= -1
                            fprintf(app.battery_log, '%s %s\r\n', datestr(now,'yymmdd_HHMMSS'), line(5:end));
                        end

                        % show battery state
                       app.call_callback(line(5:end),'bat');
                    end
                end
            catch e
                warning('SerialPort read error: %s', getReport(e));
            end
        end

        function call_callback(app, parameter,type)
         
                serial_callback(app.init_app_callback, parameter,type);
        end

        function delete(app)
            app.close();
        end
    end

end
