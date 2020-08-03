library(shiny)
library(tidyverse)

source('~/git/stock_portfolio/etl_modules/create_stock_portfolio_db.R')
source('~/git/stock_portfolio/visualisations.R')


ui <- tagList(
    navbarPage(
        theme = 'sandstone',
        'S Z I A !',
        tabPanel(
            title = 'Stock Portfolio Monitor',
            sidebarPanel(
                selectizeInput(
                    inputId = 'STOCK_SYMBOLS', 
                    label = 'Enter stock symbols: ',
                    choices = NULL,
                    multiple = TRUE,
                    selected = c('VTI', 'TLT', 'IEF', 'DBC', 'GLD'),
                    options = list(create = TRUE)
                    ),
                textInput(
                    inputId = 'STOCK_WEIGHTS', 
                    label = 'Enter stock weights: ',
                    value = '0.3, 0.4, 0.15, 0.075, 0.075'
                ),
                actionButton('do', 'Click Me')
                ),
                mainPanel(
                    tabsetPanel(
                        tabPanel(
                            title = 'Tab 1',
                            dataTableOutput('weights_df'),
                            plotOutput('raw_timeseries'),
                            plotOutput('returns_hist'),
                            plotOutput('returns_timeseries'),
                            plotOutput('returns_sharperatio'),
                            plotOutput('portfolio_pie'),
                            plotOutput('portfolio_timeseries'),
                            plotOutput('portfolio_sharperatio'),
                            )
                        )
                    )
            ),
        tabPanel('Description', '...')
        )
    )


server <- function(input, output, session) {

    observeEvent(input$do, {
        
        STOCK_SYMBOLS <- input$STOCK_SYMBOLS
        STOCK_WEIGHTS <- str_split(string = input$STOCK_WEIGHTS, pattern = regex(',(\\s)?'))[[1]] %>% as.numeric()
        
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
        
        # create data visualisations
        
        vis_list <- portfolio_visualizer(
            weights_df = weights_df,
            raw_df = raw_df,
            returns_df = returns_df,
            portfolio_df = portfolio_df
        )
        
        # app outputs
        
        output$weights_df <- renderDataTable(weights_df)
        
        output$raw_timeseries <- renderPlot(vis_list$raw_timeseries)
        output$returns_hist <- renderPlot(vis_list$returns_hist)
        output$returns_timeseries <- renderPlot(vis_list$returns_timeseries)
        output$returns_sharperatio <- renderPlot(vis_list$returns_sharperatio)
        output$portfolio_pie <- renderPlot(vis_list$portfolio_pie)
        output$portfolio_timeseries <- renderPlot(vis_list$portfolio_timeseries)
        output$portfolio_sharperatio <- renderPlot(vis_list$portfolio_sharperatio)
        
    })
    
}


shinyApp(ui = ui, server = server)
