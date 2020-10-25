Developing Data Products: Shiny Application and Reproducible Pitch
========================================================
author: Wei Zhang
date: 10/24/2020
autosize: true

Overview
========================================================
<font size="5">

This application employs Shiny and Plotly to generate interactive line graphs of COVID-19 case count.

The graph allows you to 

- Generate line graphs by each state or all states for the 4 types of case count: 
total cases, total deaths, new cases, new deaths.

- Mouse over the line graphs to see daily count

- The case count of "All States" is calculated by the sum of daily number of all states.

The application is published to Rstudio's shiny server at:  
https://wzhang2020.shinyapps.io/courseproject/

server.R and ui.R code on github:  
https://github.com/weizhang280/ShinyApp

Data Source:  <a href="https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36">CDC</a> (Centers for Disease Control and Prevention)  
*negatvie number is a correction of the pervious days"  
*03/01/2020 is chosen as the timeline start point in order to have october data in the graph.

</font>


========================================================

<style>
  
iframe {
  position: absolute;
  top: 50%; 
  left: 50%;
  -webkit-transform: translateX(-50%) translateY(-50%);
  transform: translateX(-50%) translateY(-50%);
  min-width: 100vw; 
  min-height: 130vh; 
  z-index: -1000; 
  overflow: hidden;
}
</style>

<iframe src="https://wzhang2020.shinyapps.io/courseproject/" scrolling="yes" marginheight="0" marginwidth="0"></iframe>


ui.R
========================================================

<font size="4">


```r
library(plotly)
library(shiny)

shinyUI(fluidPage(
    titlePanel("United States COVID-19 Cases and Deaths by State over Time"),              
    br(),
    sidebarLayout(
        sidebarPanel(
            h5("You can generate line graphs of COVID-19 case count by selecting 
            state code (or 'All States') and the case count type from the dropdown
            lists. You can also mouse over the line graph to view daily case count."),

            selectizeInput("stateInput", "State",
                           choices = unique(c("All States", state.name)),  
                           selected="All States", multiple =FALSE),
            
            selectInput("caseInput", "COVID-19",
                        c("total cases" = "tot_cases",
                          "total deaths"="tot_death", 
                          "new cases"="new_case",
                          "new deaths" = "new_death"),   
                        selected="total cases", multiple =FALSE),

            tags$div(
                p(strong("Data Source: "),
                a(href="https://data.cdc.gov/Case-Surveillance/United-States-
                  COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36", "CDC"), 
                "(negatvie number is a correction of the pervious days)"),
                p(strong("Github Code Source: "), 
                a(href="https://github.com/weizhang280/ShinyApp",
                  "https://github.com/weizhang280/ShinyApp"))
            )            
            
),
        
        mainPanel(
            plotlyOutput("plot1"),
        )
    )
))
```
</font>

server.R
========================================================

<font size="4">


```r
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
```
</font>
