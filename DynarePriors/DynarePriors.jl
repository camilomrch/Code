#=
For each distribution currently allowed in Dynare (4.5.7), this scirpt
 illustrates the family of priors you are elicitig so as to discipline the likelihood.
 So far, I have not implemented to show generalised distributions automatically.
 Also, I have not yet automated the mapping from moments to distribution parameters, yet also that is on the to-do list.
 Feel free to file a pull request, if interested!


 This implementation was written by Camilo Marchesini.

 Julia v1.0.1 Backward and forward compatibility untested.

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
=#

## Load package manager.
using Pkg
Pkg.update()
####################################
# Load libraries.
import Pkg; Pkg.add("Distributions")
import Pkg; Pkg.add("Plots")
import Pkg; Pkg.add("StatsPlots")
import Pkg; Pkg.add("Plotly")
import Pkg; Pkg.add("PGFPlots")
# import Pkg; Pkg.add("LaTexStrings")
#####################################
using Distributions
# Choose library backend
using Plots;  plotly() #pgfplots()
using StatsPlots
# using LaTexStrings

# https://github.com/JuliaStats/Distributions.jl/tree/master/src/univariate/continuous
#################################################

# EXAMPLES

#=
Normal Distribution
Normal(μ, σ)  Normal distribution with mean μ and variance σ^2
@distr_support Normal -Inf Inf
=#

norm=Dict("θ"=>Normal(5,1),"η"=>Normal(5,2.5),
"γ"=>Normal(5,4));

#=
Gamma Distribution
Gamma(α, θ)  # Gamma distribution with shape α and scale θ
@distr_support Gamma 0.0 Inf
=#

gam=Dict("θ"=>Gamma(1,2),"η"=>Gamma(2,2),"γ"=>Gamma(3,2));

#=
Beta Distribution
Beta(α, β)   # Beta distribution with shape parameters α and β
@distr_support Beta 0.0 1.0
=#

bet=Dict("θ"=>Beta(0.8,0.8),"η"=>Beta(2,2),"γ"=>Beta(10,3),"ν"=>Beta(3,10));

#=
Inverse Gamma Distribution
InverseGamma(α, θ)
Inverse Gamma distribution with shape α and scale θ
@distr_support InverseGamma 0.0 Inf
=#

inv_gam=Dict("θ"=>InverseGamma(10,1),"η"=>InverseGamma(10,2),"γ"=>InverseGamma(10,3));

#=
Uniform Distribution
Uniform(a, b)
Uniform distribution with location a and scale (a-b), where a and b are the lower and upper bound, respectively.
@distr_support Uniform a b
=#
unif=Dict("θ"=>Uniform(1,8),"η"=>Uniform(2,6),"γ"=>Uniform(5.5,7));


function DynarePriors(dis)
  #=
  dis: dictionary of parameter values
  assigned to their respective distributions.
  e.g.   inv_gam=Dict("θ"=>InverseGamma(10,1),"η"=>InverseGamma(10,2),"γ"=>InverseGamma(10,3));
  =#


  # Set linewidth option.
  linw=3;
  # Set fill option.
  set_fillrange=0;
  set_fillalpha=0.2;
  # Set colours (from http://latexcolor.com/)
  # Max 10 distributions in a single plot
  blue_de_france=RGB(0.19,0.55,0.91)
  princeton_orange=RGB(1.0,0.56,0.0)
  raspberry_pink=RGB(0.89,0.31,0.61)
  fluo_yellow=RGB(0.8,1.0,0.0)
  amethyst=RGB(0.6,0.4,0.8)
  apple_green=RGB(0.55,0.71,0.0)
  capri=RGB(0.0,0.75,1.0)
  jazzberry_jam=RGB(0.65,0.04,0.37)
  bittersweet=RGB(1.0,0.44,0.37)
  sepia=RGB(0.44,0.26,0.08)
  # Concatenate.
  colors_array=[
   blue_de_france
  ,princeton_orange
  ,raspberry_pink
  ,fluo_yellow
  ,amethyst
  ,apple_green
  ,capri
  ,jazzberry_jam
  ,bittersweet
  ,sepia]


# Get parameter names.
dis_keys=collect(keys(dis));
# Get corresponding distributions.
dis_values=collect(values(dis));

# Define distribution symbol
if typeof(dis_values[1]) <: Normal
sym="𝓝"
end
if typeof(dis_values[1]) <: Gamma
sym="𝚪"
end
if typeof(dis_values[1]) <: Beta
sym="𝚩"
end
if typeof(dis_values[1]) <: InverseGamma
sym="𝑰𝐆"
end
if typeof(dis_values[1]) <: Uniform
sym="𝐔"
end
# Number of distributions in the vector.
   ndis=length(dis_values)
# Extract parameters of the distribution.
   pr_name=(dis_keys[1])
   pr=params(dis_values[1])
# Plot theme.
   theme(:juno)
# Plot the first distribution.
    plot_d=plot(dis_values[1]
    ,linewidth = linw
    ,linecolor = colors_array[1] ,fill=(set_fillrange,set_fillalpha,colors_array[1])
    ,labels="$pr_name~$sym$pr")
# Plot the remaining distributions on top of the first.
    for kter in 2:ndis
   # Roll over parameter names and distributions.
    pr_name=(dis_keys[kter])
    pr=params(dis_values[kter])
  # Roll over distributions.
    plot!(dis_values[kter]
    ,linewidth = linw
    ,linecolor = colors_array[kter]
    ,fill=(set_fillrange,set_fillalpha,colors_array[kter])
    ,labels="$pr_name~$sym$pr"
    ,xlabel="Parameter value"
    ,ylabel="Density")
    end
# Return the plot.
return plot_d
end

# Plot.
DynarePriors(norm)
DynarePriors(gam)
DynarePriors(beta)
DynarePriors(inv_gamma)
DynarePriors(unif)
