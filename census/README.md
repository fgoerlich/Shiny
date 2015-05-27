# Census 2011 demo

This interactive presentation shows s simple way to disseminate data using as an example census 2011 data at LAU2 (municipal) geographical level from Spain.

The applications has three tabs:

1. **Interactive map**: It shows Spanihs LAUs represented with a circle. On the right you find a menu to select variables: Population, Aging Score (0-100 index based on age and dependent population), share of Foreign and Females. The histograma is fixed according to the nation wide distribution, but as you navigate and zoom this is adjusted to the distribution you see on the screen. Circle size and colors are fixed across variables and determined by the national distribution, so a tiny point means a tiny LAU. Clicking on a circle shows statistical information about the LAU. Colors are represented by a diverging Spectral palette with 10 classes that can be seen at the well known _[Color Brewer](http://colorbrewer2.org/)_ schemes. Here is how it looks like:  
![10 class Spectral diverging](data/BrewerSpectra10.jpg)  

2. **Data explorer**: A dynamic table to explore data for some LAUs. After selecting a NUTS 3 region several LAUs can be chosen from the list and their statistical information displayed. An action button, on the right, leads you to the corresponding LAU centered on the map, showing the statistical information and the sorrounding LAUs.

3. **Documentation**: This information and the *link* to the code.

Statistical data comes from Spanish Census 2011 conducted by the Spanish National Statistical Institute [(INE)](http://www.ine.es/).

See a live version at _[Census data](https://goerlich.shinyapps.io/census/)_.

You can run this demo within R using Shiny. The code can be access from this tab, just below, and can be modified to suit your needs.

This app was inspired by a similar one, **SuperZIP**, available at _[Shiny gallery](http://shiny.rstudio.com/gallery/)_, which in turn is based on an amazing interactive feature published by the Washington Post: _[Washington: A world apart](http://www.washingtonpost.com/sf/local/2013/11/09/washington-a-world-apart/)_. Not to be missed!

