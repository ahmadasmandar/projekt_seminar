classdef class_serial_port < handle
    %CLASS_SERIAL_PORT Communication with hardware via serial port
    %
    properties (SetAccess = immutable)
        port            = '';
        baudrate        = '';
        terminator      = '';
        terminator_text = '';
        battery_log     = false;

        callback_receive = false;
    end

    properties (Access = private)
        handle = false;
    end

    methods
        % constructor
        function obj = class_serial_port(port, baudrate, terminator, callback_receive)
            obj.port = port;
            obj.baudrate = baudrate;
            obj.terminator = terminator;
            obj.callback_receive = callback_receive;

            switch terminator
                case 'LF'
                    obj.terminator_text = '\n';
                case 'CR'
                    obj.terminator_text = '\r';
                case 'CR/LF'
                    obj.terminator_text = '\r\n';
                case 'LF/CR'
                    obj.terminator_text = '\n\r';
                otherwise
                    error('Unknown COM-PORT terminator string %s', terminator);
            end

            filename = datestr(now,'yymmdd_HHMMSS');
            obj.battery_log = fopen(sprintf('battery_log_%s.log', filename),'w');
        end

        function success = connect(obj)
            try
                % Find a serial port object.
                obj.handle = instrfind('Type', 'serial', 'Port', obj.port, 'Tag', '');

                % Create the serial port object if it does not exist
                % otherwise use the object that was found.
                if isempty(obj.handle)
                    obj.handle = serial(obj.port);
                end

                % Configure instrument object, comport.
                set(obj.handle, 'BaudRate', obj.baudrate);
                set(obj.handle, 'Terminator', {obj.terminator, obj.terminator});
                obj.handle.BytesAvailableFcnMode = 'terminator';
                obj.handle.BytesAvailableFcn = @obj.loop;

                % Connect to instrument object, comport.
                fopen(obj.handle);

                if obj.isOpen
                    fprintf('Connected to COM-Port %s.\n', obj.port);
                    success = true;
                else
                    warning('Connecting to COM-Port %s failed.', obj.port);
                    success = false;
                end
            catch e
                warning('Connecting to COM-Port %s failed: %s', obj.port, getReport(e));
                success = false;
            end
        end

        function close(obj)
            if obj.handle ~= false
                obj.setDemoMode(0);
                obj.setLed(0);
                obj.setHalogen(0);
                obj.setTrainSpeed(0);
                
                if obj.battery_log ~= -1
                    fclose(obj.battery_log);
                end

                fclose(obj.handle);
                delete(obj.handle);
            end

            clear obj.handle;

            obj.handle = false;

            fprintf('Closed connection to COM-Port %s.\n', obj.port);
        end

        function open = isOpen(obj)
            open = obj.handle ~= false && isvalid(obj.handle) && strcmp(get(obj.handle, 'Status'), 'open');
        end

        function success = send(obj, text)
            if obj.isOpen
                fprintf(obj.handle, sprintf('%s%s', text, obj.terminator_text));
                fprintf('SerialPort write: "%s"\n', text);
                pause(0.05);
                success = true;
            else
                warning('COM-Port %s is not connected, can''t send data.', obj.port);
                success = false;
            end
        end

        function success = setLed(obj, state)
            if(state < 0 || state > 4)
                error('led state range is 0 - 4');
            end

            fprintf('Set LED state to %d.\n', state);

            success = obj.send(sprintf('&L:%d;', state));
        end

        function success = setHalogen(obj, state)
            if(state ~= 0 && state ~= 1 && state ~= 4)
                error('halogen states are 0, 1 and 4');
            end

            fprintf('Set Halogen state to %d.\n', state);

            success = obj.send(sprintf('&H:%d;', state));
        end

        function success = setDemoMode(obj, state)
            if(state ~= 0 && state ~= 1)
                error('demo mode states are 0 and 1');
            end

            fprintf('Set DemoMode state to %d.\n', state);

            success = obj.send(sprintf('&d:%d;', state));
        end

        function success = setTrainSpeed(obj, speed, left)
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

            success = obj.send(sprintf('&D;%d;%d;', left, speed));
        end

        function loop(obj, handle, ~, ~)
            try
                while (handle.BytesAvailable > 0)
                    line = fgetl(handle);
                    fprintf('SerialPort read: "%s"\n', line);

                    switch line
                        case 'PreLap Sensor 1'
                            % (trigger capture for triangulation)
                            obj.call_callback('prelap1', false);
                        case 'Lap Sensor 1'
                            % end of round 1
                            obj.call_callback('lap1', false);
                        case '...Slow'
                            % (trigger triangulation)
                            obj.call_callback('prelap0', false);
                        case '...Stop'
                            % end of round 2
                            % (trigger QR-Code, infrared and multispectral)
                            obj.call_callback('lap0', false);
                        case 'Set Halo 1'
                            % end of round 2
                            % (trigger QR-Code, infrared and multispectral)
                            obj.call_callback('halo', false);
                        case 'Set LED LED1+2'
                            % end of round 2
                            % (trigger QR-Code, infrared and multispectral)
                            obj.call_callback('led', false);
                    end

                    if strncmp(line, 'BAT:', 4)
                        % log battery state
                        if obj.battery_log ~= -1
                            fprintf(obj.battery_log, '%s %s\r\n', datestr(now,'yymmdd_HHMMSS'), line(5:end));
                        end

                        % show battery state
                        obj.call_callback('bat', line(5:end));
                    end
                end
            catch e
                warning('SerialPort read error: %s', getReport(e));
            end
        end

        function call_callback(obj, type, parameter)
            if isa(obj.callback_receive, 'function_handle')
                obj.callback_receive(type, parameter);
            elseif iscell(obj.callback_receive) && isa(obj.callback_receive{1}, 'function_handle')
                obj.callback_receive{1}(type, parameter, obj.callback_receive{2:end});
            else
                error('SerialPort callback is not callable');
            end
        end

        function delete(obj)
            obj.close();
        end
    end

end
