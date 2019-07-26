% This file illustrates a loop over parameters in Dynare (in this example,
% the Calvo probability and the indexation parameter are used to loop over -stoch_simul).

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




%... (body of your .mod file)
%... (add the following lines to the bottom of your file)

stoch_simul(order=2,periods=0,irf=0, replic=1000); % or other options, as you see fit.
%make sure Dynare does not print out unnecessary output during runs.
options_.nomoments=0;
options_.nofunctions=1;
options_.nograph=1;
options_.verbosity=0;
options_.noprint=1; % set noprint option to suppress error 
%messages within loop (If you have this option in your 
%code you need not use the try-catch statement below).
options_.TeX=0;
    % Read out variable position.
    pi_pos=strmatch('pi',M_.endo_names,'exact');

    theta_grid = 0:0.1:1;  % Grid for Calvo probability.
    chi_grid = 0:0.1:1;    % Grid for indexation parameter.
    % Loop start.
    for ii = 1:length(theta_grid)
      for jj = 1:length(chi_grid)
        set_param_value('theta',theta_grid(ii))
        set_param_value('chi',chi_grid(jj))
    % Set seed.
    set_dynare_seed('default');  
    try                              % (If you have this option in your code you need not use the options_.noprint=1 statement above).
    info=stoch_simul(M_.endo_names); % loop over stoch_simul.
    catch 
        warning('Unfortunately, there seems to be a problem with this combination of parameters. Assigning a value of NaN to info.');
        info = NaN; 
    end  
        if info ==0
            %read out variance of inflation.
            variance.pi(ii,jj)=oo_.var(pi_pos,pi_pos);
            % Print results to screen 
            fprintf('---------------------------- \n');
            fprintf('Calvo probability: %1.3f \n',theta_grid(ii));
            fprintf('Indexation parameter: %1.3f \n',chi_grid(ii));
            fprintf('Variance of inflation: %1.3f \n',variance.pi(ii,jj));
            fprintf('---------------------------- \n');
        else 
            fprintf('Here there is an error with this combination of paramters!\n');
            variance.pi(ii,jj)=NaN;
        end
      end
    end % Loop end.
      
   %End.