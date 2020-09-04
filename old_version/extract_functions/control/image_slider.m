% --- Executes on slider movement.
function image_slider_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to image_slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
        try
            val = round(hObject.Value);
            hObject.Value = val;
    
            if ~islogical(handles.laser_images)
                handles.img_count.String = sprintf('%d von %d', val, size(handles.laser_images, 4));
    
                colormap(handles.camview_laser, 'gray');
                image(handles.laser_images(:, :, 1, val), 'parent', handles.camview_laser);
                handles.camview_laser = set_camview_default(handles.camview_laser);
            end
        catch e
            warning('Laser silder exception: %s', getReport(e));
        end
    
        guidata(hObject, handles);
    end
    