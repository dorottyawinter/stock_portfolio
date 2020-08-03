library(tidyverse)

source('~/git/stock_portfolio/visual_modules/ggplot_modules.R')

portfolio_visualizer <- function(
  weights_df,
  raw_df,
  returns_df,
  portfolio_df
){
  #' Create portfolio visualisations.
  #'
  #' @description Creates various visualisations (pie chart, histogram, barplot, time series visualisation, etc.) about asset allocation, monthly returns, portfolio returns, annualized sharpe ratio, etc.
  #' @param weights_df (tibble) Tibble with columns 'symbol' and 'weight' containing the stock symbols with allocations in tidy format (i.e long format).
  #' @param raw_df (tibble) Tibble with columns 'symbol', 'date', and 'adjusted' containing the raw stock prices in tidy format (i.e long format).
  #' @param returns_df (tibble) Tibble with columns 'symbol', 'date', and 'monthly_returns' containing the calculated monthly returns of the assets in tidy format (i.e long format).
  #' @param portfolio_df (tibble) Tibble with columns 'symbol', 'date', and 'monthly_returns' containing the monthly returns of the built portfolio in tidy format (i.e long format).
  #' @return (list of lists) Returns the generated visualisations in a list.

  
  portfolio_all <- rbind(portfolio_df, returns_df)
  
  # pie chart of portfolio allocation
  
  portfolio_pie_params <- list(
    labs = list(
      title = 'Pie chart of asset allocation'
    )
  )
  
  portfolio_pie <- vis_pie(
    df = weights_df,
    category_col = symbol,
    value_col = weight,
    params_list = portfolio_pie_params
  )
  
  # histogram of monthly returns
  
  returns_hist_params <- list(
    labs = list(
      x = 'monthly returns',
      y = 'count',
      title = 'Histogram of monthly returns per asset\n'
    )
  )
  
  returns_hist <- vis_hist(
    df = returns_df,
    x_col = monthly_returns,
    category_col = symbol,
    params_list = returns_hist_params
  )
  
  # time series visualisation of monthly returns
  
  returns_timeseries_params <- list(
    labs = list(
      x = '',
      y = 'monthly returns',
      title = 'Time series visualisation of monthly returns per asset\n'
    ),
    scale_x_continuous = list(
      labels = scales::percent
    )
  )
  
  returns_timeseries <- vis_timeseries(
    df = returns_df,
    x_col = date,
    y_col = monthly_returns,
    category_col = symbol,
    params_list = returns_timeseries_params
  )
  
  # time series visualisation of adjusted stock prices
  
  raw_timeseries_params <- list(
    labs = list(
      x = '',
      y = 'adjusted stock price',
      title = 'Time series visualisation of adjusted stock prices per asset\n'
    ),
    scale_x_continuous = list(
      labels = scales::dollar
    )
  )
  
  raw_timeseries <- vis_timeseries(
    df = raw_df,
    x_col = date,
    y_col = adjusted,
    category_col = symbol,
    params_list = raw_timeseries_params
  )
  
  # barplot of annualized sharpe ratio
  
  returns_sharperatio_params <- list(
    labs = list(
      x = 'stock symbol',
      y = 'sharpe ratio',
      title = 'Annualized Sharpe Ratio per asset (RFR=3%)'
    )
  )
  
  returns_sharperatio <- vis_sharperatio(
    df = returns_df,
    value_col = monthly_return,
    category_col = symbol,
    params_list = returns_sharperatio_params
  )
  
  # time series visualisation of portfolio returns
  
  portfolio_timeseries_params <- list(
    labs = list(
      x = '',
      y = 'monthly portfolio returns',
      title = 'Time series visualisation of monthly portfolio returns\n'
    ),
    scale_x_continuous = list(
      labels = scales::percent
    )
  )
  
  portfolio_timeseries <- vis_timeseries(
    df = portfolio_df,
    x_col = date,
    y_col = monthly_returns,
    category_col = symbol,
    params_list = portfolio_timeseries_params
  )
  
  # barplot of annualized sharpe ratio
  
  portfolio_sharperatio_params <- list(
    labs = list(
      x = 'stock symbol',
      y = 'sharpe ratio',
      title = 'Annualized Sharpe Ratio per asset (RFR=3%)'
    )
  )
  
  portfolio_sharperatio <- vis_sharperatio(
    df = portfolio_all,
    value_col = monthly_return,
    category_col = symbol,
    params_list = portfolio_sharperatio_params
  )
  
  # output list
  
  output <- list(
    portfolio_pie = portfolio_pie,
    returns_hist = returns_hist,
    returns_timeseries = returns_timeseries,
    raw_timeseries = raw_timeseries,
    returns_sharperatio = returns_sharperatio,
    portfolio_timeseries = portfolio_timeseries,
    portfolio_sharperatio = portfolio_sharperatio
  )
  
  return(output)
   
}
