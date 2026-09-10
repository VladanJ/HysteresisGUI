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
    isOctave = exist('OCTAVE_VERSION','builtin') ~= 0;

    if ~isOctave
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
        return;
    end
% End initialization code - DO NOT EDIT

    % Octave does not support GUIDE/.fig files or gui_mainfcn, so the
    % interface is rebuilt programmatically from the original .fig layout.
    handles = buildInterface();
    HysteresisGUI_OpeningFcn(handles.figure1, [], handles, varargin{:});
    if nargout
        varargout{1} = handles.figure1;
    else
        % Run as a script: block until the user closes the window so Octave
        % does not exit while the figure is still open (which throws
        % "const execution_exception& while preparing to exit").
        waitfor(handles.figure1);
    end


% --- Builds the figure and all controls (Octave replacement for the .fig).
function handles = buildInterface()

    bg = get(0,'defaultUicontrolBackgroundColor');

    % One large, resizable window holding all four diagrams and every control.
    % Everything uses normalized units so the layout scales with the window.
    fig = figure('Units','normalized', ...
                 'Position',[0.02 0.06 0.96 0.86], ...
                 'Name','Preisach hysteresis model GUI', ...
                 'NumberTitle','off', ...
                 'MenuBar','none', ...
                 'ToolBar','none', ...
                 'Color',bg, ...
                 'Tag','figure1');
    handles.figure1 = fig;
    handles.output = fig;

    % --- Four diagrams in a 2x2 grid on the left ---
    handles.axes1 = axes('Parent',fig,'Units','normalized', ...
                         'Position',[0.045 0.57 0.29 0.37],'Tag','axes1');
    title(handles.axes1,'Hysteresis loop');
    handles.axes2 = axes('Parent',fig,'Units','normalized', ...
                         'Position',[0.375 0.57 0.29 0.37],'Tag','axes2');
    title(handles.axes2,'First derivative dY/dX ~ \mu ~ L');
    xlabel(handles.axes2,'X'); ylabel(handles.axes2,'dY/dX');
    handles.axV = axes('Parent',fig,'Units','normalized', ...
                         'Position',[0.045 0.08 0.29 0.37],'Tag','axV');
    title(handles.axV,'Voltage v(t)'); xlabel(handles.axV,'t [s]'); ylabel(handles.axV,'v');
    handles.axI = axes('Parent',fig,'Units','normalized', ...
                         'Position',[0.375 0.08 0.29 0.37],'Tag','axI');
    title(handles.axI,'Current i(t)'); xlabel(handles.axI,'t [s]'); ylabel(handles.axI,'i');

    handles.FileMenu = uimenu(fig,'Label','File','Tag','FileMenu');
    handles.CloseMenuItem = uimenu(handles.FileMenu,'Label','Close', ...
                 'Tag','CloseMenuItem', ...
                 'Callback',@(s,e) CloseMenuItem_Callback(s,e,guidata(s)));

    % --- Control column on the right ---
    handles.freemode = uicontrol(fig,'Style','radiobutton','Units','normalized', ...
                 'String','Free looping mode','Position',[0.70 0.955 0.14 0.03], ...
                 'Tag','freemode','Callback',@(s,e) freemode_Callback(s,e,guidata(s)));
    handles.oneloop = uicontrol(fig,'Style','radiobutton','Units','normalized', ...
                 'String','One loop mode','Position',[0.85 0.955 0.14 0.03], ...
                 'Tag','oneloop','Callback',@(s,e) oneloop_Callback(s,e,guidata(s)));
    handles.DemagnetizeBtn = uicontrol(fig,'Style','pushbutton','Units','normalized', ...
                 'String','Reset / Demagnetize','Position',[0.70 0.905 0.29 0.04], ...
                 'Tag','DemagnetizeBtn','Callback',@(s,e) DemagnetizeBtn_Callback(s,e,guidata(s)));

    % Free-looping-mode entry (shown in free mode)
    handles.flmpanel = uipanel(fig,'Units','normalized','Position',[0.70 0.80 0.29 0.09], ...
                 'Tag','flmpanel');
    handles.text1 = uicontrol(handles.flmpanel,'Style','text','Units','normalized', ...
                 'String','Enter value between min and max on X axis:', ...
                 'Position',[0.04 0.55 0.92 0.4],'HorizontalAlignment','left','Tag','text1');
    handles.edit1 = uicontrol(handles.flmpanel,'Style','edit','Units','normalized', ...
                 'String','','Position',[0.04 0.08 0.3 0.42],'BackgroundColor','white', ...
                 'Tag','edit1','Callback',@(s,e) edit1_Callback(s,e,guidata(s)));
    handles.text2 = uicontrol(handles.flmpanel,'Style','text','Units','normalized', ...
                 'String','','Position',[0.38 0.08 0.58 0.42],'HorizontalAlignment','left','Tag','text2');

    % One-loop-mode Min/Max (shown in one-loop mode, same band as flmpanel)
    handles.olmpanel = uipanel(fig,'Units','normalized','Position',[0.70 0.80 0.29 0.09], ...
                 'Tag','olmpanel');
    handles.text4 = uicontrol(handles.olmpanel,'Style','text','Units','normalized', ...
                 'String','Min:','Position',[0.03 0.5 0.2 0.4],'HorizontalAlignment','left','Tag','text4');
    handles.min = uicontrol(handles.olmpanel,'Style','edit','Units','normalized', ...
                 'String','','Position',[0.24 0.5 0.24 0.42],'BackgroundColor','white', ...
                 'Tag','min','Callback',@(s,e) min_Callback(s,e,guidata(s)));
    handles.text5 = uicontrol(handles.olmpanel,'Style','text','Units','normalized', ...
                 'String','Max:','Position',[0.52 0.5 0.2 0.4],'HorizontalAlignment','left','Tag','text5');
    handles.max = uicontrol(handles.olmpanel,'Style','edit','Units','normalized', ...
                 'String','','Position',[0.73 0.5 0.24 0.42],'BackgroundColor','white', ...
                 'Tag','max','Callback',@(s,e) max_Callback(s,e,guidata(s)));

    % Initial state / bias (shown in one-loop mode)
    handles.biaspanel = uipanel(fig,'Units','normalized','Title','Initial state / bias', ...
                 'Position',[0.70 0.53 0.29 0.25],'Tag','biaspanel');
    uicontrol(handles.biaspanel,'Style','text','Units','normalized', ...
                 'String','Initial magnetic state:','HorizontalAlignment','left', ...
                 'Position',[0.04 0.82 0.9 0.12]);
    handles.initstate = uicontrol(handles.biaspanel,'Style','popupmenu','Units','normalized', ...
                 'String',{'Demagnetized','+ Saturation','- Saturation','+ Remanence','- Remanence','Set operating field H0'}, ...
                 'Position',[0.04 0.66 0.92 0.14],'Tag','initstate','Callback',@(s,e) RegenerateLoop(guidata(s)));
    uicontrol(handles.biaspanel,'Style','text','Units','normalized', ...
                 'String','Operating field H0:','HorizontalAlignment','left','Position',[0.04 0.48 0.9 0.12]);
    handles.h0field = uicontrol(handles.biaspanel,'Style','edit','Units','normalized', ...
                 'String','0','BackgroundColor','white','Position',[0.04 0.34 0.5 0.14],'Tag','h0field', ...
                 'Callback',@(s,e) RegenerateLoop(guidata(s)));
    uicontrol(handles.biaspanel,'Style','text','Units','normalized', ...
                 'String','DC bias field:','HorizontalAlignment','left','Position',[0.04 0.16 0.9 0.12]);
    handles.dcbias = uicontrol(handles.biaspanel,'Style','edit','Units','normalized', ...
                 'String','0','BackgroundColor','white','Position',[0.04 0.02 0.5 0.14],'Tag','dcbias', ...
                 'Callback',@(s,e) RegenerateLoop(guidata(s)));

    % Voltage -> current controls
    handles.vpanel = uipanel(fig,'Units','normalized','Title','Voltage -> current (Preisach)', ...
                 'Position',[0.70 0.06 0.29 0.45],'Tag','vpanel');
    uicontrol(handles.vpanel,'Style','text','Units','normalized','String','Voltage waveform', ...
                 'HorizontalAlignment','left','Position',[0.04 0.90 0.9 0.07]);
    handles.type = uicontrol(handles.vpanel,'Style','popupmenu','Units','normalized', ...
                 'String',{'Step: -Vmax -> +Vmax','Square wave','Sine','Ramp: -Vmax -> +Vmax','0 for 10s, then Vmin/Vmax every 500ms','Asymmetric minor loop (auto)'}, ...
                 'Position',[0.04 0.81 0.92 0.08],'Tag','viType');
    handles.Vmax = addPanelEdit(handles.vpanel, 0.04, 0.66, 'Vmax', defaultVmax());
    handles.Vmin = addPanelEdit(handles.vpanel, 0.52, 0.66, 'Vmin', ['-' defaultVmax()]);
    handles.R    = addPanelEdit(handles.vpanel, 0.04, 0.48, 'R (resistance)', defaultR());
    handles.T    = addPanelEdit(handles.vpanel, 0.52, 0.48, 'T total [s]', '20');
    handles.dt   = addPanelEdit(handles.vpanel, 0.04, 0.30, 'dt step [s]', '0.005');
    handles.compute = uicontrol(handles.vpanel,'Style','pushbutton','Units','normalized', ...
                 'String','Compute current','Position',[0.04 0.05 0.92 0.13], ...
                 'Tag','computeVI','Callback',@(s,e) computeVI(guidata(s)));

    guidata(fig, handles);


% --- Adds a labelled edit box (label above the box) inside a panel and returns
%     the edit handle.  Coordinates are normalized to the panel.
function h = addPanelEdit(parent, x, y, label, val)

    w = 0.44;
    uicontrol(parent,'Style','text','Units','normalized','String',label, ...
              'HorizontalAlignment','left','Position',[x y+0.09 w 0.07]);
    h = uicontrol(parent,'Style','edit','Units','normalized','String',val, ...
                  'BackgroundColor','white','Position',[x y w 0.08]);


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
    global gAxes;
    global gAxes2;

    N = 1000;
    Min = N/2;
    Max = N/2;

    gAxes = handles.axes1;
    gAxes2 = handles.axes2;

    hSplash = splash('SplashScrn','png');
    
    ResetMatrix();


    [UpperpartOfLoopX, UpperpartOfLoopY, LowerpartOfLoopX, LowerpartOfLoopY, PlotX, PlotY] = fp ('XvaluesMAX.tsv', 'YvaluesMAX.tsv', 150);

    axes(handles.axes1);
    scatter(PlotX, PlotY, 2);
    set(gca, 'FontSize', 10);

    [PreisachMatrixNxN, Xfactor, Xoffset, Yfactor, Yoffset] = cachedPreisachMatrix(LowerpartOfLoopX, LowerpartOfLoopY, UpperpartOfLoopX, UpperpartOfLoopY, N);
    
    Demagnetize();
    
    
    
    
    set(handles.oneloop,'value',1);
    workingMode = 2;  
    SetVisibility(handles, workingMode);
    set(handles.min,'String',sprintf('%0.3f',(((Min/N)*Xfactor)+ Xoffset)));
    set(handles.max,'String',sprintf('%0.3f',(((Max/N)*Xfactor)+ Xoffset)));
    set(handles.Vmax,'String',defaultVmax());
    set(handles.Vmin,'String',['-' defaultVmax()]);
    set(handles.R,'String',defaultR());

    axes(handles.axes1);
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
        set(handles.flmpanel,'Visible','On');
        set(handles.olmpanel,'Visible','Off');
        set(handles.biaspanel,'Visible','Off');
    elseif (workingMode == 2)
        set(handles.DemagnetizeBtn,'Enable','off');
        set(handles.flmpanel,'Visible','Off');
        set(handles.olmpanel,'Visible','On');
        set(handles.biaspanel,'Visible','On');
    end

    
function GenerateInput(value)

    global input; 
    
    if (input(end) < value)
        input = [input, [input(end)+1:1:value]];
    elseif (input(end) > value)
        input = [input, [input(end)-1:-1:value]];
    end
    
    
    

% --- Rebuilds the one-loop excitation from the chosen initial magnetic state
%     and DC bias, then plots the (possibly asymmetric) hysteresis loop.
function RegenerateLoop(handles)

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

    h = waitbar(0,'Please wait. Calculating ...');

    ResetMatrix();
    PrepareInitialState(handles);          % sets state matrix + input(end)

    biasIdx = round(getNum(handles.dcbias, 0) / Xfactor * N);
    maxB = min(N, max(1, Max + biasIdx));
    minB = min(N, max(1, Min + biasIdx));

    GenerateInput(maxB);
    GenerateInput(minB);
    GenerateInput(maxB);
    GenerateInput(minB);

    [Output, matrix] = HysteresisNxN_GUI(input, PreisachMatrixNxN, matrix, 'normal');
    [Xoutput2, Youtput2] = Denormalize(input, Output, Xfactor, Xoffset, Yfactor, Yoffset, N);

    if ishghandle(h); close(h); end

    ResetPlot();
    axes(handles.axes1);
    plot(Xoutput2, Youtput2, '-r');
    PlotDerivative(Xoutput2, Youtput2);


% --- Establishes the starting Preisach state (residual magnetization / bias)
%     selected in the "Initial magnetic state" control.
function PrepareInitialState(handles)

    global Xfactor;
    global Xoffset;
    global input;
    global N;

    mode = get(handles.initstate, 'Value');
    idx0 = fieldToIdx(0, Xfactor, Xoffset, N);   % index of zero field (H = 0)

    switch mode
        case 1   % Demagnetized
            Demagnetize();
        case 2   % Positive saturation
            driveTo(1, N);
            input = N;
        case 3   % Negative saturation
            driveTo(1, N);
            driveTo(N, 1);
            input = 1;
        case 4   % Positive remanence (+saturate, return to H = 0)
            driveTo(1, N);
            driveTo(N, idx0);
            input = idx0;
        case 5   % Negative remanence (-saturate, return to H = 0)
            driveTo(1, N);
            driveTo(N, 1);
            driveTo(1, idx0);
            input = idx0;
        case 6   % Bring to an operating field H0 (from demagnetized)
            Demagnetize();
            idxH0 = fieldToIdx(getNum(handles.h0field, 0), Xfactor, Xoffset, N);
            driveTo(input(end), idxH0);
            input = idxH0;
    end


% --- Feeds a one-step-at-a-time field ramp from index a to index b into the
%     Preisach model, advancing the global state matrix.
function driveTo(a, b)

    global PreisachMatrixNxN;
    global matrix;

    a = round(a); b = round(b);
    if a == b
        seq = a;
    elseif a < b
        seq = a:1:b;
    else
        seq = a:-1:b;
    end
    [~, matrix] = HysteresisNxN_GUI(seq, PreisachMatrixNxN, matrix, 'depolarizing');


% --- Maps a real field value to a Preisach field index (clamped to 1..N).
function idx = fieldToIdx(H, Xfactor, Xoffset, N)

    idx = round(((H - Xoffset) / Xfactor) * N);
    idx = min(N, max(1, idx));


% --- Reads a numeric value from an edit control, returning a default if empty
%     or invalid.
function v = getNum(hEdit, default)

    v = str2double(get(hEdit, 'String'));
    if isnan(v)
        v = default;
    end


function ResetPlot()

    global PlotX; 
    global PlotY;
    global gAxes;
    global gAxes2;
    if ~isempty(gAxes) && ishghandle(gAxes)
        axes(gAxes);
    end
    cla reset
    scatter(PlotX, PlotY, 2);
    title('Hysteresis loop');
    hold on;
    if ~isempty(gAxes2) && ishghandle(gAxes2)
        axes(gAxes2);
        cla reset;
        title('First derivative dY/dX ~ μ ~ L');
        xlabel('X'); ylabel('dY/dX');
        hold on;
    end

function PlotDerivative(X, Y)

    global gAxes;
    global gAxes2;
    global Xoffset;
    if isempty(gAxes2) || ~ishghandle(gAxes2)
        return;
    end
    X = X(:);
    Y = Y(:);
    dydx = diff(Y) ./ diff(X);
    dydx(~isfinite(dydx)) = NaN;   % ignore spikes at loop turning points
    xd = X(1:end-1);
    win = min(31, max(3, 2*floor(numel(dydx)/10)+1));
    dydx = SmoothSignal(dydx, win);

    axes(gAxes2);
    cla(gAxes2);
    hold on;
    title(gAxes2, 'First derivative dY/dX ~ \mu ~ L');
    xlabel(gAxes2, 'X'); ylabel(gAxes2, 'dY/dX');

    % Split into monotonic segments; direction reverses at each loop turning point.
    dir = sign(diff(X));
    dir(dir == 0) = 1;
    bounds = [0; find(dir(1:end-1) ~= dir(2:end)); numel(dir)];
    nSeg = numel(bounds) - 1;
    nColors = min(8, max(1, nSeg));     % coloring scheme: at most 8 colors, cycled
    colors = lines(nColors);
    hLegend = zeros(1, nColors);
    for s = 1:nSeg
        ci = mod(s - 1, nColors) + 1;
        a = bounds(s) + 1;
        b = bounds(s+1);
        h = plot(xd(a:b), dydx(a:b), '-', 'Color', colors(ci,:), 'LineWidth', 1.2);
        if s <= nColors
            hLegend(s) = h;
        end
    end

    % Keep the derivative plot centered on 0 (symmetric y-axis) at all times.
    ymax = max(abs(dydx(isfinite(dydx))));
    if isempty(ymax) || ymax == 0
        ymax = 1;
    end
    set(gAxes2, 'YLim', [-ymax, ymax]);

    if nSeg > 0
        labels = arrayfun(@ordinalLabel, 1:nColors, 'UniformOutput', false);
        legend(gAxes2, hLegend, labels, 'Location', 'southoutside', 'Orientation', 'horizontal');
    end

    % Match the hysteresis plot x-axis, centered on 0 (Xmin = Xoffset, Xmax = -Xoffset).
    xl = [Xoffset, -Xoffset];
    set(gAxes2, 'XLim', xl);
    if ~isempty(gAxes) && ishghandle(gAxes)
        set(gAxes, 'XLim', xl);
    end

% --- Ordinal label ('1st', '2nd', ...) for the n-th derivative segment.
function s = ordinalLabel(n)

    switch n
        case 1
            s = '1st';
        case 2
            s = '2nd';
        case 3
            s = '3rd';
        otherwise
            s = sprintf('%dth', n);
    end

function ys = SmoothSignal(y, w)
% Moving-average smoothing that ignores NaN samples.

    y = y(:);
    n = numel(y);
    ys = y;
    half = floor(w/2);
    for i = 1:n
        lo = max(1, i-half);
        hi = min(n, i+half);
        seg = y(lo:hi);
        seg = seg(isfinite(seg));
        if isempty(seg)
            ys(i) = NaN;
        else
            ys(i) = mean(seg);
        end
    end
    
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
           h = waitbar(0,'Please wait. Calculating ...');
           
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
           axes(handles.axes1);
           plot(Xoutput2, Youtput2, '-r');
           PlotDerivative(Xoutput2, Youtput2);
       end


    end



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    


function DemagnetizeBtn_Callback(hObject, eventdata, handles)
  
    global workingMode;
    
    h = waitbar(0,'Please wait. Calculating ...');
    
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
    
    h = waitbar(0,'Please wait. Calculating...');  
    

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
    
    h = waitbar(0,'Please wait. Calculating ...');    
    
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
               Min = value;
               RegenerateLoop(handles);
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
               Max = value;
               RegenerateLoop(handles);
           end
       end


    end



% --- Executes during object creation, after setting all properties.
function max_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Default Vmax that sweeps roughly the full flux range over a half period.
function s = defaultVmax()

    global PlotY;
    if isempty(PlotY)
        s = '1';
    else
        s = sprintf('%.3g', (max(PlotY) - min(PlotY)) / 10);
    end


% --- Default winding resistance so the steady current V/R stays inside the
%     current range (avoids the current running straight to saturation).
function s = defaultR()

    global Xfactor;
    global Yfactor;
    if isempty(Xfactor) || isempty(Yfactor) || Xfactor == 0
        s = '1';
    else
        s = sprintf('%.3g', Yfactor / (5 * Xfactor));
    end


% --- Drives the Preisach model with the voltage waveform and updates the four
%     diagrams in the main window (loop, ~L, voltage, current).  Starts from the
%     magnetic state currently held by the GUI (not necessarily demagnetised).
function computeVI(handles)

    global PlotX;
    global PlotY;
    global PreisachMatrixNxN;
    global matrix;
    global input;
    global N;
    global Xfactor;
    global Xoffset;
    global Yfactor;
    global Yoffset;

    if isempty(PreisachMatrixNxN)
        errordlg('Hysteresis model is not available yet.','Voltage / Current');
        return;
    end

    Vmax = str2double(get(handles.Vmax,'String'));
    Vmin = str2double(get(handles.Vmin,'String'));
    R    = str2double(get(handles.R,'String'));
    T    = str2double(get(handles.T,'String'));
    dt   = str2double(get(handles.dt,'String'));

    if any(isnan([Vmax Vmin R T dt])) || T <= 0 || dt <= 0
        errordlg('Enter valid numbers (T > 0, dt > 0).','Input Error');
        return;
    end

    typ = get(handles.type,'Value');
    t   = 0:dt:T;
    v   = voltageWaveform(typ, t, Vmax, Vmin);

    if isempty(input)
        ci0 = round(N/2);
    else
        ci0 = input(end);
    end

    hbusy = [];
    if numel(t) > 4000
        hbusy = waitbar(0,'Driving the Preisach model ...');
    end
    [i, psi] = simVoltagePreisach(t, v, R, PreisachMatrixNxN, matrix, ci0, ...
                                  N, Xfactor, Xoffset, Yfactor, Yoffset);
    if ~isempty(hbusy) && ishghandle(hbusy); close(hbusy); end

    % Hysteresis loop actually traced by this excitation, over the major loop.
    axes(handles.axes1); cla; hold on;
    plot(PlotX, PlotY, 'Color',[0.7 0.7 0.7]);      % reference major loop
    plot(i, psi, '-b','LineWidth',1.2);
    title('Hysteresis loop'); xlabel('X'); ylabel('Y'); grid on;

    % Differential inductance ~ dPsi/di, drawn with the shared derivative plot.
    PlotDerivative(i, psi);

    axes(handles.axV); cla;
    plot(t, v, '-b','LineWidth',1.2); grid on;
    title('Voltage v(t)'); xlabel('t [s]'); ylabel('v');
    ymarg = 0.1*max(abs(v)) + eps;
    ylim([min(v)-ymarg, max(v)+ymarg]);

    axes(handles.axI); cla;
    plot(t, i, '-r','LineWidth',1.2); grid on;
    title('Current i(t)'); xlabel('t [s]'); ylabel('i');


% --- Generates the selected voltage waveform over the time vector t.
function v = voltageWaveform(typ, t, Vmax, Vmin)

    global PlotY;

    T = t(end);
    switch typ
        case 1   % step: -Vmax for the first half, +Vmax for the second half
            v = -Vmax * ones(size(t));
            v(t >= T/2) = Vmax;
        case 2   % square wave alternating between Vmax (high) and Vmin (low)
            sq = sign(sin(2*pi*(2/T)*t));
            v = Vmin * ones(size(t));
            v(sq >= 0) = Vmax;
        case 3   % sine (two periods over T) oscillating between Vmax and Vmin
            v = (Vmax + Vmin)/2 + (Vmax - Vmin)/2 * sin(2*pi*(2/T)*t);
        case 4   % linear ramp from -Vmax to +Vmax
            v = -Vmax + 2*Vmax*(t/T);
        case 5   % 0 V for 10 s, then alternate Vmin/Vmax every 500 ms
            v = zeros(size(t));
            t0 = 10; hold_ = 0.5;
            active = t >= t0;
            k = floor((t - t0)/hold_);       % half-cycle index after t0
            v(active & mod(k,2) == 0) = Vmin;
            v(active & mod(k,2) == 1) = Vmax;
        case 6   % Asymmetric minor loop: short bias pulse, then small AC.
                 % Amplitudes are auto-scaled from the flux range so the volt-
                 % seconds stay well inside saturation (an asymmetric minor loop).
            hr    = (max(PlotY) - min(PlotY)) / 2;   % half of the full flux range
            tb    = 0.15 * T;                        % bias-pulse duration
            tauac = max(0.25, (T - tb) / 20);        % AC half-period
            Vbias = 0.30 * hr / tb;                  % ~0.30*hr of bias flux
            Vac   = 0.30 * hr / tauac;               % AC peak-to-peak ~0.30*hr
            v = zeros(size(t));
            v(t < tb) = Vbias;
            ac = t >= tb;
            k  = floor((t - tb) / tauac);
            v(ac & mod(k,2) == 0) =  Vac;
            v(ac & mod(k,2) == 1) = -Vac;
        otherwise
            v = zeros(size(t));
    end


% --- Preisach-driven Method B: v = R*i + dPsi/dt.  At every time step the
%     current index is advanced one Preisach cell at a time (the model's native
%     resolution) until the flux has changed by the amount the voltage demands,
%     or the current saturates.  Returns real-unit current and flux.
function [i, psi] = simVoltagePreisach(t, v, R, H, matrix0, ci0, N, Xf, Xo, Yf, Yo)

    psiM = sum(sum(matrix0 .* H));          % model-unit flux of carried state
    matrix = double(matrix0);               % local copy - do not touch main state
    ci = max(1, min(N, round(ci0)));

    n = numel(t);
    i   = zeros(1, n);
    psi = zeros(1, n);
    i(1)   = (ci*Xf)/N + Xo;
    psi(1) = (psiM*Yf)/N + Yo;

    for k = 1:n-1
        dtk  = t(k+1) - t(k);
        icur = (ci*Xf)/N + Xo;
        dPsiTarget = ((v(k) - R*icur) * dtk) * N / Yf;   % required change, model units
        s = sign(dPsiTarget);
        moved = 0;
        guard = 0;
        while s ~= 0 && abs(moved) < abs(dPsiTarget) ...
                && ci + s >= 1 && ci + s <= N && guard < 2*N
            [matrix, psiM, ci, dstep] = stepIndexPreisach(matrix, H, ci + s, N, psiM);
            moved = moved + dstep;
            guard = guard + 1;
        end
        i(k+1)   = (ci*Xf)/N + Xo;
        psi(k+1) = (psiM*Yf)/N + Yo;
    end


% --- Advances the Preisach state to current index x using the canonical
%     HysteresisNxN_GUI engine to keep a single source of truth.
function [matrix, psiM, ci, dstep] = stepIndexPreisach(matrix, H, x, N, psiM)

    [psiNext, matrix] = HysteresisNxN_GUI(round(x), H, matrix, 'normal');
    psiNext = psiNext(end);
    dstep = psiNext - psiM;
    psiM = psiNext;
    ci = max(1, min(N, round(x)));


% --- Generates the Preisach weight matrix, or loads it from a local cache when
%     the loop data and N are unchanged (generation costs ~40 s at N = 1000).
function [Hm, Xf, Xo, Yf, Yo] = cachedPreisachMatrix(LoX, LoY, UpX, UpY, N)

    sig = [N, numel(LoX), numel(UpX), ...
           sum(LoX(:)), sum(LoY(:)), sum(UpX(:)), sum(UpY(:)), ...
           sum(LoX(:).^2), sum(LoY(:).^2), sum(UpX(:).^2), sum(UpY(:).^2)];

    cacheFile = fullfile(fileparts(mfilename('fullpath')), 'preisach_cache.mat');

    if exist(cacheFile, 'file')
        try
            S = load(cacheFile);
            if isfield(S,'sig') && numel(S.sig) == numel(sig) ...
                    && all(abs(S.sig - sig) <= 1e-6 * (1 + abs(sig)))
                Hm = S.Hm; Xf = S.Xf; Xo = S.Xo; Yf = S.Yf; Yo = S.Yo;
                return;
            end
        catch
            % fall through and regenerate on any load problem
        end
    end

    [Hm, Xf, Xo, Yf, Yo] = PreisachModelMatrixGeneration(LoX, LoY, UpX, UpY, N);

    try
        save('-binary', cacheFile, 'sig', 'Hm', 'Xf', 'Xo', 'Yf', 'Yo');
    catch
        % caching is best-effort; ignore write failures
    end
