library(shiny)
library(leaflet)

shinyUI(bootstrapPage(
  
  h4('Marinas in Washington State', align = 'center'),
  leafletOutput('mymap', height = 600),
  
  absolutePanel(id = 'controls', class = 'panel', fixed = TRUE,
    draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
    width = 360, height = 350,

    
    selectInput(inputId = 'Distance',
    label = "Please Select A Distance:",
    choices = c('Quarter Mile', 'Half Mile','One Mile'),
    selected = 'Quarter Mile'
    ),
    
    includeCSS("styles.css"),
    
    plotOutput(outputId = 'main_plot', height = '200px'),
    
    plotOutput(outputId = 'sub_plot', height = '200px',click = clickOpts(id = 'plot_click'))
    
    
  )
))


