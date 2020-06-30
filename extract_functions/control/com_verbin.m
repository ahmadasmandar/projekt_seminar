function connect_serial_port_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to connect_serial_port (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles.connect_serial_port.Enable = 'off';
    
        % Update handles structure
        guidata(hObject, handles);
        % Store or retrieve UI data
        % Use this function only with GUIDE, or with apps created using the figure function.

        %Update figures and process callbacks
        drawnow();
    
        % Initialize serial port
        if is_serial_port(handles) == false
            try
                handles.serial = handles.param.serial_port({@serial_callback, hObject});
            catch e
                warning('Exception in camera_webcam(): %s', getReport(e));
            end
        end
    
        % connect
        success = false;
        try
            success = handles.serial.connect();
        catch e
            warning('Exception in serial.connect: %s', getReport(e));
        end
    
        if success == true
            handles = enable_serial(handles, 'on');
        else
            % warn that connecting failed
            waitfor(msgbox('Verbindung konnte nicht hergestellt werden.', 'Fehler', 'warn'));
            handles.connect_serial_port.Enable = 'on';
        end
    
        % Update handles structure
        guidata(hObject, handles);
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function serial_callback(app, type, parameter, hObject)
        % hObject   handle to figure
        % type      type of the message as string
        % parameter depends on the type
        %           if type is 'bat': train battery charging state
            handles = guidata(hObject);
        
            switch(type)
                case 'prelap1'
                    if app.demo
                        if is_laser(handles)
                            capture_start_Callback(app.capture_start, [], handles);
                            handles = guidata(hObject);
        
                            pause(12);
        
                            capture_stop_Callback(app.capture_stop, [], handles);
                            handles = guidata(hObject);
        
                            capture_calc_Callback(app.capture_calc, [], handles);
                            handles = guidata(hObject);
                        end
                    end
                case 'lap1'
                case 'prelap0'
                case 'lap0'
                    if app.demo
                        % Camera often crashes Matlab
                        if is_multispectral(handles) && app.haloA.Value ~= 1
                            snapshot_multispectral_Callback(app.snapshot_multispectral, [], handles);
                            handles = guidata(hObject);
                        end
        
                        if is_webcam(handles) && app.ledA.Value ~= 1
                            snapshot_webcam_Callback(app.snapshot_webcam, [], handles);
                            handles = guidata(hObject);
        
                            qr_button_Callback(app.qr_button, [], handles);
                            handles = guidata(hObject);
                        end
                    end
                case 'halo'
                    if app.demo
                        % Camera often crashes Matlab
                        if is_multispectral(handles)
                            pause(0.2);
                            snapshot_multispectral_Callback(app.snapshot_multispectral, [], handles);
                            handles = guidata(hObject);
                        end
                    end
                case 'led'
                    if app.demo
                        if is_webcam(handles)
                            snapshot_webcam_Callback(app.snapshot_webcam, [], handles);
                            handles = guidata(hObject);
        
                            qr_button_Callback(app.qr_button, [], handles);
                            handles = guidata(hObject);
                        end
                    end
                case 'bat'
                    app.battery_label.String = sprintf('Akku: %s', parameter);
                otherwise
                    error('Unknown SerialPort Callback "%s".', type);
            end
        
            % Update handles structure
            guidata(hObject, handles);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Button pushed function: snapshot_multispectral
    function snapshot_multispectral_Callback(app, event)
        % hObject    handle to snapshot_multispectral (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
            handles = enable_multispectral(handles, 'off');
            guidata(hObject, handles);
            drawnow();
        
            fprintf('Multispectral start\n');
            colormap(app.camview_multispectral, 'hot');
            if ~app.multispectral.snapshot(false, app.camview_multispectral)
                waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
            end
            fprintf('Multispectral end\n');
        
            handles = enable_multispectral(handles, 'on');
            guidata(hObject, handles);
    end

    % Button pushed function: snapshot_webcam
    function snapshot_webcam_Callback(app, event)
        % hObject    handle to snapshot_webcam (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
            handles = enable_webcam(handles, 'off');
            guidata(hObject, handles);
            drawnow();
        
            fprintf('Webcam start\n');
            if ~app.webcam.snapshot(false, app.camview_webcam)
                waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
            end
            fprintf('Webcam end\n');
        
            handles = enable_webcam(handles, 'on');
            guidata(hObject, handles);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function qr_button_Callback(app, event)
        % hObject    handle to qr_button (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
            handles = enable_webcam(handles, 'off');
            guidata(hObject, handles);
            drawnow();
        
            try
                img = getimage(app.camview_webcam);
        
                text = decode_qr(img);
                if isempty(text)
                    color = [1, 0, 0];
                    text = 'Nichts erkannt ...';
                else
                    color = [0, 1, 0];
                end
                app.qr_text.String = text;
                app.qr_text.ForegroundColor = color;
            catch e
                warning('QR-Code exception: %s', getReport(e));
                waitfor(msgbox('Interner Fehler während der QR-Code-Erkennung.', 'Fehler', 'warn'));
            end
        
            % Update handles structure
            handles = enable_webcam(handles, 'on');
            guidata(hObject, handles);
    end