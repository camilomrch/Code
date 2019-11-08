//*************************************************************************
//  Sims and Wu (2019) "The Four Equation New Keynesian Model",
// NBER Working Paper Series 26067.
// Programmer: Camilo Marchesini
//*************************************************************************

//*************************************************************************
// In this script I compute the Ramsey-optimal path for QE and the interest rate,
// when the economy is hit contemporaneusly by shocks to the natural rate of interest and
// shocks to credit conditions.
// As described in Proposition 1 in the paper, when both instruments are available  and for any weight on the 
// output gap in the loss function, optimal policy completely stabilizes both inflation and the output gap.
//*************************************************************************

// Endogenous variables 
var   a_theta                (long_name='Credit conditions')
      a_rf                   (long_name='Natural rate of interest')
      qe                     (long_name='Long bond portfolio')
      x                      (long_name='Output gap')
      pinf                   (long_name='Consumer-price inflation')
      r                      (long_name='Policy rate')
;

// Exogenous variables 
varexo eps_rf                (long_name='Natural interest rate shock')
       eps_theta
;

// Parameters
parameters BETA              (long_name='Discount factor')
           ZED               (long_name='Consumption share of children in the population')
           SIGMA             (long_name='Inverse Elasticity of Substitution')
           B_FIss            (long_name='Weight on leverage in IS/NKPC curves')
           B_CBss            (long_name='Weight on QE in IS/NKPC curves')
           GAMMA             (long_name='Elaticity of inflation w.r.t. marginal cost')
           ZETA              (long_name='Elaticity of output gap w.r.t. marginal cost')
           PHI_R             (long_name='Smoothing coefficient in the interest rate rule')
           PHI_PI            (long_name='Feedback coefficient on inflation in the interest rate rule')
           PHI_X             (long_name='Feedback coefficient on output gap in the interest rate rule')
           RHO_RF            (long_name='Persistence of natural rate shock')
           RHO_THETA         (long_name='Persistence of credit shock')
           SIGM_RF           (long_name='Standard deviation of natural rate shock')
           SIG_THETA         (long_name='Standard deviation of natural rate shock')
%%%%%%%%%%%%%%%%%  
% NEW PARAMETERS
%%%%%%%%%%%%%%%%%
           EPSILON           (long_name='Elasticity of substitution among labour varieties')
           LAMBDA            (long_name='Relative weight on output gap in loss function')
%%%%%%%%%%%%%%%%%
;

// Parameter values 

BETA=0.995;
ZED=0.33;         % Switch to zero to have the standard 3-equation NK.
SIGMA=1;
B_FIss=0.70;
B_CBss=0.30;
GAMMA=0.086;
ZETA=2;
PHI_R=0.80;
PHI_PI=1.50;
PHI_X=0;


// declare relevant shocks

RHO_THETA=0.8;
RHO_RF=0.8;

SIGM_RF=0.01;
SIGM_THETA=0.01;

%%%%%%%%%%%%%%%%%  
% NEW PARAMETERS
%%%%%%%%%%%%%%%%%
EPSILON=11;                  % Desired mark-up 10%
% Microfounded relative weight on output gap in the loss function, see Woodford (2003). 
% Can use a higher value, if one wishes. See Debortoli et al. (2018) for a thorugh discussion.
LAMBDA=(ZETA*GAMMA)/EPSILON; 
%%%%%%%%%%%%%%%%%

model(linear);

// Model-local variables and composite parameters

#CHI=1;
#S_F=(SIGMA*(RHO_RF-1)*(1+CHI))/(CHI*(1-ZED));

[name='IS curve']
x = x(+1)-((1-ZED)/SIGMA)*(r-pinf(+1)-a_rf)-ZED*(B_FIss*(a_theta(+1)-a_theta)+B_CBss*(qe(+1)-qe));

[name='New Keynesian Phillips Curve']
pinf = GAMMA*ZETA*x-((ZED*GAMMA*SIGMA)/(1-ZED))*(B_FIss*a_theta+B_CBss*qe)+BETA*pinf(+1);


//************************* Shock processes *******************************

  [name='Shock process natural rate of interest']
a_rf=RHO_RF*a_rf(-1)+S_F*eps_rf;

  [name='Shock process credit conditions']
a_theta=RHO_THETA*a_theta(-1)+eps_theta;

end;

shocks;
  var eps_theta; stderr SIGM_THETA*100;
  var eps_rf; stderr SIGM_RF*100;
end;

planner_objective 1/2*(pinf^2+LAMBDA*x^2);
ramsey_policy(instruments=(r,qe),irf=20,planner_discount=0.99) r qe x pinf;