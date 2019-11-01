% This file illustrates a loop over parameters in Dynare (in this example,
% the Calvo probability and the indexation parameter are used to loop over -stoch_simul).

% This implementation was written by Camilo Marchesini.

% MATLAB_R2019a and subsequent distributions. Backward compatibility untested.
       
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




%... (body of your .mod file)
%... (add the following lines to the bottom of your file)

stoch_simul(order=2,irf=0, replic=1000); % or other options, as you see fit.
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
            fprintf('Here there is an error with this combination of paramters: \n');
            fprintf('---------------------------- \n');
            fprintf('Calvo probability: %1.3f \n',theta_grid(ii));
            fprintf('Indexation parameter: %1.3f \n',chi_grid(ii));
            fprintf('---------------------------- \n');
            variance.pi(ii,jj)=NaN;
        end
      end
    end % Loop end.
      
   %End.