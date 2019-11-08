function [ys,check] = Sims_and_Wu_2019_full_nonlinear_steadystate(ys,exe)

global M_ lgy_

% read out parameters to access them with their name
if isfield(M_,'param_nbr')==1
    NumberOfParameters = M_.param_nbr;                            % Number of deep parameters.
    for i = 1:NumberOfParameters                                  % Loop...
        paramname = deblank(M_.param_names(i,:));                   %    Get the name of parameter i.
        eval([ paramname ' = M_.params(' int2str(i) ');']);         %    Get the value of parameter i.
    end
    % initialize indicator
    check = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BEGINNING OF MODEL BLOCK.
pinf=PINF_ss;
lamb=BETA;
lambb=BETAB;
Rs=1/BETA;
Rb=1/BETAB;
Rre=Rs;
omega=BETA*(Rb-Rs);
pm=(EPSILONP-1)/EPSILONP;
w=pm;
pstar=1;
vp=1;
Q=1/(Rb-KAPPA);
A=0;
thet=THET_ss;
L=1;
C=((PSI*L^CHI)/w)^(-1/SIGMA);
Cb=1-C;
Y=C+Cb;
b=Cb/Q;
b_FI=(thet*X_FI)/Q;
b_CB=b-b_FI;
QE=Q*b_CB;
re=QE;
s=X_FI*(thet*(1-KAPPA)-1)+re;
x1=(Y*pm)/(1-BETA*PHI);
x2=Y/(1-BETA*PHI);
% Output gap
% X=1    % as X=Y/Yf;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% END OF MODEL BLOCK



%% Update parameters set in the file
for iter = 1:length(M_.params)
    eval([ 'M_.params(' num2str(iter) ') = ' M_.param_names(iter,:) ';' ])
end
if isfield(M_,'param_nbr') == 1
    if isfield(M_,'orig_endo_nbr') == 1
        NumberOfEndogenousVariables = M_.orig_endo_nbr;
    else
        NumberOfEndogenousVariables = M_.endo_nbr;
    end
    %% Here we define the steady state values of the endogenous variables of the model.
    ys = zeros(NumberOfEndogenousVariables,1); % Initialization of ys (steady state).
    for ii = 1:NumberOfEndogenousVariables %-size(M_.aux_vars,2)
        varname = deblank(M_.endo_names(ii,:));
        eval(['ys(' int2str(ii) ') = ' varname ';']);
    end
else
    ys=zeros(length(lgy_),1);
    for ii = 1:length(lgy_)
        ys(ii) = eval(lgy_(ii,:));
    end
    check = 0;
end


end