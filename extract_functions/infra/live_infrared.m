% --- Executes on button press in live_infrared.
function live_infrared_Callback(hObject, ~, handles)
    % hObject    handle to live_infrared (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_infrared(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        if ~handles.infrared.preview(@preview_infrared_adjust, handles.camview_infrared, true)
            waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
        end
    
        handles = enable_infrared(handles, 'on');
        guidata(hObject, handles);
    end