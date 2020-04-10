function GetPar(Parameters,Targets,TexSyms)

% Parameters.
BETA   =   0.99;   tex_sym_BETA={'$\\beta$'};      
TAU    =   1;      tex_sym_TAU={'$\\tau$'};

% Targets.
X     = 11;        tex_sym_X={'$X$'};
pi_ss =1.005;      tex_sym_pi_ss={'$\\pi$'};


Parameters=[
    BETA 
    TAU
    ];

Targets=[
    X
    pi_ss
    ];

% Tex Syms
TexSyms_par=[
tex_sym_BETA
tex_sym_TAU
];
TexSyms_targ=[
tex_sym_X
tex_sym_pi_ss
];

nPar=length(Parameters);
nTar=length(Targets);
nTex_par=length(TexSyms_par);
nTex_targ=length(TexSyms_par);
if nPar~=nTar || nPar~=nTex_par || nPar~=nTex_tar
warning('Not all paramters or calibration targets have been assigned a (LaTex) symbol')

for ii=1:nPar
    par.(strtrim(Parameters(ii)))=Parameters(ii)
end










% This file saves parameter values into structure -par 
% and steady-state targets into structure -targ.
% You can easily adapt it to the parameter values and steady state-targets 
% of your own model.


% MATLAB_R2019a and subsequent distributions. Backward compatibility untested.

% This implementation was written by Camilo Marchesini.

%     Copyright (C) 2019  Camilo Marchesini
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.

%%
% Set parameter values
BETA   =   0.99;           % Discount rate
TAU    =   1;              % Relative weight of lesiure in utility

% Feed them into the structure -par
par.BETA     =   BETA;
par.TAU      =   TAU;
% .          =   ;         % and so on
% .          =   ;         % and so forth
%%
% Set steady-targets 
X   =   11;                % Desired mark-up
pi_ss  =   1;              % Inflation target
% . =   ;                  % and so on
% . =   ;                  % and so forth

% Feed them into the structure -targ
targ.X    =   X;
targ.pi_ss   =   pi_ss;
% .       =     ;          % and so on
% .       =     ;          % and so forth


% Save both structures into a .mat file
save filewithyourparameters.mat par targ;
