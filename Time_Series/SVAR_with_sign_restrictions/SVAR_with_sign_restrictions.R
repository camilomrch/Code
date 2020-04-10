#########################################################
# This implementation was written by Camilo Marchesini
########################################################

# This file uses the dataset by Stock and Watson (2001) to illustrate the workings of a SVAR where structural shocks 
# are identified via sign restrictions.


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


# SVAR with sign restrictions
# using package VARsignR
# Stock and Watson data.

# This package depends on other three packages 
# install.packages("minqa")  # implement the UOBYQA algorithm to minimise Uhlig's penalty function
# install.packages("HI")     # Draws to create the orthogonal impulse vector alpha.
# install.packages("mvnfast")# Draws for the coefficient of the model from the multivariate normal.
# Install VARsignR
# install.packages("VARsignR")

######################
# Library
library(VARsignR) 
library(tidyverse)
######################

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

# Import data
stockwatson <- read.delim("sw2001.txt", header=TRUE)
swdata <- ts(stockwatson[ ,c(2:4)], start = c(1960,1), frequency = 4)

##############################
# Specify sign restrictions
#############################

# In vector -constr the first element is the sign restriction imposed on the 
# orthogonalised impulse response functions of the variable whose shock I am looking to identify.

# Since the variables appear in the following order: Inflation, Unemployment, and Fed Funds, +3 says that 
# a contractionary monetary policy shock makes the Fed Funds rate (weakly) higher for at least some quarters after the shock.
# -1 says that I impose a (weakly) negative sign restriction on the orthogonalised response of inflation to the MP shock, based on the prediction from economic theory
# that the shock will push inflation down for at least some quarters after the shock.
# I impose no sign restriction on the orthogonalised response of the unemployment rate (variable 2 in the dataset), but in principle I could, of course.
constr <- c(+3,-1)
# KMIN and KMAX define the first and the last periods in the repsonses to which restrictions are applied.
# First, I estimate a BVAR model with a flat normal inverted-Wishart prior 
model_uhlig <- uhlig.reject(Y=swdata, nlags=4, draws=200, subdraws=100, nkeep=1000, KMIN=1,
                       KMAX=6, constrained=constr, constant=FALSE, steps=60)
# Alternatively, one can use Rubio-Ramirez et al. (2010) rejection method.
model_rwz<- rwz.reject(Y=swdata, nlags=12, draws=200, subdraws=200, nkeep=1000,
                     KMIN=1, KMAX=6, constrained=constr, constant=FALSE, steps=60) 
# All commands below are valid also for model_rwz. 

# The MCMC sampler stops either the desired number of draws that satisfy all sign restrictions at the same time have been drawn 
# or when the maximum number of draws has been reached.


# BDraws: posterior draws of the coefficients of the model.
# SDraws: posterior draws of the variance-covariance matrix.
# IRFS: posterior draws for the impulse response functions.
# SHOCKS: posterior draes of the shock. Dimension of the array: T-nlags.

# Check the number of rejected draws. If you see many rejected draws, the model is poorly specified.
############################
# Bayesian VAR IRFs
############################
irfs <- model_uhlig$IRFS 
labels <- c("Inflation","Unemployment","Federal Funds Rate")
# Plot the median of the impulse response draws and plot them, accompanied by confidence bands.
par(mar=c(2,2,2,2))  # Regulate margins
par(mfrow=c(1,1))    # Reset environment
irfplot(irfdraws=irfs, type="median", labels=labels, save=FALSE, bands=c(0.16, 0.84),
        grid=TRUE, bw=FALSE)
###############################################
# Plot forecast error variance decompositions
##############################################
# Extract FEVD
fevd <- model_uhlig$FEVDS
# Plot.
fevdplot(fevd, label=labels, save=FALSE, bands=c(0.16, 0.84), grid=TRUE,
         bw=FALSE, table=FALSE, periods=NULL)
# Show FEVD in table at different horizons.
fevd.table <- fevdplot(fevd, table=TRUE, label=labels, periods=c(1,10,20,30,40,50,60))
# Print to screen.
print(fevd.table)


# Extract the identified time series of the structural shock to the interest rate. 
#  I use the quantile function to generate confidence intervals for these shocks given the desired number of draws in nkeep. 
# Confidence interevals stored as a time series object, where we lost the first 12 observations as a part of the estimation procedure.
shock <- model_uhlig$SHOCKS
# Plot structural shock series.
structural_shock <- ts(t(apply(shock,2,quantile,probs=c(0.5, 0.16, 0.84))), frequency=12, start=c(1966,1))
plot(structural_shock [,1], type="l", col="blue", ylab="Interest rate shock", ylim=c(min(structural_shock), max(structural_shock )))
abline(h=0, col="black")
# Add confidence bands.
lines(structural_shock [,2], col="red")
lines(structural_shock [,3], col="red")

##########################################
# Uhlig's (2005) penalty function method
##########################################

# Now I re-estimate the model using Uhlig's (2005) penalty function method.

# Notice that in order to get the same number of desiered accepted draws, it is needed that 
# draws= be equal to draw*subdraws in uhlig.function, since in these case there are no subdraws from each 
# posterior draw. Indeed, subdraws=1000  is a bit of a misnomer, as in this case it refers to 
# number of iterations of the UOBYQA algorithm that is used to minimise the penalty function, and not to 
# subdraws for each posterior draw.

model_penalty <- uhlig.penalty(Y=swdata, nlags=12, draws=2000, subdraws=1000,
                        nkeep=1000, KMIN=1, KMAX=6, constrained=constr,
                        constant=FALSE, steps=60, penalty=100, crit=0.001)
# Plot IRfs.
irfs_model_penalty <- model_penalty$IRFS
irfplot(irfdraws=irfs_model_penalty, type="median", labels=labels, save=FALSE, bands=c(0.16, 0.84),
        grid=TRUE, bw=FALSE)

###########################################
# Fry-Pagan (2011) Median-Target Method
############################################
# To see how well the shocks are identified, i.e. how well the model is specified, 
# I compare the IRFs by uhlig.rejection to those by the FP method.

# If the IRFs produced by Uhlig's (2005) rejection method are far away from those produced by FP method, it would be evidence of 
# model misspecification.
fp.target(Y=swdata, irfdraws=irfs,  nlags=12,  constant=F, labels=labels, target=TRUE,
          type="median", bands=c(0.16, 0.84), save=FALSE,  grid=TRUE, bw=FALSE,
          legend=TRUE, maxit=1000)

# End.
