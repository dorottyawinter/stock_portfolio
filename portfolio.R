library(tidyverse)

source('~/git/stock_portfolio/etl_modules/create_stock_portfolio_db.R')

# 30% US stocks (VTI)
# 40% long-term treasuries (TLT)
# 15% intermediate-term treasuries (IEF)
# 7.5% commodities, diversified (DBC)
# 7.5% gold (GLD)

STOCK_SYMBOLS <- c('VTI', 'TLT', 'IEF', 'DBC', 'GLD')
STOCK_WEIGHTS <- c(0.3, 0.4, 0.15, 0.075, 0.075)


# get monthly returns and portfolio

con <- custom_portfolio(
  stock_symbols = STOCK_SYMBOLS,
  stock_weights = STOCK_WEIGHTS
)

weights_df <- dbReadTable(conn = con, name = 'weights')
raw_df <- dbReadTable(conn = con, name = 'raw_data') %>%
  mutate(date = as.Date(date))
returns_df <- dbReadTable(conn = con, name = 'returns') %>%
  mutate(date = as.Date(date))
portfolio_df <- dbReadTable(conn = con, name = 'portfolio') %>%
  mutate(date = as.Date(date))

dbDisconnect(conn = con)

# create pivot for visualizations

portfolio_all <- rbind(portfolio_df, returns_df)

portfolio_pivot_all <- portfolio_all %>% 
  pivot_wider(
    names_from = symbol,
    values_from = monthly_returns
  ) %>%
  na.omit()
