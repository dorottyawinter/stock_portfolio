library(RSQLite)
library(DBI)
library(dbplyr)
library(tidyverse)

source('~/git/stock_portfolio/modules/stock_portfolio.R')


custom_portfolio <- function(
  stock_symbols,
  stock_weights,
  db_export = FALSE,
  db_path = NULL
  ){
  #' Build custom portfolio, optionally save to SQLite DB.
  #'
  #' @description Get stock prices for all the given stock symbols from start_date to end date. Calculate monthly return. Aggregates a group of monthly returns by stocks optionally weighted by the weights parameter into portfolio returns. Optionally saves portfolio to SQLite DB or returns it.
  #' @param stock_symbols (chr vector) Character vector representing a single (or multiple) stock symbol.
  #' @param stock_weights (num vector) Optional parameter for the stock weights, which can be passed as a two column tibble with asset names in first column and weights in second column. Default: NULL.
  #' @param db_export (logical) A logical value that indicates whether to export the constructed portfolio (TRUE) or simply return it (FALSE). Default: FALSE.
  #' @param db_path (chr) Character string representing the path to the SQLite DB file.
  #' @return (tibble/None) Conditionally returns the monthly portfolio returns in tidy format (i.e long format) or returns nothing.
  #' @examples
  #' custom_portfolio(stock_symbols = c('VTI', 'TLT', 'IEF'), stock_weights = c(0.4, 0.35, 0.25))
  
  
  # stock symbols and weights
  
  weights <- tibble(stock_symbols, stock_weights)
  
  # calculate monthly returns
  
  returns <- get_monthly_return(stock_symbols = stock_symbols)
  
  # # show returns
  # 
  # returns_pivot <- returns %>% 
  #   pivot_wider(
  #     names_from = symbol, 
  #     values_from = monthly.returns
  #     ) %>% 
  #   na.omit()
  
  # build portfolio
  
  portfolio <- build_portfolio(
    returns = returns,
    weights = weights
  )
  
  # export to sqlite database - if db_path parameter is given and db_export is set to TRUE
  
  if(db_export && !is.null(db_path)){
    
    dir.create(
      path = word(string = db_path, start = 1, end = -2, sep = '/'), 
      recursive = TRUE, 
      showWarnings = FALSE
      )
    
    con <- dbConnect(drv = RSQLite::SQLite(), db_path)
    
    dbWriteTable(
      conn = con, 
      name = 'portfolio', 
      value = portfolio, 
      savemode = 'u', 
      overwrite = TRUE,
      field.types = c(symbol = 'TEXT', date  = 'DATE', portfolio_returns = 'DOUBLE')
      )
    
    # dbDisconnect(conn = con)
    # unlink(x = db_path)
    
  }else{
    
    return(portfolio)
    
  }
  
}