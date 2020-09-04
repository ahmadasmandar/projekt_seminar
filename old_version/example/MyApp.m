classdef MyApp < matlab.apps.AppBase
        
    properties(Access =public)
        UIFiguare           matlab.ui.Figure
        UIAxes              matlab.ui.control.UIAxes
        OptionsButton       matlab.ui.control.Button
    end

    properties (Access = public)
        Dialogapp
        CurrentSize=35;
        Currentcolormap ='Parula';
    end

    methods (Access =public)
        function updateplot(app, sz, c)
            % Store inputs as properties
            app.CurrentSize = sz;
            app.Currentcolormap = c;
            
            % Update plot 
            Z = peaks(sz);
            surf(app.UIAxes,Z);
            colormap(app.UIAxes,c);
            
            % Re-enable the Plot Options button
            app.OptionsButton.Enable = 'on';
        end
       
    end
    methods(Access= public)
        function app = MyApp
            % Create Components 
            app.UIFiguare =uifigure('Visible','off');
            app.UIFiguare.Position=[100 100 500 400];
            app.UIFiguare.Name='Display Plot';
            app.UIFiguare.CloseRequestFcn = createCallbackFcn(app,@MainAppCloseRequest,true);
            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFiguare);
            app.UIAxes.Position = [68 68 341 267];
            

            % Create OptionsButton
            app.OptionsButton=uibutton(app.UIFiguare,'push');
            app.OptionsButton.ButtonPushedFcn= createCallbackFcn(app,@OptionsButtonPushed, true);
            app.OptionsButton.Position= [200 30 100 25];
            app.OptionsButton.Text= 'Options';

            app.UIFiguare.Visible='on';
            startupFcn(app);
        end

        function delete(app)
            delete(app.UIFiguare);
        end
    end

    methods (Access = private)
        function startupFcn(app)
            updateplot(app, app.CurrentSize, app.Currentcolormap);
        end

        function OptionsButtonPushed(app, event)
            app.OptionsButton.Enable='off';
            app.Dialogapp=MyDialogApp(app, app.CurrentSize, app.Currentcolormap);
        end
        
        function MainAppCloseRequest(app, event)
            delete(app.Dialogapp);
            delete(app);
        end
    end

end