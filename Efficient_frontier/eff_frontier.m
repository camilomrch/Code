function eff_frontier(mat,A,B,var_grid,lbound,ubound,marker,markerfacecolor,themarkerfacecolor,displayname,thedisplayname)

% This function was written by Camilo Marchesini and Daniele Vettorel
% (http://vettorel.mit.edu/).

% MATLAB_R2019a and subsequent distributions. Backward compatibility untested.

% Use this function to compute the efficiency frontier of monetary
% policy for a pair of variances (or standard deviations).
     
% For each value in the grid of a parameter, it plots all
% variance tuples implied by the combinations of that parameter with
% all parameter values in the grid of the other parameter, and
% generates a curve. The function then takes the envelope of all
% curves, the efficient frontier.
% The interpolation approach adopted here affords smoothness in the plotted
% frontier. In any way does it distort the results, but the vraisemblance will be
% higher, the thinner the parameter grid chosen.

% NOTE: Points on the frontier are equally desirable, which need not be the
% case, given a particular set of preferences of the monetary authority.
% For an optimization approach to the efficient frontier, refer to:
% Levin, Andrew, Volker Wieland and John C. Williams. 
% "The Performance Of Forecast-Based Monetary Policy Rules Under Model Uncertainty," 
% American Economic Review, 2003, v93(3,Jun), 622-645. Available at
% https://www.nber.org/papers/w6570.
     
% - mat is a matrix that contains the variances implied by
% each combination of coefficients.
% - A is the row of mat that will be running on the x-axis (e.g. the variance of inflation)
% - B is the row of mat that will be running on the y-axis (e.g. the variance of output)
% - var_grid is the grid of values taken by one of the coefficients.
% - lbound identifies the lower bound on the x axis from the
% interpolation should start
% - upbound the upperbound
% - marker is a marker symbol to identify the minima, e.g. 'rp'
% - markerfacecolor is 'MarkerFaceColor'
% - themarkerfacecolor is the marker face color of choice, e.g. 'r'
% - displayname is 'DisplayName'
% - thedisplayname is the displayname of choice, e.g. 'Taylor Rule'.
        
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
  
     
    % function start.
     
    % Make sure the length of the matrix is divisible by the length of the grid.
    mat_length = length(mat);
    grid_length = length(var_grid);
    if mod(mat_length, grid_length) ~= 0
        error('The length of the grid is not a perfect divisor of the length of the matrix to plot.');
    end 
    
    % Calculate how many iterations are needed.
    num_iterations = mat_length / grid_length;
    current_iter = 1;
    
    while current_iter <= num_iterations
        % Calculate start and end index.
        start_index = grid_length * (current_iter - 1) + 1;
        end_index = grid_length * current_iter;
        % Vectors for plot
        x=mat(A, start_index:end_index);
        y=mat(B, start_index:end_index);
        % Create new interpolation range on x-axis.
        xnew=lbound:0.001:ubound;
        xnew=transpose(xnew);
        % Create corresponding vector of y values.
        ynew = interp1(x,y,xnew,'linear');
        % reconstruct Y range.
        if current_iter==1
        Y=ynew; 
        else
        Y=[Y ynew];
        end
        % Go to next iteration.
        current_iter = current_iter + 1;
    end
         % Plot.
         plot(xnew,min(Y,[],2),marker,markerfacecolor,themarkerfacecolor,displayname,thedisplayname)
end % function end.

