# camilomrch.github.io
Codes and Programs by Camilo Marchesini

---
title: "EXAM in Financial Econometrics"
author: "AP-0004-XHZ"
date: "February 13-15, 2019"
output:
   rmarkdown::html_document:  
    theme: journal
    highlight: zenburn
    pdf_document:
    keep_tex: no
    toc: no
   df_print: kable
---
<style>
pre {
  white-space: pre !important;
  overflow-y: scroll !important;
  overflow-x: scroll !important;
  height: 15vh !important;
}
</style>

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE,
	message = FALSE,
	warning = FALSE,
	cache = T,
	fig.align="center")

library(FE)
library(TTR,quantmod)
library(dlm)
library(tidyverse)
library(stats)
library(forecast) 
library(knitr)
library(kableExtra)
library(gridExtra)
library(psych)
# install.packages("EnvStats")
library(EnvStats) # for Q-Q plot
library(YieldCurve)
# install.packages("sarima")
library(sarima)
library(aTSA)
library(rugarch)
# install.packages("fGarch")
library(fGarch)

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

```
# Present-Value Relations (continued)
HI!
