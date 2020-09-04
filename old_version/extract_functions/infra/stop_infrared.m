% --- Executes on button press in stop_infrared.
function stop_infrared_Callback(hObject, ~, handles)
    % hObject    handle to stop_infrared (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_infrared(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        if ~handles.infrared.stoppreview()
            waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
        end
    
        handles = enable_infrared(handles, 'on');
        guidata(hObject, handles);
    end