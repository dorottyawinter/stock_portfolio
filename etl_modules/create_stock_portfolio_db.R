library(RSQLite)
library(DBI)
library(dbplyr)
library(tidyverse)

source('~/git/stock_portfolio/etl_modules/stock_portfolio.R')


custom_portfolio <- function(
  stock_symbols,
  stock_weights,
  db_path = ':memory:'
  ){
  #' Build custom portfolio and save to SQLite DB.
  #'
  #' @description Get stock prices for all the given stock symbols from start_date to end date. Calculates monthly returns. Aggregates a group of monthly returns by stocks optionally weighted by the weights parameter into portfolio returns. Saves monthly returns and portfolio returns to SQLite DB.
  #' @param stock_symbols (chr vector) Character vector representing a single (or multiple) stock symbol.
  #' @param stock_weights (num vector) Optional parameter for the stock weights, which can be passed as a two column tibble with asset names in first column and weights in second column. Default: NULL.
  #' @param db_path (chr) Character string representing the path to the SQLite DB file, or store it in-memory. Default: ':memory:'.
  #' @return (SQLiteConnection) Returns SQLite connection.
  #' @examples
  #' custom_portfolio(stock_symbols = c('VTI', 'TLT', 'IEF'), stock_weights = c(0.4, 0.35, 0.25))
  
  
  # stock symbols and weights
  
  weights <- tibble(stock_symbols, stock_weights)
  
  # calculate monthly returns
  
  returns <- get_monthly_return(stock_symbols = stock_symbols)
  
  # build portfolio
  
  portfolio <- build_portfolio(
    returns = returns,
    weights = weights
  )
  
  # export to sqlite database - if db_path parameter is given and db_export is set to TRUE
  
  if(db_path == ':memory:'){
    
    con <- dbConnect(drv = SQLite(), db_path)
    
  }else{
    
    dir.create(
      path = word(string = db_path, start = 1, end = -2, sep = '/'), 
      recursive = TRUE, 
      showWarnings = FALSE
    )
    
    con <- dbConnect(drv = SQLite(), db_path)
    
  }
  
  dbWriteTable(
    conn = con, 
    name = 'portfolio', 
    value = portfolio, 
    savemode = 'u', 
    overwrite = TRUE,
    field.types = c(symbol = 'TEXT', date  = 'DATE', monthly_returns = 'DOUBLE')
  )
    
  dbWriteTable(
    conn = con, 
    name = 'returns', 
    value = returns, 
    savemode = 'u', 
    overwrite = TRUE,
    field.types = c(symbol = 'TEXT', date  = 'DATE', monthly_returns = 'DOUBLE')
  )
    
  # dbDisconnect(conn = con)
  # unlink(x = db_path)
  
  return(con)
  
}