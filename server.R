library(shiny)
library(leaflet)
library(htmltools)
library(ggplot2)
library(htmlTable)
library(rsconnect)

#setwd('/Users/Wei/Documents/Marinas/shinyapp')

# load data
# marinas location information
marinas_location = read.csv('Marinas_WA_location.csv')
  
# land use data for ggplot
land_use = read.csv('Marinas_WA_landuse1.csv')
land_use_mean = aggregate(x=land_use$Size, by= list(land_use$Distance,land_use$Type), FUN = mean)

colnames(land_use_mean) <- c('Distance','Land_Use_Type','Size')

specify_decimal <- function(x, k) format(round(x, k), nsmall=k)

land_use_mean$Size <- land_use_mean$Size/10000
land_use_mean$Size <- round(land_use_mean$Size)


# prepare popup information
popup_info <- paste0( 
  "<strong> Marina's Name: </strong>",marinas_location$Marina_Name,
  "<br><strong>Address: </strong>", marinas_location$Address,
  "<table>
      <tr>
  <th><center>Land Type</center></th>
  <th><center>Quarter Mile</center></th>
  <th><center>Half Mile</center></th>
  <th><center>One Mile</center></th>
  </tr>
  <tr>
  <td><center>Business</td>
  <td><center>",round(marinas_location$q_business/10000),"</center></td>
  <td><center>",round(marinas_location$h_business/10000),"</center></td>
  <td><center>",round(marinas_location$o_business/10000),"</center></td>
  </tr>
  <tr>
  <td><center>Education</td>
  <td><center>",round(marinas_location$q_education/10000),"</center></td>
  <td><center>",round(marinas_location$h_education/10000),"</center></td>
  <td><center>",round(marinas_location$o_education/10000),"</center></td>
  </tr>
  <tr>
  <td><center>Office</td>
  <td><center>",round(marinas_location$q_office/10000),"</center></td>
  <td><center>",round(marinas_location$h_office/10000),"</center></td>
  <td><center>",round(marinas_location$o_office/10000),"</center></td>
  </tr>
  <tr>
  <td><center>Parking</center></td>
  <td><center>",round(marinas_location$q_parking/10000),"</center></td>
  <td><center>",round(marinas_location$h_parking/10000),"</center></td>
  <td><center>",round(marinas_location$o_parking/10000),"</center></td>
  </tr>
  <tr>
  <td><center>Parks</td>
  <td><center>",round(marinas_location$q_parks/10000),"</center></td>
  <td><center>",round(marinas_location$h_parks/10000),"</center></td>
  <td><center>",round(marinas_location$o_parks/10000),"</center></td>
  </tr>
  <tr>
  <td><center>Residential</td>
  <td><center>",round(marinas_location$q_residential/10000),"</center></td>
  <td><center>",round(marinas_location$h_residential/10000),"</center></td>
  <td><center>",round(marinas_location$o_residential/10000),"</center></td>
  </tr>
  </table>"
  )

# add basemap
shinyServer(function(input,output,session){
  
  # create basemap
  output$mymap <- renderLeaflet({
    leaflet(data = marinas_location) %>%
      addProviderTiles(
        "CartoDB.DarkMatter"
      )%>%
      addCircleMarkers(~Lon_DD, ~Lat_DD,
        radius = 5.5,
        color = 'yellow',
        stroke = FALSE, fillOpacity = 0.5,
        popup = popup_info
      )%>%
      setView(lng = -121.836643, lat = 47.374678, zoom = 7)
  })
 
  
  # main plot
  output$main_plot <- renderPlot({
    
    ggplot(data = land_use_mean[which(land_use_mean$Distance == input$Distance),],aes(x = Land_Use_Type, y = Size, fill = '#F0952E')) + geom_bar(stat="identity", width = 0.4) + ylab('Average Land Size (10000 sqft)') + xlab('Land Use Type')  + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, size = 10)) + guides(fill = FALSE)}, height = 250
  
  )
  
})

#rsconnect::deployApp('/Users/Wei/Documents/Marinas/R code')