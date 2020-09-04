% --- Executes on button press in demomode.
function demomode_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to demomode (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        % Set train speed
        if handles.demomode.Value == 0
            handles.train_speed.Value = 0;
        else
            handles.train_speed.Value = 9;
            handles.train_dir_left.Value = 1;
        end
        train_speed_Callback(handles.train_speed, [], handles);
        handles = guidata(hObject);
    
        handles = enable_serial(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        try
            if handles.demomode.Value == 0
                handles.serial.setDemoMode(0);
    
                stop_infrared_Callback(handles.snapshot_infrared, [], handles);
                handles = guidata(hObject);
    
                handles.demo = false;
    
                handles = enable_webcam(handles, 'on');
                handles = enable_laser(handles, 'on');
                handles = enable_infrared(handles, 'on');
                handles = enable_multispectral(handles, 'on');
            else
                handles.serial.setDemoMode(1);
    
                live_infrared_Callback(handles.snapshot_infrared, [], handles);
                handles = guidata(hObject);
    
                handles = enable_webcam(handles, 'off');
                handles = enable_laser(handles, 'off');
                handles = enable_infrared(handles, 'off');
                handles = enable_multispectral(handles, 'off');
    
                handles.demo = true;
            end
        catch e
            warning('DemoMode exception: %s', getReport(e));
            waitfor(msgbox('Interner Fehler während der SerialPort Kommunikation.', 'Fehler', 'warn'));
        end
    
        % Update handles structure
        handles = enable_serial(handles, 'on');
        guidata(hObject, handles);
    end