% --- Executes on button press in stop_webcam.
function stop_webcam_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to stop_webcam (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_webcam(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        if ~handles.webcam.stoppreview()
            waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
        end
    
        handles = enable_webcam(handles, 'on');
        guidata(hObject, handles);
    end