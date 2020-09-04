% --- Executes on button press in capture_start.
function capture_start_Callback(hObject, ~, handles)
    % hObject    handle to capture_start (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_laser(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        if handles.laser.stoppreview() == false || handles.laser.config({@config_laser_start, handles.demo}) == false
            waitfor(msgbox('Interner Fehler während der Laserlinienbild-Aufnahmekonfiguration.', 'Fehler', 'warn'));
    
            handles = enable_laser(handles, 'on');
            guidata(hObject, handles);
            return;
        end
    
        if ~handles.demo
            handles.capture_stop.Enable = 'on';
end