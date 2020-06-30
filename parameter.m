function param = parameter
    param.serial_port = @serial_port;
    param.camera_webcam = @camera_webcam;
    param.camera_infrared = @camera_infrared;
    param.camera_laser = @camera_laser;
    param.camera_multispectral = @camera_multispectral;
end

function serial = serial_port(callback_receive)
%#SERIAL_PORT Initialize serial port
%#
%# SYNOPSIS serial_port
%# INPUT none
%# OUTPUT serial: The camera object
%#
    % set serial port identifiers
    port = 'COM12';
    baudrate = 115200;
    terminator = 'CR/LF';

    % initialize serial port
    serial = class_serial_port(port, baudrate, terminator, callback_receive);
end

function camera = camera_webcam
%#CAMERA_WEBCAM Initialize webcam for QR-Code analyse
%#
%# SYNOPSIS camera_webcam
%# INPUT none
%# OUTPUT camera: The camera object
%#        camera.inited: Implies whether the initialization has succeeded
%#        camera.handle: raw camera handle
%#
    % set camera identifiers
    name = 'QR-Code webcam';
    model = 'USB2.0 Camera';
    format = 'YUY2_640x480';

    % initialize camera
    camera = class_videoinput(name, 'winvideo', format, 'rgb', model);
end

function camera = camera_infrared()
%#CAMERA_INFRARED Initialize infrared camera
%#
%# SYNOPSIS camera_infrared
%# INPUT list: optional explicit gigecamlist()
%# OUTPUT camera: The camera object
%#
    % set camera identifiers
    name = 'infrared camera';
    % manufacturer = 'FLIR Systems AB';
    model = 'FLIR AX5';
    format = 'Mono16';

    % initialize camera
    camera = class_videoinput(name, 'gige', format, 'grayscale', model);
end

function camera = camera_laser()
%#CAMERA_LASER Initialize camera for laserline 3D analyse
%#
%# SYNOPSIS camera_laser
%# INPUT list: optional explicit gigecamlist()
%# OUTPUT camera: The camera object
%#
    % set camera identifiers
    name = 'laser camera';
    % manufacturer = 'TU Ilmenau QBV RF';
    model = 'CamSys-EV76C560-Laser';
    format = 'Mono8';

    % initialize camera
    camera = class_videoinput(name, 'gige', format, 'grayscale', model);

    function handle = set_ROI_pos(handle)
        handle.ROIPosition = [0, 0, 220, 450];
    end
    camera.config(@set_ROI_pos);
end

function camera = camera_multispectral(list)
%#CAMERA_MULTISPECTRAL Initialize multispectral camera
%#
%# SYNOPSIS camera_multispectral
%# INPUT list: optional explicit gigecamlist()
%# OUTPUT camera: The camera object
%#
    % set camera identifiers
    name = 'multispectral camera';
    manufacturer = 'TU Ilmenau QBV';
    model = 'CamSys-EV76C560';
    format = 'Mono8';

    % initialize camera
    camera = class_gigecam(name, format, model, manufacturer, list);
    function handle = set_ExposureTime(handle)
        handle.ExposureTime = 35000;
    end
    camera.config(@set_ExposureTime);
end
