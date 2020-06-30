% --- Executes on button press in live_laser.
function live_laser_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to live_laser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = enable_laser(handles, 'off');
    guidata(hObject, handles);
    drawnow();

    colormap(handles.camview_laser, 'gray');
    if ~handles.laser.preview(@preview_normalize_adjust_255, handles.camview_laser)
        waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
    end

    handles = enable_laser(handles, 'on');
    guidata(hObject, handles);
end
