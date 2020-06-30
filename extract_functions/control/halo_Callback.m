% --- Executes on button press in haloX.
function halo_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to halo1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_serial(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        try
            switch(1)
                case handles.halo0.Value
                    val = 0;
                case handles.halo1.Value
                    val = 1;
                case handles.haloA.Value
                    val = 4;
                otherwise
                    error('Unknown Halogen Radio Button checked.');
            end
            handles.serial.setHalogen(val);
        catch e
            warning('Halogen exception: %s', getReport(e));
            waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
        end
    
        % Update handles structure
        handles = enable_serial(handles, 'on');
        guidata(hObject, handles);
    end
    