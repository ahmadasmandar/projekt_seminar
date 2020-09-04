% --- Executes on button press in stop_laser.
function stop_laser_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to stop_laser (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_laser(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        if ~handles.laser.stoppreview()
            waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
        end
    
        handles = enable_laser(handles, 'on');
        guidata(hObject, handles);
    end