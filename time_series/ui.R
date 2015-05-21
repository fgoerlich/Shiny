library(markdown)
library(shiny)
library(reshape2)
require(rCharts)

shinyUI(fluidPage(
  titlePanel('Spanish Historical Unemployment Rate Broken by Sex'),

  showOutput('myChart','morris'),
  h6('Source: INE'),
  
  br(),
  includeMarkdown('README.md'),
  
  br(),
  helpText(a(href='https://github.com/fgoerlich/Shiny/tree/master/time_series', target='_blank', 'View code'))
  
))