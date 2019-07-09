/* This file provides a short illustration of how to produce summary statistics for 
a sample of countries in STATA and export them to a LaTex table. */


/* This implementation was written by Camilo Marchesini.

 MIT License
 
 Copyright (c) 2019 Camilo Marchesini
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE. 
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
