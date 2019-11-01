% This file illustrates how to calibrate the size of the shock to
% achieve the desired response of a specific variable the quarter the shock
% hits.

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


dynare yourmodfile
 
% Structure that contains the IRFs
irf_name={'oo_.irfs.'};
% Variable whose size of the fluctuaton one wants to match.
var_of_interest={'b_CB'};
% Shock of interest (make shock name as charater type)
shock={'eps_QE'};  exo_name=char(shock);
% Find position in declaration of exogenous variables.
eps_pos=strmatch(exo_name,M_.exo_names,'exact');
% Desired deviation of the variable from steady-state at the time the shock hits.
desired_value=1.000000;
% Grid.
SIGM_grid = 0.01:0.0001:0.05; % Standard deviation of shock.
% Pre-allocate.
response_size=zeros(length(SIGM_grid),1);
% Storage matrix.
mat_loop=zeros(2,length(SIGM_grid));
% Start counter.
n=0;
% Start loop.
  for ii = 1:length(SIGM_grid)
          % Assign variance to the correct diagonal element in the
          % variance-covariance matrix.
          M_.Sigma_e(eps_pos,eps_pos) = SIGM_grid(ii); 
          % you can rescale as 100*SIGM_grid(ii)
          % if you are when your are simulating the model with a first-order Taylor approximation.
          
          info=stoch_simul(var_list_); % loop over stoch_simul.
 
      if info == 0
        % Store the response of the variable of interest on impact.
        irf_of_interest=eval([irf_name{:} var_of_interest{:} '_' shock{:}]);
        % Take the response on impact, i.e. the first value in the IRF
        % produced by Dynare.
        response_size(ii)=irf_of_interest(1);
      else
        fprintf('Here there is an error with this paramter value:\n');
        fprintf('---------------------------- \n');
        fprintf('Shock size: %1.3f \n',SIGM_grid(ii));
        fprintf('---------------------------- \n');
        response_size(ii)=NaN;
     end
% Next iteration.   
n=n+1;
% Store.
mat_loop(:,n)=[SIGM_grid(ii);response_size(ii)];
   end % End loop.
 
% Find the response that is closest to the desired value.
[~,index]=min(abs(response_size-desired_value));
% Print to screen the right shock size and corresponding response size.
fprintf('Variance of the shock: %1.3f \n',SIGM_grid(index))
fprintf('will yield a response of %1.3f to variable %s.\n',response_size(index), string(var_of_interest))
% End