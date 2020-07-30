library(extrafont)
library(wesanderson)
library(tidyverse)

loadfonts(device = "win")

source('~/git/stock_portfolio/visual_modules/custom_palette.R')


font_family = 'Leelawadee UI Semilight'


vis_pie <- function(df, category_col, value_col, params_list){
  
  category_col = enquo(category_col)
  value_col = enquo(value_col)
  
  vis_palette <- get_color_palette(df = df, color_col = category_col)
  
  vis <- ggplot(
    data = df,
    mapping = aes(
      x = '',
      y = !! value_col,
      fill = !! category_col
    )
  ) +
    geom_bar(
      stat = 'identity',
      width = 1,
      alpha = 0.7
    ) +
    coord_polar(
      theta = 'y', 
      start = 0
      ) +
    geom_text(
      label = scales::percent(df %>% pull(!! value_col)), 
      position = position_stack(vjust = 0.5),
      size = 4,
      family = font_family
      ) +
    scale_fill_manual(values = vis_palette) +
    labs(
      title = params_list[['labs']][['title']]
    ) +
    theme_void() +
    theme(
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      plot.title = element_text(size = 13, family = font_family, hjust = 0.5),
      legend.title = element_blank()
    )
  
  return(vis)
  
}


vis_hist <- function(df, x_col, category_col, params_list){
  
  x_col = enquo(x_col)
  category_col = enquo(category_col)
  
  vis_palette <- get_color_palette(df = df, color_col = category_col)
  
  vis <- ggplot(
    data = df,
    mapping = aes(
      x = !! x_col,
      colour = !! category_col,
      fill = !! category_col
    )
  ) +
    facet_wrap(
      facets = vars(!! category_col),
      scales = 'free_y',
      strip.position = 'top'
    ) +
    geom_density(
      alpha = 0.3
    ) +
    geom_histogram(
      alpha = 0.3, 
      binwidth = 0.005
    ) +
    scale_x_continuous(labels = scales::percent) +
    scale_fill_manual(values = vis_palette) +
    scale_colour_manual(values = vis_palette) +
    labs(
      x = if_else(condition = is.null(params_list[['labs']][['x']]), true = quo_name(x_col), false = params_list[['labs']][['x']]),
      y = if_else(condition = is.null(params_list[['labs']][['y']]), true = 'count', false = params_list[['labs']][['y']]),
      title = params_list[['labs']][['title']]
      ) +
    guides(colour = FALSE) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(size = 7, family = font_family),
      axis.text.y = element_text(size = 7, family = font_family),
      axis.title.x = element_text(size = 9, family = font_family),
      axis.title.y = element_text(size = 9, family = font_family),
      plot.title = element_text(size = 13, family = font_family, hjust = 0.5),
      strip.background.x = element_rect(fill = 'gray90'),
      strip.text.x = element_text(size = 9, family = font_family, color = 'black'),
      legend.title = element_blank()
    )
  
  return(vis)
  
}


vis_timeseries <- function(df, x_col, y_col, category_col, params_list){
  
    x_col = enquo(x_col)
    y_col = enquo(y_col)
    category_col = enquo(category_col)
    
    vis_palette <- get_color_palette(df = df, color_col = category_col)
    
    vis <- ggplot(
      data = df,
      mapping = aes(
        x = !! x_col,
        y = !! y_col,
        colour = !! category_col,
      )
    ) +
      facet_wrap(
        facets = vars(!! category_col),
        scales = 'free_y',
        strip.position = 'top'
      ) +
      geom_line() +
      geom_smooth(method = 'lm', alpha = 0.3) +
      scale_y_continuous(labels = scales::percent) + #params_list[['scale_y_continuous']][['labels']]) +
      scale_fill_manual(values = vis_palette) +
      scale_colour_manual(values = vis_palette) +
      labs(
        x = if_else(condition = is.null(params_list[['labs']][['x']]), true = quo_name(x_col), false = params_list[['labs']][['x']]),
        y = if_else(condition = is.null(params_list[['labs']][['y']]), true = quo_name(y_col), false = params_list[['labs']][['y']]),
        title = params_list[['labs']][['title']]
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(size = 7, family = font_family),
        axis.text.y = element_text(size = 7, family = font_family),
        axis.title.x = element_text(size = 9, family = font_family),
        axis.title.y = element_text(size = 9, family = font_family),
        plot.title = element_text(size = 13, family = font_family, hjust = 0.5),
        strip.background.x = element_rect(fill = 'gray90'),
        strip.text.x = element_text(size = 9, family = font_family, color = 'black'),
        legend.key = element_rect(fill = 'white'),
        legend.title = element_blank()
      )

  return(vis)
}


vis_sharperatio <- function(df, value_col, category_col, params_list){

  value_col = enquo(value_col)
  category_col = enquo(category_col)
  
  df_sharperatio <- df %>% 
    group_by(!! category_col) %>% 
    tq_performance(
      Ra = monthly_returns,
      performance_fun = SharpeRatio.annualized,
      scale = 12,
      Rf = 0.03 / 12) %>% # risk free rate / 12 months
    ungroup()
  
  if(any(grepl(pattern = 'PORTFOLIO', x = df_sharperatio %>% pull(!! category_col)))){
    category_col_levels <- c(rev(setdiff(levels(as.factor(df_sharperatio %>% pull(!! category_col))), 'PORTFOLIO')), 'PORTFOLIO')
  }else{
    category_col_levels <- rev(levels(as.factor(df_sharperatio %>% pull(!! category_col))))
  }
  
  vis_palette <- get_color_palette(df = df, color_col = category_col)
  
  vis <- ggplot(
    data = df_sharperatio,
    mapping = aes(
      x = !! category_col,
      y = round(`AnnualizedSharpeRatio(Rf=3%)`, digits = 3), 
      label = round(`AnnualizedSharpeRatio(Rf=3%)`, digits = 3), 
      fill = !! category_col
      )
    ) +
    geom_bar(
      alpha = 0.7,
      width = 0.5,
      stat = 'identity'
      ) +
    geom_hline(
      yintercept = 0,
      size = 1,
      colour = 'gray80'
      ) +
    coord_flip() +
    scale_x_discrete(limits = category_col_levels) +
    #geom_label(nudge_y = -0.05) +
    scale_fill_manual(values = vis_palette) +
    scale_colour_manual(values = vis_palette) +
    labs(
      x = if_else(condition = is.null(params_list[['labs']][['x']]), true = quo_name(category_col), false = params_list[['labs']][['x']]),
      y = if_else(condition = is.null(params_list[['labs']][['y']]), true = 'sharpe ratio', false = params_list[['labs']][['y']]),
      title = params_list[['labs']][['title']]
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(size = 7, family = font_family),
      axis.text.y = element_text(size = 7, family = font_family),
      axis.title.x = element_text(size = 9, family = font_family),
      axis.title.y = element_text(size = 9, family = font_family),
      plot.title = element_text(size = 13, family = font_family, hjust = 0.5),
      legend.title = element_blank()
    )
    
  return(vis)
  
}
