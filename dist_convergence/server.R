shinyServer(function(input, output) {
    x   <- seq(0, 50, length=1000)

    g <- function(x) {
         y1   <- dnorm(x, mean = input$mu1, sd = input$sd1)
         y2   <- dnorm(x, mean = input$mu2, sd = input$sd2)
         pmax(y1, y2)
    }

    f <- function(x) {
         y1   <- dnorm(x, mean = input$mu1, sd = input$sd1)
         y2   <- dnorm(x, mean = input$mu2, sd = input$sd2)
         pmin(y1, y2)
    }

    output$density <- renderPlot({
        y1   <- dnorm(x, mean = input$mu1, sd = input$sd1)
        y2   <- dnorm(x, mean = input$mu2, sd = input$sd2)
        ymax <- max(max(y1), max(y2))
        
        #   plotting densities
        plot(x, y1,  type = "h", lwd = 1, col = 'lightblue',
             ylab = '', xlab = '', yaxt = 'n', axes = FALSE, ylim = c(0, ymax))
        axis(1, cex.axis = 1.3)
        lines(x, y2, type = 'h', lwd = 1, col = 'lightgreen')
        
        #   calculating the intersections & ploting
        miny <- pmin(y1,y2)
        lines(x, miny, type = 'h', lwd = 1, col = 'red')
    })

    output$index <- renderText({
        ind <- integrate(f, -Inf, Inf)$value[1]/(integrate(g, -Inf, Inf)$value[1]^input$alpha)
        paste0(round(100*ind, 2), '%')
    })

})