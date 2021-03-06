library(tidyquant)
library(tidyverse)

get_stock_prices <- function(
  stock_symbols, 
  end_date = Sys.Date(), 
  start_date = end_date - years(25) + days(1)
){
  #' Get raw stock prices.
  #'
  #' @description Get raw stock prices for all the given stock symbols from start_date to end date.
  #' @param stock_symbols (chr vector) Character vector representing a single (or multiple) stock symbol.
  #' @param end_date (Date) A character string representing an end date in YYYY-MM-DD format. Default: today's date.
  #' @param start_date (Date) A character string representing a start date in YYYY-MM-DD format. Default: 25 years before today's date if possible.
  #' @return (tibble) Returns the raw stock prices in tidy format (i.e long format).
  #' @examples
  #' get_stock_prices(stock_symbols = c('VTI', 'TLT', 'IEF'), end_date = '2019-12-31', start_date = '2014-12-31')
  
  # extract stock prices
  
  raw_df <- stock_symbols %>% 
    tq_get(
      get = "stock.prices",
      from = start_date,
      to = end_date
    )
  
  return(raw_df)
  
}


calc_monthly_return <- function(
  stock_prices
){
  #' Calculate monthly return.
  #'
  #' @description Calculate monthly returns from raw stock prices.
  #' @param stock_prices (tibble) Tibble of raw stock prices in tidy format (i.e long format).
  #' @return (tibble) Returns the monthly returns in tidy format (i.e long format).
  #' @examples
  #' calc_monthly_return(stock_prices = get_stock_prices(stock_symbols = c('VTI', 'TLT', 'IEF')))
  
  # check first date - to help the comparability of my return calculation
  
  first_date = stock_prices %>%
    group_by(symbol) %>%
    summarise(
      first_date = min(date),
      last_date = max(date)
    ) %>%
    ungroup() %>% 
    pull(first_date) %>% 
    max()
  
  # transform to monthly returns, filter based on to the first date due to the comparability
  
  returns <- stock_prices %>% 
    select(symbol, date, adjusted) %>% 
    group_by(symbol) %>% 
    tq_transmute(
      select = adjusted,
      mutate_fun = monthlyReturn
    ) %>% 
    ungroup() %>%
    mutate(date = rollback(dates = date, roll_to_first = TRUE)) %>% 
    rename(monthly_returns = monthly.returns)
  
  returns <- returns %>% 
    group_by(symbol) %>% 
    filter(date >= first_date)
  
  return(returns)
  
}


build_portfolio <- function(
  returns,
  weights = NULL
  ){
  #' Build portfolio.
  #'
  #' @description Aggregates a group of monthly returns by stocks optionally weighted by the weights parameter into portfolio returns.
  #' @param weights (tibble) Optional parameter for the stock weights, which can be passed as a two column tibble with asset names in first column and weights in second column. Default: NULL.
  #' @param returns (tibble) Monthly returns in tidy format (i.e long format).
  #' @return (tibble) Returns monthly portfolio returns in tidy format (i.e long format).
  #' @examples
  #' build_portfolio(weights = tibble(c('VTI', 'TLT', 'IEF'), c(0.4, 0.35, 0.25)), returns = calc_monthly_return(stock_prices = get_stock_prices(stock_symbols = c('VTI', 'TLT', 'IEF'))))
  
  
  # build portfolio
  
  portfolio <- returns %>% 
    tq_portfolio(
      assets_col = symbol,
      returns_col = monthly_returns,
      weights = weights,
      rebalance_on = 'years'
    ) %>% 
  add_column(symbol = 'PORTFOLIO', .before = 1) %>% 
  rename(monthly_returns = portfolio.returns)
  
  #last_date <- max(portfolio$date)
  
  return(portfolio)
  
}






