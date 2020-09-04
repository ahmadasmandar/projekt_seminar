% --- Executes on button press in snapshot_webcam.
function snapshot_webcam_Callback(hObject, ~, handles)
    % hObject    handle to snapshot_webcam (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_webcam(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        fprintf('Webcam start\n');
        if ~handles.webcam.snapshot(false, handles.camview_webcam)
            waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
        end
        fprintf('Webcam end\n');
    
        handles = enable_webcam(handles, 'on');
        guidata(hObject, handles);
    end