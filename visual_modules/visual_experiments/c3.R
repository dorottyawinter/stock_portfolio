library(c3)

dates = unique(portfolio_pivot_all$date)
dates[seq(1, length(dates), 12)]
dates[grepl('....-01-01', dates)]


portfolio_pivot_all %>% 
  c3(
    x = 'date'
  ) %>% 
  c3_mixedGeom(
    type = 'bar', 
    stacked = unique(returns_df$symbol),
    types = list(PORTFOLIO = 'line') #list(a='area',c='spline')
  ) %>% 
  point_options(
    r = 3, 
    expand.r = 2
    ) %>% 
  grid(
    axis = 'x',
    show = FALSE#,
    # lines = data.frame(
    #   value = #c(3, 10), 
    #   #text = c('Line 1','Line 2')
    #   )
  ) %>% 
  grid(
    axis = 'y'
    ) %>% 
  subchart()
