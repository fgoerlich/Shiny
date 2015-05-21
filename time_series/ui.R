library(markdown)
library(shiny)
library(reshape2)
require(rCharts)

shinyUI(fluidPage(
  titlePanel('Spanish Historical Unemployment Rate Broken by Sex'),

  showOutput('myChart','morris'),
  h6('Source: INE'),
  br(),br(),
  includeMarkdown('README.md')
  
  
#  fluidRow(
#    column(4,
#      includeMarkdown('README.md'),
#      showOutput('myChart','morris')
#    )
#  )
))