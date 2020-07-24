library(tidyverse)

source('~/git/stock_portfolio/modules/create_stock_portfolio.R')

# 30% US stocks (VTI)
# 40% long-term treasuries (TLT)
# 15% intermediate-term treasuries (IEF)
# 7.5% commodities, diversified (DBC)
# 7.5% gold (GLD)

STOCK_SYMBOLS <- c('VTI', 'TLT', 'IEF', 'DBC', 'GLD')
STOCK_WEIGHTS <- c(0.3, 0.4, 0.15, 0.075, 0.075)

#DB_PATH <- '~/git_files/stock_portfolio/data/portfolio_sample.sqlite'

portfolio_df <- custom_portfolio(
  stock_symbols = STOCK_SYMBOLS,
  stock_weights = STOCK_WEIGHTS
)

# # build portfolio, save to SQLite DB
# 
# custom_portfolio(
#   stock_symbols = STOCK_SYMBOLS,
#   stock_weights = STOCK_WEIGHTS,
#   db_export = TRUE,
#   db_path = DB_PATH
# )
# 
# # read portfolio from SQLite DB
# 
# con <- dbConnect(drv = SQLite(), DB_PATH)
# 
# #dbListTables(conn = con)
# 
# portfolio_df <- dbReadTable(conn = con, name = 'portfolio') %>% 
#   mutate(date = as.Date(date))
# 
# dbDisconnect(conn = con)

