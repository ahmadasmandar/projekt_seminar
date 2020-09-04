function camera_init_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to camera_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.camera_init.Enable = 'off';

    % Update handles structure
    guidata(hObject, handles);
    drawnow();

    all_success = true;

    if isfield(handles, 'gigelist') == false || istable(handles.gigelist) == false
        try
            handles.gigelist = gigecamlist(); % speed up gigecam initialization
        catch e
            all_success = false;
            warning('Exception in gigecamlist(): %s', getReport(e));
        end
    end

    if ~is_webcam(handles)
        try
            handles.webcam = handles.param.camera_webcam();
            handles = enable_webcam(handles, 'on');
        catch e
            all_success = false;
            warning('Exception in camera_webcam(): %s', getReport(e));
        end
    end

    if ~is_laser(handles)
        try
            handles.laser = handles.param.camera_laser();
            handles = enable_laser(handles, 'on');
        catch e
            all_success = false;
            warning('Exception in camera_laser(): %s', getReport(e));
        end
    end

    if ~is_infrared(handles)
        try
            handles.infrared = handles.param.camera_infrared();
            handles = enable_infrared(handles, 'on');
        catch e
            all_success = false;
            warning('Exception in camera_infrared(): %s', getReport(e));
        end
    end

    if ~is_multispectral(handles)
        try
            handles.multispectral = handles.param.camera_multispectral(handles.gigelist);
            handles = enable_multispectral(handles, 'on');
        catch e
            all_success = false;
            warning('Exception in camera_multispectral(): %s', getReport(e));
        end
    end

    % Set preview data to native camera bit depth (default is 8 bit)
    imaqmex('feature', '-previewFullBitDepth', true);

    if all_success == false
        handles.camera_init.Enable = 'on';
    end

    % Update handles structure
    guidata(hObject, handles);
end