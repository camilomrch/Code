% This file illustrates how to very quickly produce IRFs for model and shock
% comparisons, ready to adapted to your own model.


% This implementation was written by Camilo Marchesini.

% MATLAB_R2019a and subsequent distributions. Backward compatibility untested.

% MIT License
% 
% Copyright (c) 2019 Camilo Marchesini
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

%% Opening.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% House-keeping.
clear; close all; clc;
% % Print info.
% fprintf( ['*****************************************************************\n', ...
%           'Dynare code to replicate:\n ', ...
%           'Sims and Wu (2019) "The Four Equation New Keynesian Model",\n', ... 
%           'NBER Working Paper Series 26067.\n',...
%           '*****************************************************************\n',...
%           'This implementation was written by Camilo Marchesini.\n',...
%           '*****************************************************************\n'])
    
 %% Menu of available shocks. Select one.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% List of shocks in drop-down menu
list_shocks = {'QE shock (+)','Natural interest rate shock (-)','Credit shock (+)','Policy rate shock (+)'};
% Prompt to a select shock.
prompt_string={'Select shock of interest.'};
list_size=[300,100];
% Open drop-down menu.
[selected_shock,ok] = listdlg('PromptString',prompt_string,'SelectionMode','single','ListString',list_shocks,'ListSize',list_size);
% Assign selected shock.
button=list_shocks(selected_shock);

if strcmp(button,'QE shock (+)')
   Shockshow='QE shock (+)';  
elseif strcmp(button,'Natural interest rate shock (-)')
    Shockshow='Natural interest rate shock (-)';
elseif strcmp(button,'Credit shock (+)')
    Shockshow='Credit shock (+)';
elseif strcmp(button,'Policy rate shock (+)')
    Shockshow='Policy rate shock (+)';
end

%% Define switch.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 switch Shockshow
    case {'QE shock (+)'}
clear; close all; clc;
dynare yourmodel  -DQE_shock=1
shock = {'eps_qe'};
shock_name={'QE shock (+)'}; 
    case {'Natural interest rate shock (-)'}
clear; close all; clc;
dynare yourmodel  -DRF_shock=1
shock = {'eps_rf'};
shock_name={'Natural interest rate shock (-)'};
    case {'Credit shock (+)'}
clear; close all; clc;
dynare yourmodel  -DTHETA_shock=1
shock = {'eps_theta'};
shock_name={'Credit shock (+)'};
    case {'Policy rate shock (+)'}
clear; close all; clc;
dynare yourmodel  -DMP_shock=1
shock = {'eps_mp'};
shock_name={'Policy rate shock (+)'};
 end
      
             
%% General plot options.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Size of plot window.
x0=10;
y0=10;
width=1180;
height=2000;
goodposition=[x0,y0,width,height];
% Select font.
font = 'Century Schoolbook';

% Choose which IRF to plot.
irf_plot1={'sims_wu_3NK.'};
irf_plot2={'sims_wu_4NK.'};
% Insert legend entries.
legend_names={'3 Equation NK','4 Equation NK'};
% Cell array of variables to plot.
var_plot = {'r','x','pinf','a_rf'};
% cell array of labels
var_label = char('Policy rate','Output gap','Inflation','Natural rate');
% Scale
scale = [4,1,4,4]; % Set variables you wish to annualise to 4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load.
load('sims_wu_3NK');
load('sims_wu_4NK');

%% Additional plot options.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Length.
L=0:options_.irf;
% Number of IRF periods.
IRF_periods=L;

% Length of vectors.
nvar_plot=length(var_plot);
nvar_label=length(var_label);
nscale=length(scale);
nshock=length(shock);

% Check conformability.
if nvar_plot~=nvar_label
elseif  nvar_plot~=nscale
    er_msgbox=msgbox('Number of variables to plot, variable labels, and scale of the variables not all of the same size.');
end

% Check numSubplots.m is in working directory.
if isfile('numSubplots.m')
     nsubplots=numSubplots(nvar_plot);
     FigShape = {nsubplots(1),nsubplots(2)};
     lastplot = FigShape{1}*FigShape{2};
else
    er_mgebox = msgbox('Function file numSubplots.m is not in the working directory. Look for the file and move it to this directory to continue. If you do not have it you can download it at https://se.mathworks.com/matlabcentral/fileexchange/26310-numsubplots-neatly-arrange-subplots');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


hFig = figure('DefaultTextFontName',font,'DefaultAxesFontName',font,'DefaultLineLinewidth',2,'DefaultTextFontSize',12,'Name',shock_name{:});

% Begin loop.
    for ii=1:nvar_plot
        for kk=1:nshock
               
    subplot(FigShape{:},ii)
    plot(L,[0 scale(ii)*eval([irf_plot1{:} var_plot{1,ii} '_' shock{1,kk}])],'-b',L,[0 scale(ii)*eval([irf_plot2{:}  var_plot{1,ii} '_' shock{1,kk}])],'-r');
    title(deblank(var_label(ii,:)));
    axis tight;
    grid on;
    % Place legend in the last subplot.
    if ii==lastplot
      hleg = legend(legend_names{:},'Orientation','vertical');
      set(hleg,...
      'Location','best',...
      'EdgeColor',[1 1 1],'Color','None','Box','off','FontSize',12);
    end
    
        end
    end
 % Loop end.
   
 % Set position.
 set(gcf,'position',goodposition);

% End.