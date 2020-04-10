################################################
# This program was written by Camilo Marchesini.
################################################

# This R script shows how to implement a simple comparison of model for univariate forecast evaluation, based on root mean squared error (RMSE), 
# mean absolute error (MAE), as well as the bias.

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

######################
# Library 
library(readxl)
library(xtable)
library(forecast)
library(tidyverse)
library(kableExtra)
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

# EXAMPLE: quarterly change in GDP, with two horizon-ahead forecasts.
# The evaluation proceeds as follows:
# Let 2012Q1-2015Q2 be the evaluation part of the sample. 
# Estimate the models on data up to and including 2011Q4 and make predictions for 2012Q1 and 2012Q2. Add the data point 2012Q1, 
# re-estimate the models and make predictions for 2012Q2 and 2012Q3. 
# Continue until you reach the end of the sample.


# Displays the series, the acf, and the pacf altogether. Inspect the conditional
# and unconditional second moments.
ggtsdisplay(series, 
            main= "Seasonally-adjusted change in GDP, quarterly data (expenditure approach)",
            xlab="Time",
            ylab="Change in GDP",
            nsim=200) # 200 bootstrap samples to estimate
# the confidence intervals.

trimsample <- window(series,end=c(2011,4)) # In-sample-forecasting (training)
# Define in the function below
h <- 2  # e.g. 2                               
k <- (length(window(series, start=c(2011, 4), end=c(2015, 2)))) - h + 1 # rolling out-of-sample window

# Create a function for forecast evaluation. I apply it to all candidate models.
# I have defined the training sample, the horizons, and the window both globally 
# and inside the function, because I need them further down.

forec <- function(arima_order,h,series,start_year,start_quarter,end_year,end_quarter){
  # The function, by definition, is written in general terms.
  # In this case you can set h <- 2, start_year = 2011, start_quarter = 4, end_year= 2015, end_quarter=2.

  # -arima_order: order of arima model
  # -h: maximum forecast horizon
  # -series: series
  # remaining arguments: time windows
  
  trimsample <- window(series, end=c(start_year,start_quarter)) # In-sample-forecasting (training)
# h <- 2
  k <- (length(window(series, start=c(start_year, start_quarter), end=c(end_year,end_quarter)))) - h + 1 # rolling out-of-sample window
  
  fcmat <- matrix(0, nrow=k, ncol=h) # For every period t, my forecasts are filled in the fcmat matrix by row.
  # The matrix accomodates one-step forecasts in the first
  # column and h-step forecasts in the h-th column
  for(t in 1:k)
  {  
    fcwindow <- window(series, end=c(start_year,start_quarter) + (t-1)/4)  # out-of-sample-forecasting (evaluation)
    loopmodel <- Arima(fcwindow, order=arima_order)                        # Fit Arima model to the time series
    fcmat[t,] <- forecast(loopmodel, h=h)$mean                             # Extract point estimate
                                                                           # and store them
  }
  return(fcmat)
}

# Pre-allocating array for storage of 6 k*h matrices, where 6 is the number of models
fcmat <- array(dim=c(k,h,6))

################
# ARMA(1,1)
#################
ordergdp1 <- arimaorder(Arima(trimsample, order=c(1,0,1)))  # Store order: ARMA(1,1)
fcmat[,,1] <- forec(ordergdp1)
#############
# ARMA(1,2)
#################
ordergdp2 <- arimaorder(Arima(trimsample, order=c(1,0,2))) # Store order: ARMA(1,2)
fcmat[,,2] <- forec(ordergdp2)
#################
# ARMA(2,1)   
#################
ordergdp3 <- arimaorder(Arima(trimsample, order=c(2,0,1))) # Store order: ARMA(2,1)
fcmat[,,3] <- forec(ordergdp3)
#############
# ARMA(2,2)
#################
ordergdp4 <- arimaorder(Arima(trimsample, order=c(2,0,2))) # Store order: ARMA(2,2)
fcmat[,,4] <-forec(ordergdp4)
#############
# ARMA (4,3)  
# based on visual inspection of the conditional and conditional second moments
#################
ordergdp5 <- arimaorder(Arima(trimsample, order=c(4,0,3))) # Store order: ARMA(4,3)
fcmat[,,5] <- forec(ordergdp5)
#############
# "BEST MODEL ACCORDING TO FORECAST PACKAGE" 
#################
orderbest <- arimaorder(auto.arima(trimsample, max.p = 4, max.q = 4, seasonal = F)) 
print(orderbest) # Print order on console
fcmat[,,6] <- forec(orderbest)

#########################
# MEASURES 
##########################
 
# realizations for one horizon ahead
A <- matrix(window(series,start=c(2011,4), end=c(2015,1)), ncol=1, byrow=F) 
# realizations for two horizons ahead
B <- matrix(window(series,start=c(2011,4), end=c(2014,4)), ncol=1, byrow=F)
# realizations for three horizons ahead ...
# .
# .
# .

# pre-allocating matrices 
comparison1 <- matrix(NA, 6, 3)
comparison2 <- matrix(NA, 6, 3)
# Names
c("RMSE","MAE","BIAS") -> colnames(comparison1) -> colnames(comparison2)
c("ARMA(1,1)", "ARMA(1,2)",
  "ARMA(2,1)","ARMA(2,2)",
  "ARMA(4,3)","ARMA(0,3)") -> row.names(comparison2) -> row.names(comparison1) 

# Compute the three measures (and remove missing values)
for (i in 1:nrow(comparison1)) {
  e1 <- A - fcmat[,1,i]                            # forecast error, one step forecast
  comparison1[i,1] <- sqrt(mean(e1^2, na.rm=TRUE)) # root mean square error
  comparison1[i,2] <- mean(abs(e1)) # mean absolute deviation
  comparison1[i,3] <- mean(A-fcmat[,1,i])  # bias
  e2 <- B - fcmat[1:nrow(B),2,i]                   # forecast error, two step forecast
  comparison2[i,1] <- sqrt(mean(e2^2, na.rm=TRUE))
  comparison2[i,2] <- mean(abs(e2))
  comparison2[i,3] <- mean(B-fcmat[1:nrow(B),2,i])
}

comparison <- rbind(comparison1,comparison2)
# Finally, export the results to a latex table
kable(comparison, digits = 5, format = "latex", caption = "Forecast evaluation",
      align = "l",
      booktabs=T) %>%
  kable_styling(latex_options = "striped") %>%
  group_rows("Panel A: One-Step Forecasts", 1, 6, label_row_css = "background-color: #666; color: #fff;") %>%
  group_rows("Panel B: Two-Step Forecasts",7, 12, label_row_css = "background-color: #666; color: #fff;")

# End.