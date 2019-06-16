% Minimal working example to compute efficient frontier of monetary policy
% with three policy coefficients.
% Ascertain that file eff_frontier.m is located in your current working
% directory.

% NOTE: Points on the frontier are equally desirable, which need not be the
% case, given a particular set of preferences of the monetary authority.
% For an optimization approach to the efficient frontier, refer to:
% Levin, Andrew, Volker Wieland and John C. Williams. 
% "The Performance Of Forecast-Based Monetary Policy Rules Under Model Uncertainty," 
% American Economic Review, 2003, v93(3,Jun), 622-645. Available at
% https://www.nber.org/papers/w6570.

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
  
dynare yourmodfile
% get variable positions in variable list.
pi_pos=strmatch('pi',M_.endo_names,'exact');
y_pos=strmatch('y',M_.endo_names,'exact');
% Optional: names of coefficients.
names_MP = {'PHIPI','PHIY','PHIC'};
% Grids.
PHIPI_grid = 1.1:0.05:4; % Coefficient on inflation in Taylor Rule.
PHIY_grid = 0:0.05:1; % Coefficient on output variable in Taylor Rule.
PHIC_grid = 0:0.05:1; % Coefficient on financial variable in Taylor Rule.
% Pre-allocate.
variance.pi=zeros(length(PHIPI_grid),length(PHIY_grid),length(PHIC_grid));
variance.y=zeros(length(PHIPI_grid),length(PHIY_grid),length(PHIC_grid));
mat_loop_MP=zeros(5,length(PHIPI_grid)*length(PHIY_grid)*length(PHIC_grid));
% Start counter
n=0;
% Start loop.
  for ii = 1:length(PHIPI_grid)
    for jj = 1:length(PHIY_grid)
      for kk = 1:length(PHIC_grid)
          
             set_param_value('PHIPI',PHIPI_grid(ii));
             set_param_value('PHIY',PHIY_grid(jj));
             set_param_value('PHIC',PHIC_grid(kk)); 
% try-and-catch to avoid indeterminacy occurring at specific
% parameter combination from stopping the loop.     
try
info=stoch_simul(var_list_); %loop over stoch_simul.

% In yourmodfile.mod file, you should (have) set something similar to:

% stoch_simul(order=2,irf=0);
% %make sure Dynare does not print out stuff during runs
% options_.nomoments=0;
% options_.nofunctions=1;
% options_.nograph=1;
% options_.verbosity=0;
% %set noprint option to suppress error messages within optimizer
% options_.noprint=1;
% options_.TeX=0;

% NOTE: if you are actually using -options_.noprint=1; you do not
% need this try-and-catch altogether.
catch 
    warning('Unfortunately, there seems to be a problem with this combination of paramters. Assigning a value of NaN to info.');
    info = NaN; 
end
    if info ==0
        %read out variances.    
        variance.pi(ii,jj,kk)=oo_.var(pi_pos,pi_pos);
        variance.y(ii,jj,kk)=oo_.var(y_pos,y_pos);
    else 
        fprintf('Here there is an error with this combination of paramters!\n');
        variance.pi(ii,jj,kk)=NaN;
        variance.y(ii,jj,kk)=NaN;
    end
% Next iteration.    
n=n+1;
% Store.
mat_loop_MP(:,n)=[PHIPI_grid(ii);PHIY_grid(jj);PHIC_grid(kk);variance.pi(ii,jj,kk);variance.y(ii,jj,kk)];
      end
    end
  end % End loop.
  
  % Save results.
  mat_to_plot=mat_loop_MP;
  
  % PLOT.
  x0=10;
  y0=10;
  width=1180;
  height=600;
  font = 'Century Schoolbook';
  hFig = figure('DefaultTextFontName',font,'DefaultAxesFontName',font);
  
  eff_frontier(mat_to_plot,4,5,VARRHOY_grid,0,1,'bp','MarkerFaceColor','b','DisplayName','LAW Taylor Rule');
  xlabel('Standard Deviation of Inflation');
  ylabel('Standard Deviation of Output');
  axis tight;
  
  set(gcf,'position',[x0,y0,width,height])
  savefig('efficientfrontier');
  print('efficientfrontier','-dpng','-r300');
  
  % End example.
