
% This file saves parameter values into structure -par 
% and steady-state targets into structure -targ.
% You can easily adapt it to the parameter values and steady state-targets 
% of your own model.


% MATLAB_R2019a and subsequent distributions. Backward compatibility untested.

% This implementation was written by Camilo Marchesini.

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
