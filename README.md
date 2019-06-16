
# <span style="color:blue">Welcome to my GitHub repository\!</span>

### My name is <span style="color:blue">Camilo Marchesini</span>.

### In this repository you can find a selection of my original codes\! Unless otherwise stated, all codes were written exclusively by me.

## Efficient\_frontier

  - <sub>Function **eff\_frontier.m** was written by [Daniele
    Vettorel](http://vettorel.mit.edu/) and me. It computes the
    efficient frontier, also called Taylor (volatility) frontier, of
    monetary policy. It shows the trade-offs available to the central
    bank, assuming the central bank implements a Taylor rule. Flexible
    and easy-to-use, it can be applied to any monetary DSGE
    model\!</sub>
  - <sub>Illustrative example:</sub> ![Example:
    Efficient\_frontiers](example_efficient_frontier.png)
  - <sub>File **eff\_frontier\_example.m** provides a minimal working
    example to illustrate the power of **eff\_frontier.m**. The use of a
    three-mandate Taylor rule is illustrated.</sub>

## Time\_series

  - <sub>R script **plot\_TS.R** provides a powerful visualisation of
    the main financial and macroeconomic developments in the recent
    history of the United States.</sub>  

  - <sub>An example from **plot\_TS.R** (discover the other two in the
    file\!)</sub> ![Example: Financial conditions in the
    U.S.](example_figuresFED.png) <sub>**First**, if you are in the
    preliminary phase of your paper and wish to get an idea of some
    economic dynamics, you first want to plot them well\! **Second**,
    many great papers, such as [Jermann and Quadrini
    (2012)](https://www.jstor.org/stable/41408774?seq=1#metadata_info_tab_contents)
    and [Justiniano, Primiceri, and Tambalotti
    (2015)](https://econpapers.repec.org/article/redissued/14-24.htm)
    start by capturing the attention of the reader with one or more
    illustrations of the dynamics underlying their research question,
    and then move to illustrate the model with which they attempt to
    replicate those features of the data. That is why you always need
    great data visualisations at the beginning of your paper\! Check the
    code out and plot\!</sub>

  - <sub>Function **make\_monthly** in **plot\_TS.R** formats your
    dataset to deliver a beautiful graphic outcome on the x-axis when
    data is at monthly frequency.</sub>

  - <sub>Function **forec** in **forecast\_evaluation.R** gives you a
    quick tool to evaluate the forecasting performance of several
    models, at several forecasting horizons, at once\! It works great
    for a quick analysis of single time series\!</sub>
