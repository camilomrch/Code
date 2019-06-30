
% This file saves parameter values into structure -par 
% and steady-state targets into structure -targ.
% You can easily adapt it to the parameter values and steady state-targets 
% of your own model.


% MATLAB_R2019a and subsequent distributions. Backward compatibility untested.

% This implementation was written by Camilo Marchesini.
% Copyright (C) 2019 Camilo Marchesini.

% This is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% It is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% For a copy of the GNU General Public License,
% see <http://www.gnu.org/licenses/>.

%%
% Set parameter values
BETA   =   0.99;           % Discount rate
TAU    =   1;              % Relative weight of lesiure in utility
% .    =   ;               % and so on
% .    =   ;               % and so forth

% Feed them into the structure -par
par.BETA     =   BETA;
par.TAU      =   TAU;
% .          =   ;         % and so on
% .          =   ;         % and so forth
%%
% Set steady-targets 
X   =   11;                % Desired mark-up
pi  =   1;                 % Inflation target
% . =   ;                  % and so on
% . =   ;                  % and so forth

% Feed them into the structure -targ
targ.X    =   X;
targ.pi   =   pi;
% .       =     ;       % and so on
% .       =     ;       % and so forth


% Save both structures into a .mat file
save filewithyourparameters.mat par targ;
