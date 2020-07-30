library(tidyverse)

source('~/git/stock_portfolio/visual_modules/ggplot_modules.R')


# histogram of monthly returns

returns_hist_params <- list(
  labs = list(
    x = 'monthly returns',
    y = 'count',
    title = 'Histogram of monthly returns per asset\n'
  )
)

vis_hist(
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

vis_timeseries(
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

vis_timeseries(
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
    title = 'Annualized Sharpe Ratio per stock (RFR=3%)'
  )
)

vis_sharperatio(
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

vis_timeseries(
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
    title = 'Annualized Sharpe Ratio per stock (RFR=3%)'
  )
)

vis_sharperatio(
  df = portfolio_all,
  value_col = monthly_return,
  category_col = symbol,
  params_list = portfolio_sharperatio_params
)
