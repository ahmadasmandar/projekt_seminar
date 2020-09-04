% --- Executes on button press in capture_calc.
function capture_calc_Callback(hObject, ~, handles)
    % hObject    handle to capture_calc (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_laser(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        if ~islogical(handles.laser_images)
            n = size(handles.laser_images, 4);
        else
            n = 0;
        end
    
        if n < 10
            if ~handles.demo
                waitfor(msgbox('Zu wenige Bilder für 3D-Bild Berechnung.', 'Fehler', 'warn'));
            end
    
            handles = enable_laser(handles, 'on');
            guidata(hObject, handles);
            return;
        end
    
        try
            Threshold = 100;             % Gray value threshold for backgound extraction
            % pre calibatrion data - use the program laserschnittverfahren3 to calibrate your system
            ps = 0.054381;              % Pixel relative size (mm/pixel)
            alpha = 13.844982;          % Triangulation angle in (Â°)
            LinCoef = 0;                % Linear coefficient 105
            AngCoef = 0;                % Angular coefficient
            data3d = get3D(handles.laser_images, Threshold, ps, alpha, LinCoef, AngCoef);
    
            handles.img_count.String = sprintf('Bilder: %d', n);
    
            colormap(handles.camview_laser, 'jet');
            mesh(data3d, 'parent', handles.camview_laser);
            handles.camview_laser.YTick = [];
            handles.camview_laser.XTick = [];
            handles.camview_laser.ZTick = [];
            min3d = min(min(data3d));
            handles.camview_laser.DataAspectRatio = [15, 4.5, 1.5];
            handles.camview_laser.CLim = [min3d, 0];
            handles.camview_laser.CLimMode = 'manual';
            rotate3d(handles.camview_laser, 'on');
            guidata(hObject, handles);
            drawnow();
        catch e
            warning('3D calc exception: %s', getReport(e));
            waitfor(msgbox('Interner Fehler während der 3D-Bild Berechnung.', 'Fehler', 'warn'));
        end
    
        handles = enable_laser(handles, 'on');
        guidata(hObject, handles);
    end