% --- Executes on button press in cut_begin.
function cut_begin_Callback(hObject, ~, handles) %#ok<DEFNU>
    % hObject    handle to cut_begin (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        n = size(handles.laser_images, 4);
        first = handles.image_slider.Value;
        handles.laser_images = handles.laser_images(:, :, 1, first:n);
        n = size(handles.laser_images, 4);
    
        handles.image_slider.Min = 1;
        handles.image_slider.Max = n;
        if n > 1
            step = 1 / (n - 1);
        else
            step = 1;
        end
        handles.image_slider.Value = 1;
        handles.image_slider.SliderStep = [step, step];
        handles.image_slider.Value = 1;
        handles.img_count.String = sprintf('%d von %d', handles.image_slider.Value, n);
    
        guidata(hObject, handles);
    end