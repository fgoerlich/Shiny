library(shiny)

shinyUI(pageWithSidebar(
  
    headerPanel("Convergence Index"),
    
    sidebarPanel(
      #   Parameters for the 1st distribution
    	sliderInput('mu1', 'Mean distribution 1', value = 10, min = 10, max = 40, step = 1),
    	sliderInput('sd1', 'Standard deviation distribution 1', value = 5, min = 1, max = 10, step = 1),
      br(),br(),
      
      #   Parameters for the 2nd distribution
      sliderInput('mu2', 'Mean distribution 2', value = 40, min = 10, max = 40, step = 1),
      sliderInput('sd2', 'Standard deviation distribution 2', value = 5, min = 1, max = 10, step = 1),
      
      #   Value of the convergence index
      hr(),hr(),
      h4('Value of the convergence index'),
    	fluidRow(column(6, verbatimTextOutput('index')))
    ),
    
    mainPanel(
      h4('Convergence between two distributions as measured by the red area'),
    	plotOutput('density')
    )
    
))