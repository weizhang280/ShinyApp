#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
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
            
            hr(),
            
            selectizeInput("stateInput", "State",
                           choices = unique(c("All States", state.name)),  
                           selected="All States", multiple =FALSE),
            
            selectInput("caseInput", "COVID-19",
                        c("total cases" = "tot_cases",
                          "total deaths"="tot_death", 
                          "new cases"="new_case",
                          "new deaths" = "new_death"),   
                        selected="total cases", multiple =FALSE),
            br(),
            
            tags$div(
                p(strong("Data Source: "),
                a(href="https://data.cdc.gov/Case-Surveillance/United-States-
                  COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36", "CDC"), "(Centers
                  for Disease Control and Prevention)"),
                p("*negatvie number is a correction of the pervious days")
            )            
            
),
        
        mainPanel(
            plotlyOutput("plot1"),
        )
    )
))