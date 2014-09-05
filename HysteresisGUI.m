function varargout = HysteresisGUI(varargin)
% HYSTERESISGUI MATLAB code for HysteresisGUI.fig
%      HYSTERESISGUI, by itself, creates a new HYSTERESISGUI or raises the existing
%      singleton*.
%
%      H = HYSTERESISGUI returns the handle to a new HYSTERESISGUI or the handle to
%      the existing singleton*.
%
%      HYSTERESISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HYSTERESISGUI.M with the given input arguments.
%
%      HYSTERESISGUI('Property','Value',...) creates a new HYSTERESISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HysteresisGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HysteresisGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HysteresisGUI

% Last Modified by GUIDE v2.5 03-Sep-2014 15:24:50

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @HysteresisGUI_OpeningFcn, ...
                       'gui_OutputFcn',  @HysteresisGUI_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
% End initialization code - DO NOT EDIT


% --- Executes just before HysteresisGUI is made visible.
function HysteresisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HysteresisGUI (see VARARGIN)

% Choose default command line output for HysteresisGUI
    handles.output = hObject;

    global PreisachMatrixNxN;
    global Xfactor; 
    global Xoffset; 
    global Yfactor; 
    global Yoffset;
    global N;
    global PlotX; 
    global PlotY;
    global workingMode;
    global Min;
    global Max;

    N = 1000;
    Min = N/2;
    Max = N/2;
    
    hSplash = splash('SplashScrn','png');
    
    ResetMatrix();


    [UpperpartOfLoopX, UpperpartOfLoopY, LowerpartOfLoopX, LowerpartOfLoopY, PlotX, PlotY] = fp ('XvaluesMAX.tsv', 'YvaluesMAX.tsv', 150);

    scatter(PlotX, PlotY, 2);
    set(gca, 'FontSize', 10);

    [PreisachMatrixNxN, Xfactor, Xoffset, Yfactor, Yoffset] = PreisachModelMatrixGeneration(LowerpartOfLoopX, LowerpartOfLoopY, UpperpartOfLoopX, UpperpartOfLoopY, N);
    
    Demagnetize();
    
    
    
    
    set(handles.oneloop,'value',1);
    workingMode = 2;  
    SetVisibility(handles, workingMode);
    set(handles.min,'String',sprintf('%0.3f',(((Min/N)*Xfactor)+ Xoffset)));
    set(handles.max,'String',sprintf('%0.3f',(((Max/N)*Xfactor)+ Xoffset)));

    hold on
    
    splash(hSplash,'off')

    % Update handles structure
    guidata(hObject, handles);


    % UIWAIT makes HysteresisGUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = HysteresisGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;
   
    
function SetVisibility(handles, workingMode)

    if (workingMode == 1)
        set(handles.DemagnetizeBtn,'Enable','on');
        
        set(handles.text4,'Visible','Off');
        set(handles.text5,'Visible','Off');
        set(handles.min,'Visible','Off');
        set(handles.max,'Visible','Off');
        
        set(handles.text1,'Visible','On');
        set(handles.text2,'Visible','On');
        set(handles.edit1,'Visible','On');
    elseif (workingMode == 2)
        set(handles.DemagnetizeBtn,'Enable','off');
        
        set(handles.text1,'Visible','Off');
        set(handles.text2,'Visible','Off');
        set(handles.edit1,'Visible','Off');
        
        set(handles.text4,'Visible','On');
        set(handles.text5,'Visible','On');
        set(handles.min,'Visible','On');
        set(handles.max,'Visible','On');
    end

    
function GenerateInput(value)

    global input; 
    
    if (input(end) < value)
        input = [input, [input(end)+1:1:value]];
    elseif (input(end) > value)
        input = [input, [input(end)-1:-1:value]];
    end
    
    
    

function ResetPlot()

    global PlotX; 
    global PlotY;
    cla reset
    scatter(PlotX, PlotY, 2);
    hold on;
    
function ResetMatrix()

    global input;
    global matrix;
    global N;
    
    input = 1;
    matrix = zeros(N,N);
    matrix(1,1) = 1;
    
function ResetPrevValArray(handles)

    set(handles.text2,'String','');
    
    
function Demagnetize()

    global PreisachMatrixNxN;
    global input;
    global matrix;
    global N;
    
    input = DepolarizingMatrixInput( N );
    [~, matrix] = HysteresisNxN_GUI(input, PreisachMatrixNxN, matrix, 'depolarizing');
    
%     aaa = tril(ones(N,N));
%     bbb = fliplr(tril(ones(N,N),-1));
%     ccc = aaa - bbb;
%     matrix = ccc .* aaa;
    
    
    input = input(end);



function AppendStringValue(handles, StringToAppend)

    CurrentString = get(handles.text2,'String');
    if isempty(CurrentString)
        CurrentString = [StringToAppend];
    else
        CurrentString = [StringToAppend '; ' CurrentString];
    end
    set(handles.text2,'String',CurrentString);




% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)

    selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                         ['Close ' get(handles.figure1,'Name') '...'],...
                         'Yes','No','Yes');
    if strcmp(selection,'No')
        return;
    end

    delete(handles.figure1)




function edit1_Callback(hObject, eventdata, handles)

    global PreisachMatrixNxN;
    global Xfactor; 
    global Xoffset; 
    global Yfactor; 
    global Yoffset;
    global input;
    global matrix;
    global N;

    x = get(handles.edit1,'String');

    if isempty(x)
        errordlg('Error: Enter value first','Input Error');
    else

       value = str2double(x);

       if isnan(value)
           errordlg('Error: Input must be a number','Input Error');
       elseif (value <  Xoffset) || (value >  -Xoffset)
           errordlg('Error: Input must be in the range [Xmin:Xmax]','Input Error');
       else
           h = waitbar(0,'Please wait. Calculating ...', 'WindowStyle', 'modal');
           
           AppendStringValue(handles, x)

           value = round(((value- Xoffset) / Xfactor )*N);

           if (input(end) < value)
                input = [input(end):1:value];
           else
                input = [input(end):-1:value];
           end

           [Output, matrix] = HysteresisNxN_GUI(input, PreisachMatrixNxN, matrix, 'normal');

           [Xoutput2, Youtput2] = Denormalize( input, Output, Xfactor, Xoffset, Yfactor, Yoffset, N);
           
           close(h)
           plot(Xoutput2, Youtput2, '-r');
       end


    end



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    


function DemagnetizeBtn_Callback(hObject, eventdata, handles)
  
    global workingMode;
    
    h = waitbar(0,'Please wait. Calculating ...', 'WindowStyle', 'modal');
    
    ResetMatrix();
    if (workingMode == 1)
        ResetPrevValArray(handles);
    end
    
    Demagnetize();
    
    close(h);
    
    ResetPlot();


% --- Executes on button press in freemode.
function freemode_Callback(hObject, eventdata, handles)

    global workingMode;
    
    set(handles.freemode,'value',1)
    set(handles.oneloop,'value',0)
    
    h = waitbar(0,'Please wait. Calculating...', 'WindowStyle', 'modal');  
    

    workingMode = 1;
    
    SetVisibility(handles, workingMode);
    
    ResetMatrix();
    ResetPrevValArray(handles);
    
    Demagnetize();
    
    close(h) 
    
    ResetPlot();


% --- Executes on button press in oneloop.
function oneloop_Callback(hObject, eventdata, handles)

    global workingMode;
    global Xfactor; 
    global Xoffset;
    global N;
    global Min;
    global Max;
    
    set(handles.freemode,'value',0)
    set(handles.oneloop,'value',1)
    
    h = waitbar(0,'Please wait. Calculating ...', 'WindowStyle', 'modal');    
    
    workingMode = 2;
    
    SetVisibility(handles, workingMode);
    
    ResetMatrix();
    
    
    set(handles.min,'String',sprintf('%0.3f',(((Min/N)*Xfactor)+ Xoffset)));
    set(handles.max,'String',sprintf('%0.3f',(((Max/N)*Xfactor)+ Xoffset)));
    
    Demagnetize();
    
    close(h) 
    
    ResetPlot();


function min_Callback(hObject, eventdata, handles)

    global PreisachMatrixNxN;
    global Xfactor; 
    global Xoffset; 
    global Yfactor; 
    global Yoffset;
    global input;
    global matrix;
    global N;
    global Min;
    global Max;

    
    
    x = get(handles.min,'String');

    if isempty(x)
        errordlg('Error: Enter value first','Input Error');
    else

       value = str2double(x);

       if isnan(value)
           errordlg('Error: Input must be a number','Input Error');
       elseif (value <  Xoffset) || (value >  -Xoffset)
           errordlg('Error: Input must be in the range [Xmin:Xmax]','Input Error');
       else    

           value = round(((value- Xoffset) / Xfactor )*N);

           if (Max < value)
               errordlg('Error: Min larger than Max','Input Error');
           else
               h = waitbar(0,'Please wait. Calculating ...', 'WindowStyle', 'modal');
               
               Min = value;
               
               ResetMatrix();
               Demagnetize();
               
               
               
               GenerateInput(Max);
               GenerateInput(Min);
               GenerateInput(Max);
               GenerateInput(Min);
               
               
               
               [Output, matrix] = HysteresisNxN_GUI(input, PreisachMatrixNxN, matrix, 'normal');

               [Xoutput2, Youtput2] = Denormalize( input, Output, Xfactor, Xoffset, Yfactor, Yoffset, N);
               
               close(h) 
               
               ResetPlot();
               plot(Xoutput2, Youtput2, '-r');
           end
       end


    end
    
    



% --- Executes during object creation, after setting all properties.
function min_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function max_Callback(hObject, eventdata, handles)

    global PreisachMatrixNxN;
    global Xfactor; 
    global Xoffset; 
    global Yfactor; 
    global Yoffset;
    global input;
    global matrix;
    global N;
    global Min;
    global Max;
    
    x = get(handles.max,'String');

    if isempty(x)
        errordlg('Error: Enter value first','Input Error');
    else

       value = str2double(x);

       if isnan(value)
           errordlg('Error: Input must be a number','Input Error');
       elseif (value <  Xoffset) || (value >  -Xoffset)
           errordlg('Error: Input must be in the range [Xmin:Xmax]','Input Error');
       else    

           value = round(((value- Xoffset) / Xfactor )*N);

           if (Min > value)
               errordlg('Error: Min larger than Max','Input Error');
           else
               h = waitbar(0,'Please wait. Calculating ...', 'WindowStyle', 'modal');
               
               Max = value;
               
               ResetMatrix();
               Demagnetize();
               
               
               
               GenerateInput(Max);
               GenerateInput(Min);
               GenerateInput(Max);
               GenerateInput(Min);
               
               
               
               [Output, matrix] = HysteresisNxN_GUI(input, PreisachMatrixNxN, matrix, 'normal');
               [Xoutput2, Youtput2] = Denormalize( input, Output, Xfactor, Xoffset, Yfactor, Yoffset, N);
               
               close(h)
               
               ResetPlot();
               plot(Xoutput2, Youtput2, '-r');
           end
       end


    end
    
    close(h) 



% --- Executes during object creation, after setting all properties.
function max_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
