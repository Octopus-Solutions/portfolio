library(shiny)
library(ggplot2)
library(plotly)
library(tidyr)

library(lubridate)
library(dplyr)
library(purrr)



library(quantmod)
library(tidyquant)

ui <- fluidPage(  
    
    sidebarLayout(
        sidebarPanel(h4("Williams Portfolio"),
                     DT::dataTableOutput("mytable")) ,
        mainPanel(
            plotlyOutput("plot2")))
    
    
    
    )

server <- function(input, output) {
    
    
    today = Sys.time()
    last_year = today - years(1)
    tickers = c( "ASIA.AX", "XRO.AX", "APX.AX", "BRK-B","MSFT","CBA.AX","BHP.AX", "AGL.AX", "KGN.AX","NDQ.AX","AMD","APT.AX")
    tickers2 = c("^GSPC")   
    
    
    
    
    
    
    prices = tq_get(tickers,
                    from = last_year,
                    to = today,
                    get = "stock.prices")
    prices %>%
        group_by(symbol) %>%
        slice(1)
    
    myslice =    prices[c(1,2,6)] %>%
        group_by(symbol) %>%
        slice(1)
    

    output$table <- renderDataTable(myslice, options = list(pageLength = 2))
   
    
    
    output$plot2 <- renderPlotly({
        print(ggplotly(
            
                ggplot(prices) + aes(x = date, y = adjusted, color = symbol) +
                    geom_line(size=0.2) + ylab('Close')+
                    facet_wrap(~symbol,scales = 'free_y') +
                    theme_bw() +geom_smooth(formula = y~x, method = loess, size=.3) + ggtitle("Williams Portfolio")+
                    theme(axis.text.x = element_text(angle = 90) )))
        
    })
    
    
    output$mytable = DT::renderDataTable({
        myslice
    })
}

shinyApp(ui, server)
