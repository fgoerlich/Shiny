library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

shinyServer(function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(urlTemplate = "http://{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
               attribution= HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>')) %>%
      setView(lng = -2.2, lat = 40.0, zoom = 7)
      #setView(lng = -2.2, lat = 40.0, zoom = 7, options=list(maxBounds=list(list(-18.0, 27.5), list(5.0, 44.5))))
  })
  
  # Reactive expression that returns the set of LAUs that are in bounds
  LAUsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(allLAUs[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east,  bounds$west)

    subset(allLAUs,
      Latitude  >= latRng[1] & Latitude  <= latRng[2]  &
      Longitude >= lngRng[1] & Longitude <= lngRng[2])
  })

  # Names for the x-lab in histogram
  lab <- c(
    "Population" = "Population" ,
    "Aging" = "Aging Score",
    "Foreign" = "Foreign People (%)",
    "Women" = "Female (%)"
  )

  # Histogram for the visible LAUs on the map.
  output$histogram <- renderPlot({
    # If no LAUS are in view, don't plot
    if (nrow(LAUsInBounds()) == 0)
      return(NULL)
    
    SelectedVar <- input$var
    Breaks <- hist(plot = FALSE, allLAUs[[SelectedVar]], breaks = 20)$breaks

    hist(LAUsInBounds()[[SelectedVar]],
      breaks = Breaks,
      main = 'On map visible LAUs',
      xlab = lab[SelectedVar],
      xlim = range(allLAUs[[SelectedVar]]),
      col = '#00DD00',
      border = 'white')
  })

  # session$onFlushed is necessary to work around a bug in the Shiny/Leaflet integration
  # without it, the addCircle commands arrive in the browser before the map is created.
  session$onFlushed(once=TRUE, function() {
    paintObs  <- observe({
      SelectedVar <- input$var
      # Ordering by 'input$var' big values will be drawn first, so all Popups can be seen
      LAUdata <- allLAUs[order(allLAUs[SelectedVar],decreasing=TRUE),]
      colors <- brewer.pal(10, "Spectral")[cut(allLAUs[[SelectedVar]], 10, labels = FALSE)]
      colors <- colors[match(LAUdata$Code, allLAUs$Code)]

      # Clear existing circles before drawing    
      leafletProxy('map', session) %>% clearShapes()
      
      # Draw circles
      leafletProxy('map', session) %>% addCircles(
        LAUdata$Longitud, LAUdata$Latitud,
        radius = sqrt(LAUdata$Population)*50,
        #radius = 1000+log(LAUdata$Population)*300,
        #(LAUdata[[SelectedVar]] / max(allLAUs[[SelectedVar]])) * 30000,
        LAUdata$Code, stroke=FALSE, fill=TRUE, fillOpacity=0.4, color=colors
      )
    })

    # TIL this is necessary in order to prevent the observer from
    # attempting to write to the websocket after the session is gone.
    session$onSessionEnded(paintObs$suspend)
  })

  # Show a popup at the given location
  LAUPopup <- function(Code, lng, lat) {
    selectedLAU <- allLAUs[allLAUs$Code == Code,]
    content <- as.character(tagList(
      tags$h4("Statistics for:"),
      tags$strong(HTML(sprintf("%s %s, %s",
        selectedLAU$Code, selectedLAU$LAU2, selectedLAU$NUTS3))),
      tags$br(),
      sprintf("Population: %s", selectedLAU$Population),    tags$br(),
      sprintf("Aging Score: %.1f", selectedLAU$Aging),      tags$br(),
      sprintf("Foreign People: %s%%", selectedLAU$Foreign), tags$br(),
      sprintf("Women: %s%%", selectedLAU$Women)
    ))
    leafletProxy('map', session) %>% addPopups(lng, lat, content, Code)
  }

  # When map is clicked, show a popup with LAU2 info
  observeEvent(input$map_shape_click, {
    leafletProxy('map', session) %>% clearPopups()
    if (is.null(input$map_shape_click))
      return()
    isolate({
      LAUPopup(input$map_shape_click$id, input$map_shape_click$lng, input$map_shape_click$lat)
    })
  })

## Data Explorer ###########################################

  observe({
    cities <- if (is.null(input$states)) character(0) else {
      filter(cleantable, NUTS %in% input$states) %>%
        `$`('LAU') %>%
        unique() %>%
        sort() %>%
        as.character()
    }
    stillSelected <- isolate(input$cities[input$cities %in% cities])
    updateSelectInput(session, "cities", choices = cities,
                      selected = stillSelected)
  })

  observe({
    if (is.null(input$goto))
      return()
    isolate({
      leafletProxy('map', session) %>% clearPopups()
      dist <- 0.5
      zip <- input$goto$zip
      lat <- input$goto$lat
      lng <- input$goto$lng
      LAUPopup(zip, lng, lat)
      leafletProxy('map', session) %>% fitBounds(lng - dist, lat - dist,
                                                 lng + dist, lat + dist)
    })
  })

  output$table <- renderDataTable({
    cleantable %>%
      filter(
        is.null(input$states) | NUTS %in% input$states,
        is.null(input$cities) | LAU  %in% input$cities
      ) %>%
      mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Code, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
  }, escape = FALSE)

})
