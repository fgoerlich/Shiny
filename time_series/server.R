#require(rCharts)
shinyServer(function(input, output) {
  Unemployment <- read.table('UnemploymentRate.csv',sep=';',header=TRUE)
  Unemployment$Date <- as.character(Unemployment$Date)
  
  output$myChart <- renderChart({
    m1 <- mPlot(x = "Date", y = c("Males", "Females"), type = "Line", data = Unemployment,
                pointSize = 0, lineWidth = 1)
    m1$addParams(dom = 'myChart')
    return(m1)
  })

})