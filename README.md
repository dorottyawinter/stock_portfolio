# Stock Portfolio Shiny App

### Table of Contents

1. [Dependencies](#dependencies)
2. [Project Overview](#overview)
3. [Project Components](#components)
4. [Shiny App](#app)

## Dependencies <a name="dependencies"></a>
Requires R 4.0.1 and the following libraries:
* tidyverse (>= 1.3.0)
* tidyquant (>= 1.0.1)
* RSQLite (>= 2.2.0)
* DBI (>= 1.1.0)
* dbplyr (>= 1.4.4)
* extrafont (>= 0.17)
* wesanderson (>= 0.3.6)
* c3 (>= 0.3.0)
* highcharter (>= 0.7.0)

## Project Overview <a name="overview"></a>
This is a Shiny app where you can give stock symbols and asset weights as input. The app calculates the monthly returns and builds the stock portfolio for you. Besides that, the app also displays visualizations of the data.

The app uses a custom ETL pipeline and visualisation modules.
I provided documentation for all of the modules. For the documentation I used roxygen2 style docstring comments, so when something is confusing feel free to check it with:
```
library(docstring)
?confusing_function
# The short summary of the confusing function will appear in the help panel of RStudio with information about function I/O-s, examples, etc.
```

## Project Components <a name="components"></a>
There are three components of the project.

1. ETL modules

   In `create_stock_portfolio_db.R` is the data processing pipeline that:
   * Sources the modules from `stock_portfolio.R`.
   * Get stock prices for all the given stock symbols and time range. 
   * Calculates monthly returns. 
   * Aggregates a group of monthly returns by stocks – optionally weighted by the weights parameter – into portfolio returns. 
   * Saves monthly returns and portfolio returns to SQLite DB.
  
2. Data visualisation modules

   In `ggplot_modules.R` are the static visual modules that:
   * Creates a histogram, where you can see the distribution of the data per asset.
   * Creates a time series plot, where you can see the volatility of the data per asset.
   * Creates a barplot, where you can see the annualized sharpe ratios per asset.

    In the folder visual_experiments are some experimentations with interactive data visualization libraries such as:
    * [c3](https://CRAN.R-project.org/package=c3), which is the R version of the D3-based reusable chart library [C3.js](https://c3js.org/).
    * [highcharter](https://CRAN.R-project.org/package=highcharter), which is a wrapper for the JavaScript based [Highcharts](https://www.highcharts.com/).

3. Shiny App

   In progress.

## Shiny app <a name="app"></a>
In progress.