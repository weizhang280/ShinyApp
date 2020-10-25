#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(plotly)
library(shiny)
library(dplyr)

url <- "https://raw.githubusercontent.com/weizhang280/data-sharing/main/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv"
df <- read.csv(url)
start.date <- '03/01/2020'

shinyServer(function(input, output) {
    
    covid <- reactive({
        
        if (input$stateInput == "All States") {
            df %>% filter(state %in% state.abb
                          & submission_date >= start.date) %>%
                select(submission_date, input$caseInput) %>%               
                group_by(submission_date) %>% summarize_all(sum)
            
        } else {             
            
            df %>% filter(state == 
                              state.abb[which(state.name == input$stateInput)] 
                          & submission_date >= start.date) %>%
                select(submission_date, input$caseInput) 
        }
    }) 
    
    x <- list(
        title = "Submission Date"
    )
    
    y <- list(
        title = "Case Number"
    )
    
    output$plot1 <- renderPlotly({
        plot1 <-plot_ly(covid(), x = ~submission_date, 
                        y = ~covid()[[2]], type = "scatter", mode = "lines") %>%
            layout(title = input$stateInput,  xaxis = x, yaxis = y)
        
    })
    
})