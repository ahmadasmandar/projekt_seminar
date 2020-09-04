% --- Executes on button press in train_dir_XXX.
function train_dir_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to train_dir_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = enable_serial(handles, 'off');
    guidata(hObject, handles);
    drawnow();

    try
        speed = str2double(handles.train_speed_label.String);
        handles.serial.setTrainSpeed(speed, handles.train_dir_left.Value == 0);
    catch e
        warning('Train exception: %s', getReport(e));
        waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
    end

    % Update handles structure
    handles = enable_serial(handles, 'on');
    guidata(hObject, handles);
end