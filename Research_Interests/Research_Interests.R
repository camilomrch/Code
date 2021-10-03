########################################################
# This implementation was written by Camilo Marchesini
#######################################################

# This R script contains a function that describes my research interests and my approach to macroeconomic issues
# with the simplicity afforded by computer code:
# It takes a set of fields in macroeconomics as its argument: each field contains macroeconomic issues;
# It problematizes the fields of interests of mine, which are full of macroeconomic issues;
# Applies lots of dedication to solve the macroeconomic issues contained in those fields;
# Returns a vector of solved macroeconomic problems.

#     Copyright (C) 2019  Camilo Marchesini
# 
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.


####################
# Opening routine
####################
# Set working directory.
setwd("~/Desktop/yourdirectory")
# Or go to your preferred wd and type:
# wd <- getwd()
# setwd(wd)
# Clear workspace.
rm(list=ls())
# Clear screen.
cat("\014")  
###################

Research_Interests < - function(fields_in_macroeconomics){
  
  Research_Interests < -c(
    "Macroeconomics",
    "International Finance",
    "Numerical Methods"
  )
  
  macroproblems <- fields_in_macroeconomics  %>%
    select(one_of(Research_Interests))
  
  k <-nrow(macroproblems)
  solve_macroproblems <- matrix(NA,k,1)
  
  for (iter in 1:k){
    solve_macroproblems[iter] <- apply(macroproblems,1,lots_of_dedication)
  }
  
  return(solve_macroproblems)
  
}

# End.
