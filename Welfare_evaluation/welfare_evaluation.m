  
% This file illustrates how to search for the parameter value that maximizes
% unconditional welfare, compute the consumption equivalent variation, 
% and plot the results for welfare evaluation. 
% It is straightforward to enlarge the search to
% more parameters; use alternative formulas for the consumption equivalent
% variation to accommodate utility functions other than log, and to allow for
% 3D-plots when the search spans bidimensional parameter space.



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




  % Run .mod file.
  dynare yourmodfile
  
  % Remember to add       options_.noprint=1;     
  % just below your call to the solver in your .mod file
  % E.g.
  % stoch_simul(...)
  % options_.noprint=1; 
  
 
  % get position of welfare in variable list.
  W_pos=strmatch('W',M_.endo_names,'exact');

  % grid of values of PARAMETER.
  PARAMETER_grid = 0:0.05:1; 
  % value of the parameter that corresponds to the benchmark economy.
  benchmark_economy=0;
  % pre-allocate.
  mean.W=zeros(length(PARAMETER_grid),1);
  lambda=zeros(length(PARAMETER_grid),1);
  mat_loop_MP=zeros(3,length(PARAMETER_grid));

  n=0; % start counter.
  
  for ii = 1:length(PARAMETER_grid)
 
     set_param_value('PARAMETER',PARAMETER_grid(ii));

         info=stoch_simul(var_list_); % loop over stoch_simul.

         if info ==0
            % Read out mean of welfare.
            mean.W(ii)=oo_.mean(W_pos);
            % Look for the position of the benchmark value in the vector of
            % paramter values.
            [row, column] = find(PARAMETER_grid == benchmark_economy);
            % Assign position.
            benchmark_pos=column;
            % Remember that this formula is valid only with log utility.
            lambda(ii)=exp((1-BETA)*(mean.W(ii)-mean.W(benchmark_pos)))-1;    
         else 
            fprintf('Here there is an error with this value of the parameter of interest: %1.3 \n',PARAMETER_grid(ii));
            % assign NAN to problematic value.
            mean.W(ii)=NaN;
            lambda(ii)=NaN;  
         end    
   n=n+1;  % Next iteration.
   
   % Store.
   mat_loop_MP(:,n)=[PARAMETER_grid(ii);lambda(ii)*100;mean.W(ii)];
   
  end % loop end.
  
  
% Search the matrix to find the max value of welfare
 maxValue_MP = max(mat_loop_MP(size(mat_loop_MP,1),:));
 [row, column] = find(mat_loop_MP == maxValue_MP);
 optim_W_MP=mat_loop_MP(:,column);
 
 % Series.
 % Values of the parameter of interest.
 x=mat_loop_MP(1,:);
 % Values of the consumption equivalent variation.
 lam=mat_loop_MP(2,:);
 % Values of welfare.
 welfare=mat_loop_MP(3,:);

 % Optimal values.
 x_opt=optim_W_MP(1,:); % parameter value that maximizes welfare.
 lam_opt=optim_W_MP(2,:); % consumption equivalent variation associated with maximized welfare.
 welfare_opt=optim_W_MP(3,:); % maximized welfare.
  


%% Set plot options.
% (customise at will)
%%%%%%%%%%%%%%%%%        

x0=10;
y0=10;
width=1180;
height=2000;

font = 'Century Schoolbook';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot.
hFig = figure('DefaultTextFontName',font,'DefaultAxesFontName',font,'DefaultLineLinewidth',2,'DefaultTextFontSize',14,'Name','Welfare Evaluation');
subplot(2,1,1);
plot(x,welfare)
hold on 
plot(x_opt,welfare_opt,'r*') % mark max welfare corresponding to the optimal parameter
title('Stochastic Ergodic Mean of Welfare');
xlabel('Parameter of Interest');
ylabel('Unconditional Welfare');
subplot(2,1,2);
plot(x,lam)
hold on 
plot(x_opt,lam_opt,'r*') % mark consumption equivalent corresponding to the optimal parameter
ylabel('CE (%)')
xlabel('Parameter of Interest')
title('Consumption equivalent variation \lambda'); 
set(gcf,'position',[x0,y0,width,height]);
% Save Matlab figure.
savefig('Welfare_Evaluation');
% Save as .png file.
print('Welfare_Evaluation','-dpng','-r300');
% End figure.
% End.

