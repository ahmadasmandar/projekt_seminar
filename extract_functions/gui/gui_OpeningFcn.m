% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to gui (see VARARGIN)
    
        % Choose default command line output for gui
        handles.output = hObject;
    
        % load java files for QR-Code decoding
        javaaddpath('core-1.7.jar')
        javaaddpath('javase-1.7.jar')
    
        % Load parameter functions
        handles.param = parameter();
    
        % Set axes palette
        colormap(handles.camview_infrared, 'jet');
    
        % load images to axes
        img = imread('QRCode.png');
        image(img, 'parent', handles.camview_webcam);
        handles.camview_webcam = set_camview_default(handles.camview_webcam);
        img = imread('laser.png');
        image(img, 'parent', handles.camview_laser);
        handles.camview_laser = set_camview_default(handles.camview_laser);
        img = imread('multispectral.jpg');
        image(img, 'parent', handles.camview_multispectral);
        handles.camview_multispectral = set_camview_default(handles.camview_multispectral);
        img = imread('infrared.jpg');
        image(img, 'parent', handles.camview_infrared);
        handles.camview_infrared = set_camview_default(handles.camview_infrared);
    
        % no laser images captured at start
        handles.laser_images = false;
    
        % disable demo mode at start
        handles.demo = false;
    
        % Update handles structure
        guidata(hObject, handles);
    
        % UIWAIT makes gui wait for user response (see UIRESUME)
        % uiwait(handles.LegoDemo);
    end