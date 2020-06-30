% --- Executes on button press in snapshot_infrared.
function snapshot_infrared_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to snapshot_infrared (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_infrared(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        fprintf('Infrared start\n');
        if ~handles.infrared.snapshot(@infrared_adjust, handles.camview_infrared)
            waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
        end
        handles.camview_infrared = set_camview_default(handles.camview_infrared);
        fprintf('Infrared end\n');
    
        handles = enable_infrared(handles, 'on');
        guidata(hObject, handles);
    end