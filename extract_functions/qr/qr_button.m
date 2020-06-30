function qr_button_Callback(hObject, ~, handles)
    % hObject    handle to qr_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        handles = enable_webcam(handles, 'off');
        guidata(hObject, handles);
        drawnow();
    
        try
            img = getimage(handles.camview_webcam);
    
            text = decode_qr(img);
            if isempty(text)
                color = [1, 0, 0];
                text = 'Nichts erkannt ...';
            else
                color = [0, 1, 0];
            end
            handles.qr_text.String = text;
            handles.qr_text.ForegroundColor = color;
        catch e
            warning('QR-Code exception: %s', getReport(e));
            waitfor(msgbox('Interner Fehler während der QR-Code-Erkennung.', 'Fehler', 'warn'));
        end
    
        % Update handles structure
        handles = enable_webcam(handles, 'on');
        guidata(hObject, handles);
    end