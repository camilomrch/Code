MATLAB_R2019a and subsequent distributions. Backward compatibility untested.

-File eff-frontier.m is a function that computes and plots the efficient frontier of monetary policy. For each value in the grid of policy parameter, it plots all variance tuples implied by the combinations of that parameter with all parameter values in the grid of the other parameter, and generates a curve. The function then takes the envelope of all curves, the efficient frontier.
the interpolation approach adopted here affords desirable smoothness in the frontier. In any way does it distort the results, but the vraisemblance will be higher, the thinner the parameter grid chosen.

NOTE: Points on the frontier are equally desirable, which need not be the case given a particular set of preferences of the monetary authority. 
For an optimisation approach to the efficient approach, refer to:
Levin, Andrew, Volker Wieland and John C. Williams. 
"The Performance Of Forecast-Based Monetary Policy Rules Under Model Uncertainty," 
 American Economic Review, 2003, v93(3,Jun), 622-645. 
Available at
 https://www.nber.org/papers/w6570.

-File eff-frontier_example.m provides a minimal working example to illustrate the use of the function.

Camilo Marchesini (camilo.marchesini@gmail.com)

June 2019

