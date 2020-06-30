% --- Executes on button press in live_webcam.
function live_webcam_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to live_webcam (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_webcam(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        if ~handles.webcam.preview(false, handles.camview_webcam)
            waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
        end
    
        handles = enable_webcam(handles, 'on');
        guidata(hObject, handles);
    end