/* This file provides a short illustration of how to produce summary statistics for 
a sample of countries in STATA and export them to a LaTex table. */


/* This implementation was written by Camilo Marchesini.

     Copyright (C) 2019  Camilo Marchesini
 
     This program is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation, either version 3 of the License, or
     (at your option) any later version.
 
     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
     along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */


version 15.0 /* Specify version for compatibility */
clear 
capture log close
set more off
cd "yourworkingdirectory"
log using "yourfilename", replace
use "yourdataset.dta", clear
*************************
*Data review
codebook, compact
ds, has(type string)
distinct /* ssc install */
misstable sum
*************************
*************************************************************************************************************
* Real GDP per capita (complete, 1995 - 2017) (PPP- adjusted) for a sample of countries 
* Source: World Bank
*************************************************************************************************************
* Select variable.
keep year countrycode realgdp_pc 
* Select sample.
keep if year<2018
keep if year>1994 
* generate log real GDP per capita.
g log_realgdp_pc=ln(realgdp_pc)
* Create group ID.
egen id=group(countrycode)
* Set as panel data.
xtset id  year

* Create summary statistics for each country over the selected sample period.
estpost tabstat log_realgdp_pc, ///
by(countrycode) statistics(mean sd min max) column(statistics)

* Export results to LaTeX, 

* note:
* Include 
/*    
\usepackage{booktabs} 
\newcommand{\specialcell}[2][c]{%                % To split long variable name
\begin{tabular}[#1]{@{}c@{}}#2\end{tabular}} 
*/
* in preamble. 


esttab using "summarystat.tex", varwidth(20) booktabs  ///
cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") ///
mlabels("\multicolumn{4}{c}{\specialcell{Real GDP per capita}}") collabels("Mean" "SD"  "Min." "Max.") ///
varlabels(log_realgdp_pc "") ///
nostar nomtitle nonumber nonote noobs replace

* Close log.
log close

* End.
