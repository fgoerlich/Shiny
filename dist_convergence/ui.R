library(markdown)
library(shiny)

shinyUI(navbarPage('Catching-up and Distribution Convergence Index',
  
  tabPanel('Distributions',
    sidebarPanel(
      #   Parameters for the 1st distribution
      sliderInput('mu1', 'Mean distribution 1', value = 10, min = 10, max = 40, step = 1),
      sliderInput('sd1', 'Standard deviation distribution 1', value = 5, min = 1, max = 10, step = 1),
      br(),
      
      #   Parameters for the 2nd distribution
      sliderInput('mu2', 'Mean distribution 2', value = 40, min = 10, max = 40, step = 1),
      sliderInput('sd2', 'Standard deviation distribution 2', value = 5, min = 1, max = 10, step = 1),
      br(),

      #   Sensitivity parameter
      sliderInput('alpha', 'Sensitivity parameter', value = 1, min = 0, max = 3, step = 0.25),
      br(),

      #   Value of the convergence index
      h5('Convergence index (%)'),
      fluidRow(column(6, verbatimTextOutput('index'))),
      
      br(),br(),
      helpText(a(href = 'https://github.com/fgoerlich/Shiny/tree/master/dist_convergence', target = '_blank', 'View code'))
    ),
    
    mainPanel(
      h4('Catching-up and Convergence between distributions'),
      plotOutput('density')
    )
  ),
  
  tabPanel('About',
    includeMarkdown('README.md')
  )
  
))