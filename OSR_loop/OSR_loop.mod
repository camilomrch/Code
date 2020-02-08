
% This file illustrates how to use Dynare's OSR utility to 
% search for the Taylor-rule coefficients that
% minimize the loss function of the policy-maker while looping over the 
% weights of the loss function, so that for each set of preferences, 
% an optimal rule simple rule is derived.
% It is straightforward to enlarge the search to
% more Taylor-rule coefficients and alternative preferences of the policy-maker.


% This implementation was written by Camilo Marchesini.

% MATLAB_R2019a and subsequent distributions. Backward compatibility untested.

%     Copyright (C) 2020  Camilo Marchesini
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



% Model block ...

% Shock block ...



% Set optimal weights.

optim_weights;

pinf   1;

ygap   0.1;

rgap   0.1;

end;

% Declare paramters over which the policy-maker optimizes
osr_params PHI_PI PHI_Y PHI_R;

% Impose bounds on the search.

osr_params_bounds;

PHI_PI, 1.5,  2.5;

PHI_Y, 0,   1;

PHI_R, 0.80, 0.99;

end;

% Solve.
osr(nograph,opt_algo=9) pinf ygap rgap;


% make loop silent

options_.nofunctions=1;

options_.nocorr=1;

options_.noprint=1;

options_.irf=0;

options_.silent_optimizer=1;

options_.osr.opt_algo=9;


% find position of variables in variable_weights

pinf_pos=strmatch('pinf',M_.endo_names,'exact');

ygap_pos=strmatch('ygap',M_.endo_names,'exact');

rgap_pos=strmatch('rgap',M_.endo_names,'exact');


% find position of variables in var_list_

pinf_pos_var_list_=strmatch('pinf',var_list_,'exact');

ygap_pos_var_list_=strmatch('ygap',var_list_,'exact');

rgap_pos_var_list_=strmatch('rgap',var_list_,'exact');


% Set up grids and get lenght of weights vector.

ygap_grid=0:0.02:1;

rgap_grid=0:0.02:1;

n_ygap=length(ygap_grid);

n_rgap=length(rgap_grid);

var_pinf=NaN(n_ygap,n_rgap);

var_ygap=NaN(n_ygap,n_rgap);

var_rgap=NaN(n_ygap,n_rgap);


% Normalised weight on inflation.

M_.osr.variable_weights(pinf_pos,pinf_pos) = 1;

% Start counter.

n=0;

% Loop start.
for jj=1:n_ygap

   for kk=1:n_rgap

    M_.osr.variable_weights(pinf_pos,pinf_pos) = 1;

    M_.osr.variable_weights(ygap_pos,ygap_pos) = ygap_grid(jj);

    M_.osr.variable_weights(rgap_pos,rgap_pos) = rgap_grid(kk);

    oo_.osr = osr(var_list_,M_.osr.param_names,M_.osr.variable_indices,M_.osr.variable_weights);

    if oo_.osr.error_indicator==0

        var_pinf(jj,kk)=oo_.var(pinf_pos_var_list_,pinf_pos_var_list_);

        var_ygap(jj,kk)=oo_.var(ygap_pos_var_list_,ygap_pos_var_list_);

        var_rgap(jj,kk)=oo_.var(rgap_pos_var_list_,rgap_pos_var_list_);

    end

% Next iteration.   

n=n+1;

% Store.

mat_loop(:,n)=[oo_.osr.optim_params.PHI_PI;oo_.osr.optim_params.PHI_Y;oo_.osr.optim_params.PHI_R;...

              1;ygap_grid(jj);rgap_grid(kk);sqrt(var_pinf(jj,kk));sqrt(var_ygap(jj,kk));sqrt(var_rgap(jj,kk))];

   end

end  % Loop end.

% Save matrix.

save('mat_loop');

% End