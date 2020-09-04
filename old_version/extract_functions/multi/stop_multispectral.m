% --- Executes on button press in stop_multispectral.
function stop_multispectral_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to stop_multispectral (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_multispectral(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        if ~handles.multispectral.stoppreview()
            waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
        end
    
        handles = enable_multispectral(handles, 'on');
        guidata(hObject, handles);
    end