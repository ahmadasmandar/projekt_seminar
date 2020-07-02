classdef UIInfraRed < matlab.apps.AppBase

% the publich properties
    properties (Access = public)
    UI                              matlab.ui.Figure
    Container                       matlab.ui.container.GridLayout
    init_app
    end


% private properties
    properties (Access = public)
    % Titels   
    text5                           matlab.ui.control.Label

    %Axes
    camview_infrared                matlab.ui.control.UIAxes

    %Buttons
    live_infrared                   matlab.ui.control.Button
    stop_infrared                   matlab.ui.control.Button
    snapshot_infrared               matlab.ui.control.Button

    end

    %public Methods
    methods (Access = public)

        %constructor
        function app= UIInfraRed(UI, parent,id)
            
            app.UI= UI;
            app.Container=uigridlayout(parent);


            %app.Container.RowHeight = {30,30,30,30,'1x'};
            %app.Container.ColumnWidth = {'1x',130};
            
            %dynamic
            app.Container.RowHeight = {'0.15x','0.15x','0.15x','0.15x','1x'};
            app.Container.ColumnWidth = {'3x','1x'};
            
            infra_img= imread("infrared.jpg");
            

            % text5 of the element
            app.text5 = uilabel(app.Container);
            app.text5.Text = "Infrarot ";
            %app.text5.FontWeight = "bold";
            app.text5.FontSize = 26;
            app.text5.HorizontalAlignment = "center";
            % app.text5.VerticalAlignment = 'top';
            app.text5.Layout.Row = 1;
            app.text5.Layout.Column = 1;



            % axes on which plotting takes place
            app.camview_infrared = uiaxes(app.Container);
            app.camview_infrared.Layout.Row = [2, 5];
            app.camview_infrared.Layout.Column = 1;
            % set image to show on the Axes on startup
            imshow(infra_img,'Parent',app.camview_infrared);

            

            %%%%%%%%%%%%%%%%%%%%%%%% Buttons %%%%%%%%%%%%%%%%%%
             % button to live_infrared function
             app.live_infrared = uibutton(app.Container);
             app.live_infrared.Text = "Livebild";
             app.live_infrared.Enable='off';
             app.live_infrared.FontSize = 16;
             app.live_infrared.Layout.Row = 2;
             app.live_infrared.Layout.Column = 2;
             app.live_infrared.ButtonPushedFcn = createCallbackFcn(app, @live_infrared_Callback, true);
             
             
             
             % button to Stopp function
             app.stop_infrared = uibutton(app.Container);
             app.stop_infrared.Text = "Stopp";
             app.stop_infrared.Enable='off';
             app.stop_infrared.FontSize = 16;
             app.stop_infrared.Layout.Row = 3;
             app.stop_infrared.Layout.Column = 2;
             app.live_infrared.ButtonPushedFcn = createCallbackFcn(app, @snapshot_infrared_Callback, true);
             
             % button to Bilaufnahme function
             app.snapshot_infrared = uibutton(app.Container);
             app.snapshot_infrared.Text = "Einzelbild";
             app.snapshot_infrared.Enable='off'; 
             app.snapshot_infrared.FontSize = 16;
             app.snapshot_infrared.Layout.Row = 4;
             app.snapshot_infrared.Layout.Column = 2;
             app.live_infrared.ButtonPushedFcn = createCallbackFcn(app, @snapshot_infrared_Callback, true);

             
             
             app.Container.Padding = [10 10 10 10];


        end
        
    end

    methods(Access = public)
    % --- Executes on button press in live_infrared.
    function live_infrared_Callback(app, ~)

        enable_infrared(app.init_app, 'off');
    
        if ~app.init_app.infrared_obj.preview(@preview_infrared_adjust, app.camview_infrared, true)
            waitfor(msgbox('Livebild konnte nicht geladen werden.', 'Fehler', 'warn'));
        end
    
        enable_infrared(app.init_app, 'on');
    end

    % --- Executes on button press in snapshot_infrared.
    function snapshot_infrared_Callback(app, ~)

        enable_infrared(app, 'off');

    
        fprintf('Infrared start\n');
        if ~app.init_app.infrared_obj.snapshot(@infrared_adjust, app.camview_infrared)
            waitfor(msgbox('Einzelbild konnte nicht geladen werden.', 'Fehler', 'warn'));
        end
        app.camview_infrared = set_camview_default(app, app.camview_infrared);
        fprintf('Infrared end\n');
    
        enable_infrared(app, 'on');
    end

    % --- Executes on button press in stop_infrared.
    function stop_infrared_Callback(app, ~)


        enable_infrared(app.init_app, 'off');

        if ~app.init_app.infrared_obj.stoppreview()
            waitfor(msgbox('Livebild konnte gestoppt werden.', 'Fehler', 'warn'));
        end
    
        enable_infrared(app.init_app, 'on');
    end
    

    function camview = set_camview_default(app,camview)
        camview.XTick = [];
        camview.YTick = [];
        camview.CLim = [0, 255];
        camview.CLimMode = 'manual';
        camview.DataAspectRatio = [1, 1, 1];
    end


    %  ------ Receive the UIInitiaialize app from UIInitialize
    function receive_init_from_UIInitialize(app, app_obj)
        app.init_app=app_obj;
    end
    

    end

end
        