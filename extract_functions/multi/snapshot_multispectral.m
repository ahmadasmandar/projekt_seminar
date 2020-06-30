% --- Executes on button press in snapshot_multispectral.
function snapshot_multispectral_Callback(hObject, ~, handles)
    % hObject    handle to snapshot_multispectral (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_multispectral(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        fprintf('Multispectral start\n');
        colormap(handles.camview_multispectral, 'hot');
        if ~handles.multispectral.snapshot(false, handles.camview_multispectral)
            waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
        end
        fprintf('Multispectral end\n');
    
        handles = enable_multispectral(handles, 'on');
        guidata(hObject, handles);
    end