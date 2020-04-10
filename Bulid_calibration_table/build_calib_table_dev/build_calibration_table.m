% This file illustrates in a simple example how to build a calibration
% table for a DSGE model in LaTeX. 
% You can easily adapt it to the parameter values and steady state-targets 
% of your own model.
% Ascertain that file savepar.m is located in your current working
% directory.
% Required LaTex packages:
% \usepackage{booktabs}
% \usepackage{threeparttable}

% MATLAB_R2019a and subsequent distributions. Backward compatibility untested.

% This implementation was written by Camilo Marchesini.


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






% run savepar   % uncomment this line once you have compiled savepar.m file 
% with the parameter and steady-state values of your liking to save them.

% Load structures -par and -targ from your filewithyourparameters.mat
load 'filewithyourparameters.mat' par targ;

% Open new .tex file.
fidTeX=fopen('Calibration_table.tex','w');

% Start writing.
% Intro.
fprintf(fidTeX,'\n');
fprintf(fidTeX,'\\begin{table}[h] \n');
fprintf(fidTeX,'\\caption{Calibrated Parameters} \n');
fprintf(fidTeX,'\\label{table:calibration_table} \n');
fprintf(fidTeX,'\\centering\n');
fprintf(fidTeX,'\\begin{threeparttable} \n');
%fprintf(fidTeX,'\\small \n'); 
fprintf(fidTeX,'\\begin{tabular}{ccll} \n');
fprintf(fidTeX,'\\toprule \n'); 
% Parameter values.
fprintf(fidTeX,'\\multicolumn{1}{c}{Symbol}&\\multicolumn{1}{c}{Value}&\\multicolumn{1}{c}{Description}&\\multicolumn{1}{c}{Reference}\\\\ \\cmidrule(r){4-4}  \n');
fprintf(fidTeX,'\\multicolumn{4}{l}{Households}\\\\ \n');
fprintf(fidTeX,'$\\beta_H$ & %1.3f & Discount rate & \\citet{someone2015}\\\\ \n', par.BETA);
fprintf(fidTeX,'$\\tau_H$ & %1.3f & Relative weight of lesiure in utility & \\citet{someoneelse2010}\\\\ \n', par.TAU);
fprintf(fidTeX,'\\multicolumn{4}{l}{Bankers}\\\\ \n');
fprintf(fidTeX,'$\\rho_D$ & %1.3f & Inertia in collateral constraint & \\citet{somebody2011}\\\\ \n', par.RHOD);
fprintf(fidTeX,'\\multicolumn{4}{l}{Retailers}\\\\ \n');
fprintf(fidTeX,'$\\epsilon$ & %1.3f & Elasticity of substitution & \\citet{somebody2011}\\\\ \n', par.EPSILONP);
fprintf(fidTeX,'$\\theta$ & %1.3f & Probability of keeping price unchanged & \\citet{somebody2011}\\\\  \n', par.THETAP);
fprintf(fidTeX,'\\multicolumn{4}{l}{Monetary Authority} & \\citet{somebody2011}\\\\ \n');
fprintf(fidTeX,'$\\phi_R$ & %1.3f & Interest rate smoothing coefficient & Posterior mode in \\citet{someone2017}\\\\ \n', par.PHIR);
fprintf(fidTeX,'$\\phi_{\\pi}$ & %1.3f &  Feedback coefficient on inflation & Posterior mode in \\citet{someone2016}\\\\ \n', par.PHIPI);
fprintf(fidTeX,'\\multicolumn{4}{l}{Persistence of shock processes}\\\\  \n');
fprintf(fidTeX,'$\\rho_z$ & %1.3f & Technology & Posterior mode in \\citet{someone2017}\\\\ \n', par.RHO_Z);
fprintf(fidTeX,'\\multicolumn{4}{l}{Standard deviation of shock processes}\\\\  \n');
fprintf(fidTeX,'$\\sigma_z$ & %1.3f & Technology & Posterior mode in \\citet{someone2017}\\\\ \n', par.SIG_Z);
fprintf(fidTeX,'\\midrule \\midrule \n');
% Steady-state targets.
fprintf(fidTeX,'\\multicolumn{4}{l}{Main steady-state targets}\\\\ \\midrule \n');
fprintf(fidTeX,'X & %1.3f & Desired price mark-up ($\\%$) &\\\\ \n', targ.X);
fprintf(fidTeX,'$\\pi$ & %1.3f & Gross inflation rate ($\\%$) &\\\\ \n', targ.pi_ss);
% Outro.
fprintf(fidTeX,'\\end{tabular} \n');
fprintf(fidTeX,'\\begin{tablenotes} \n');
fprintf(fidTeX,'\\footnotesize \n'); 
fprintf(fidTeX,'\\item \\textit{Notes}: Here you can write a note to the table.'); 
fprintf(fidTeX,'\\end{tablenotes} \n');
fprintf(fidTeX,'\\end{threeparttable} \n');
fprintf(fidTeX,'\\end{table} \n');
% End writing.

% Close .tex file.
fclose(fidTeX);

% End.