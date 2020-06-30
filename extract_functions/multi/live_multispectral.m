% --- Executes on button press in live_multispectral.
function live_multispectral_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to live_multispectral (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_multispectral(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        colormap(handles.camview_multispectral, 'hot');
        if ~handles.multispectral.preview(@preview_gray, handles.camview_multispectral)
            waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
        end
    
        handles = enable_multispectral(handles, 'on');
        guidata(hObject, handles);
    end