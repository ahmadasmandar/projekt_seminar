function train_speed_Callback(hObject, ~, handles)
    % hObject    handle to train_speed (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
        handles = enable_serial(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        try
            val = round(hObject.Value);
            hObject.Value = val;
    
            handles.train_speed_label.String = sprintf('%d', val);
            handles.serial.setTrainSpeed(val, handles.train_dir_left.Value == 0);
        catch e
            warning('Train exception: %s', getReport(e));
            waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
        end
    
        % Update handles structure
        handles = enable_serial(handles, 'on');
        guidata(hObject, handles);
    end