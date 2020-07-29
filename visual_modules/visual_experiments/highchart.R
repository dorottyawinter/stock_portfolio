library(highcharter)

# STOCK_SYMBOLS <- c('VTI', 'TLT', 'IEF', 'DBC', 'GLD')
# STOCK_WEIGHTS <- c(0.3, 0.4, 0.15, 0.075, 0.075,
#                    1, 0, 0, 0, 0,
#                    0, 1, 0, 0, 0,
#                    0, 0, 1, 0, 0,
#                    0, 0, 0, 1, 0,
#                    0, 0, 0, 0, 1)
# 
# weights <- tibble(STOCK_SYMBOLS) %>% 
#   tq_repeat_df(n = 6) %>% 
#   bind_cols(tibble(STOCK_WEIGHTS)) %>% 
#   group_by(portfolio)


hc <- highchart(type = "stock")
for(i in 2:ncol(portfolio_pivot_all)){
  hc <- hc %>% 
    hc_add_series(
      portfolio_pivot_all %>% pull(i), 
      type = "line",
      name = colnames(portfolio_pivot_all)[]
    )
}
hc %>% 
  hc_tooltip(
    pointFormat ="<span style=\"color:{series.color}\">{series.name}</span>:<b>${point.y:,.0f}</b><br/>",
    shared=TRUE
    )
