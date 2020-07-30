library(RColorBrewer)
library(tidyverse)

get_color_palette <- function(df, color_col){
  
  n = length(unique(df %>% pull(!! color_col)))
  custom_color <- '#d38dcc'
  
  if(any(grepl(pattern = 'PORTFOLIO', x = df %>% pull(!! color_col)))){
    if(n == 1){
      custom_palette <- custom_color
    }else if(n <= 6){
      custom_palette <- c(custom_color, wes_palette(name = 'Darjeeling2', n = n-1))
    }else{
      custom_palette <- c(custom_color, colorRampPalette(wes_palette(name = 'Darjeeling2', n = 5))(n-1))
    }
    names(custom_palette) <- c('PORTFOLIO', setdiff(levels(as.factor(df %>% pull(!! color_col))), 'PORTFOLIO'))
  }else{
    if(n <= 5){
      custom_palette <- wes_palette(name = 'Darjeeling2', n = n)
    }else{
      custom_palette <- colorRampPalette(wes_palette(name = 'Darjeeling2', n = 5))(n)
    }
    names(custom_palette) <- levels(as.factor(df %>% pull(!! color_col)))
  }
  
  return(custom_palette)
  
}
