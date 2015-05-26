suppressPackageStartupMessages(library(dplyr))

allLAUs <- read.table('data/Census2011.csv',sep=',',header=TRUE,fileEncoding="ISO8859-1")
#allzips$Latitude <- jitter(allzips$Latitude)
#allzips$Longitude <- jitter(allzips$Longitude)
allLAUs$Aging <- round(allLAUs$Aging,2)
allLAUs$Foreign <- round(allLAUs$Foreign,1)
allLAUs$Women <- round(allLAUs$Women,1)
allLAUs$Code <- formatC(allLAUs$Code, width=5, format='d', flag='0')
row.names(allLAUs) <- allLAUs$code

cleantable <- allLAUs %>%
  select(
    LAU = LAU2,
    NUTS = NUTS3,
    Code = Code,
    Aging = Aging,
    Population = Population,
    Foreign = Foreign,
    Female = Women,
    Lat = Latitude,
    Long = Longitude
  )
