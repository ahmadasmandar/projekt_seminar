% --- Executes on button press in ledX.
function led_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to led0 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_serial(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        try
            switch(1)
                case handles.led0.Value
                    val = 0;
                case handles.led1.Value
                    val = 1;
                case handles.led2.Value
                    val = 2;
                case handles.led3.Value
                    val = 3;
                case handles.ledA.Value
                    val = 4;
                otherwise
                    error('Unknown LED Radio Button checked.');
            end
            handles.serial.setLed(val);
        catch e
            warning('LED exception: %s', getReport(e));
            waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
        end
    
        % Update handles structure
        handles = enable_serial(handles, 'on');
        guidata(hObject, handles);
    end
    