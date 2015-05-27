library(shiny)
library(leaflet)
library(markdown)

# Choices for drop-downs menu
vars <- c(
  "Population" = "Population",
  "Aging Score" = "Aging",
  "Foreign People (%)" = "Foreign",
  "Female (%)" = "Women"
)

shinyUI(navbarPage("Census 2011", id="nav",

  tabPanel("Interactive map",
    div(class="outer",

      tags$head(
        # Include custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      leafletOutput("map", width='100%', height='100%'),

      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",
        
        h2("LAU Explorer"),
        selectInput("var", "Variable", vars, selected = 'Population'),
        plotOutput("histogram", height = 300)
      ),
      tags$div(id='cite','Data compiled for Francisco Goerlich from Census 2011 - INE')
    )
  ),

  tabPanel("Data explorer",
    fluidRow(
      column(3,
        selectInput("states", "NUTS", c("None"=" ", as.character(cleantable$NUTS)), selected = " ")
      ),      
      column(3,
        conditionalPanel("input.states",
          selectInput("cities", "LAUs", c("All LAUs"=""), multiple=TRUE)
        )
      )
    ),
    hr(),
    dataTableOutput("table")
  ),
  
  tabPanel("About",
    includeMarkdown('README.md'),
    br(),
    helpText(a(href='https://github.com/fgoerlich/Shiny/tree/master/census', target='_blank', 'View code'))
  ),
  
  conditionalPanel("false", icon("crosshair"))
))
