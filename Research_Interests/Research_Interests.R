########################################################
# This implementation was written by Camilo Marchesini
#######################################################

# This R script contains a function that describes my research interests and my approach to macroeconomic issues
# with the simplicity afforded by computer code:
# It takes a set of fields in macroeconomics as its argument: each field contains macroeconomic issues;
# It problematizes the fields of interests of mine, which are full of macroeconomic issues;
# Applies lots of dedication to solve the macroeconomic issues contained in those fields;
# Returns a vector of solved macroeconomic problems.


# MIT License
# 
# Copyright (c) 2019 Camilo Marchesini
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.



Research_Interests < - function(fields_in_macroeconomics){
  
  Research_Interests < -c(
    "Macroeconometrics",
    "Monetary Economics",
    "International Finance",
    "Computational Macroeconomics"
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