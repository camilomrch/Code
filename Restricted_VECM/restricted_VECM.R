################################################
# This program was written by Camilo Marchesini.
################################################

# This file offers an example on how to test for cointegration using a restricted VECM approach. 
# Are the Swedish STIBOR and the 10-year Swedish government bonds cointegrated series? 
# With the restricted VECM approach I use Johansen's procedure to test whether the spread between
# the two is stationary by assuming cointegration by imposing rescritions on the coefficient of the VECM representation.

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


# My opening routine
########
rm(list=ls()) # clean global environment
setwd("yourworkingdirectory")
########
# Library
library(forecast)
library(ggplot2)
library(tseries)
library(urca)
library(graphics)
library(MASS)
library(strucchange)
library(sandwich)
library(lmtest)
library(vars)
library(tsDyn)
library(fUnitRoots)
############
# Data: September 1987 to September 2018
##########
# Set-up
cointegrationdata <- read.delim2("cointegration.txt")
head(cointegrationdata) # Quick look at the data
swe <- ts(cointegrationdata[,c(2,3)],
          start = c(1987,10), end= c(2018,8), frequency = 12)
stibor <- swe[,1]
gvb    <- swe[,2]

# Plot the series
leg.text <- c("Stibor", "Government bonds")
ts.plot(swe,
        main="Stibor and Government bonds, monthly data",
        ylab="Rate",
        col= c("blue","red"),
        lty = 1 , lwd = 3)
legend("topright", leg.text, col= c("blue","red"), 
       lty = 1, lwd =3, box.lty=0, box.lwd = 0, cex = 1) # no box around
axis(side = 1, at=c(1987,2018),  padj=1)          # Adjusting the x-axis


###################################################
# Select optimal lag length in VAR
#################################################
lag.max <- c(12,8,6) # Testing in decreasing order
tmp <- matrix(NA, 3, 4)
for (i in 1:3 ){
  tmp[i,] <- VARselect(swe, lag.max = lag.max[i], type = "const")$selection
}
colnames(tmp) <- c("AIC","HQ","SC","FPE")
row.names(tmp) <- c("12","8","6")

kable(tmp, digits = 1, format = "latex", 
      caption = "Lag Order Choices for Different Information Criteria",
      align = "l",
      booktabs=T)
# I decide to choose lag length in accordance to the AIC. I stick to this choice throughout the rest of 
# the code 

###################################
# Testing univariate unit roots
#################################
# To check for cointegration, first I check whether 
# both series contain a stochastic trend.

# AdfTests performs the tests using no constant, constant or constant and trend
# which correspond to Case 1 (Pure RW), Case 2 (Drift) and Case 4 (Drift+trend) in Hamilton 1994 (pp.475-543)


# Test Stibor
a <- cbind(adfTest(stibor, lags = 4, type = "nc")@test$statistic, 
           adfTest(stibor, lags = 4, type = "nc")@test$p.value)  
b <- cbind(adfTest(stibor, lags = 4, type = "c")@test$statistic,
           adfTest(stibor, lags = 4, type = "c")@test$p.value)
c <- cbind(adfTest(stibor, lags = 4, type = "ct")@test$statistic,
           adfTest(stibor, lags = 4, type = "ct")@test$p.value)

unitr.stib <- rbind(a,b,c)
row.names(unitr.stib) <- c("Pure RW","Drift","Drift+trend")
kable(unitr.stib, digits = 2, format = "latex",
      caption = "Univariate Unit Root Tests, Stibor",
      align = "l",
      booktabs=T)

# Exactly the same for government bonds
d <- cbind(adfTest(gvb, lags = 4, type = "nc")@test$statistic, 
           adfTest(gvb, lags = 4, type = "nc")@test$p.value)  
e <- cbind(adfTest(gvb, lags = 4, type = "c")@test$statistic,
           adfTest(gvb, lags = 4, type = "c")@test$p.value)
f <- cbind(adfTest(gvb, lags = 4, type = "ct")@test$statistic,
           adfTest(gvb, lags = 4, type = "ct")@test$p.value)
unitr.gvb <- rbind(d,e,f)
row.names(unitr.gvb) <- row.names(unitr.stib) 
kable(unitr.gvb, digits = 2, format = "latex",
      caption = "Univariate Unit Root Tests, Government Bonds",
      align = "l",
      booktabs=T)
###################################
# Estimating the cointegrating rank
###################################
##################
# Johansen
#################
# I specify the (unrestricted) VECM in its long-run representation
# and use both the trace and the maximum eigenvalue test.
# I also check whether anything changes when I change the nature of the deterministic trend
# K=4 is the lag length
jotest.tr1 <-ca.jo(swe, type="trace", K=4, ecdet="const", spec="longrun")
test1 <- cbind(jotest.tr1@teststat,jotest.tr1@cval)
jotest.tr2 <-ca.jo(swe, type="trace", K=4, ecdet="trend", spec="longrun")
test2 <- cbind(jotest.tr2@teststat,jotest.tr2@cval)
jotest.eigen1 <-ca.jo(swe, type="eigen", K=4, ecdet="const", spec="longrun")
test3 <- cbind(jotest.eigen1@teststat,jotest.eigen1@cval)
jotest.eigen2 <-ca.jo(swe, type="eigen", K=4, ecdet="trend", spec="longrun")
test4 <- cbind(jotest.eigen2@teststat,jotest.eigen2@cval)
jo.tests <- rbind(test1,test2,test3,test4)
row.names(jo.tests) <- c("r less or equal to 1","r equal to 0",
                         "r less or equal to 1","r equal to 0",
                         "r less or equal to 1","r equal to 0",
                         "r less or equal to 1","r equal to 0")
kable(jo.tests, digits = 2, format = "latex",
      caption = "Estimation of the Cointegrating Rank of the VAR using Johansen procedure",
      align = "l",
      col.names = c("10pct","5pct","1pct"),
      booktabs=T) %>%
  add_header_above(c("Null hypothesis", "t-statistic" = 1, "Critical values" = 3))%>% 
  # critical values from Osterwald-Lenum, 1992
  group_rows("Panel A: Johansen trace test, with drift", 1, 2) %>%
  group_rows("Panel B: Johansen trace test, with trend",3, 4) %>%
  group_rows("Panel C: Johansen max.eigenvalue test, with drift",5, 6) %>%
  group_rows("Panel D: Johansen max.eigenvalue test, with trend", 7, 8) 

############################
# Restricted VECM
############################
# I conduct inference on the coefficients of a restricted VECM; H0: cointegration
# Fit the VECM
jotest.trVECM1 <- ca.jo(swe, type="trace", K=4, ecdet="none", spec="longrun")
# Restricting matrix (linear restrictions on beta)
B1 <- matrix(c(1,-1), nrow = 2) 
# Test using likelihood ratio
testing1 <- blrtest(z = jotest.trVECM1 , B1, r=1)
jotest.trVECM2 <-ca.jo(swe, type="eigen", K=4, ecdet="none", spec="longrun")
testing2 <- blrtest(z = jotest.trVECM2 , B1, r=1)
# Need to take transpose of @pval to show degrees of freedom
bigtest <- rbind(cbind(testing1@teststat,t(testing1@pval)),
                 cbind(testing2@teststat,t(testing2@pval)))
kable(bigtest, digits = 2, format = "latex",
      caption = "Likelihood-ratio test on restricted VECM",
      align = "lcc",
      col.names = c("t-statistic","p-value","Degrees of freedom"),
      booktabs=T) %>%
  group_rows("Trace test", 1, 1) %>%
  group_rows("Max. Eigenvalue test",2, 2) 

# End.