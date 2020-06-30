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
    
        % Update handles structure
        guidata(hObject, handles);
    end
    
    function [handle, images] = get_images(handle)
        stop(handle);
        count = handle.FramesAvailable;
    
        handle.FramesPerTrigger = count;
        images = getdata(handle);
    
        triggerconfig(handle, 'manual');
    
        src = getselectedsource(handle);
        src.TriggerMode = 'Off';
        handle.FramesPerTrigger = 1;
    end
    
    % --- Executes on button press in capture_stop.
    function capture_stop_Callback(hObject, ~, handles)
    % hObject    handle to capture_stop (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_laser(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        [success, images] = handles.laser.config(@get_images);
        if success && ~islogical(images)
            n = size(images, 4);
            handles.laser_images = images;
    
            colormap(handles.camview_laser, 'gray');
            handles.image_slider.Enable = 'on';
            handles.image_slider.Min = 1;
            handles.image_slider.Max = n;
            handles.image_slider.SliderStep = [1 / (n - 1), 1 / (n - 1)];
            for i = 1:n
                if handles.demo && mod(i, 5) ~= 0
                    continue;
                end
                capture_img = handles.laser_images(:, :, 1, i);
                image(capture_img, 'parent', handles.camview_laser);
                handles.camview_laser = set_camview_default(handles.camview_laser);
                handles.image_slider.Value = i;
                handles.img_count.String = sprintf('%d von %d', i, n);
                guidata(hObject, handles);
                drawnow();
                pause(0.001);
            end
    
            handles.cut_begin.Enable = 'on';
            handles.cut_end.Enable = 'on';
        else
            n = 0;
            handles.laser_images = false;
            handles.image_slider.Enable = 'off';
            handles.cut_begin.Enable = 'off';
            handles.cut_end.Enable = 'off';
        end
    
        handles.img_count.String = sprintf('Bilder: %d', n);
    
        handles = enable_laser(handles, 'on');
        guidata(hObject, handles);
    end