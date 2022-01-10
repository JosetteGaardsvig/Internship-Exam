## app.R ##
library(shinydashboard)
library(dplyr)
library(leaflet)
library(httr)
library(rjson)
library(jsonlite)
library(readr)
library(readxl)
library(ggplot2)

#kilde: https://medium.com/swlh/creating-a-live-world-weather-map-using-shiny-f2ad05a08a13



json_file <- jsonlite::fromJSON("http://adelby.dk/json/test004.json",flatten = T)

df <- read_excel("visits_country.xlsx")



ui <- dashboardPage(
  dashboardHeader(title = "ADELBY AVIONICS"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Visits Worldwide", tabName="visits"),
      menuItem("Statistics", tabname="statistics")
    )
  ),
  
  
  body = dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      
      
      title = "Visits Worldwide",
      leaflet() %>%
        addProviderTiles(providers$Esri.WorldTerrain) %>%
        setView(lat = 30, lng = 30, zoom = 2) %>%
        setMaxBounds(lng1 = -140, lat1 = -70, lng2 = 155, lat2 = 70 ) %>%
        addMarkers(data = json_file$locations),
      
      
      
      tabItem(tabName="performance",
              
              
              
              tabBox(
                title = "Country Statistics",
                # The id lets us use input$tabset1 on the server to find the current tab
                id = "tabset1", width="12", height="500px",
                tabPanel("Visit count", plotOutput('plot1')),
                #tabPanel("Klassetrin", "Klassetrin versus engangsdonorer (t.v.) og flergangsdonorer (t.h.)", plotOutput('plot2')),
                #tabPanel("Projektkategori", "Projektkategori versus engangsdonorer (t.v.) og flergangsdonorer (t.h.)", plotOutput('plot3')),
                #tabPanel("Undervisere", "Antal undervisere versus engangsdonorer (t.v.) og flergangsdonorer (t.h.)", plotOutput('plot4'))
              ))
      
    )
  )
)



server <- function(input, output) {
  
  
  # The currently selected tab from the tabBox
  output$tab1Selected <- renderText({
    input$tab1
  })
  output$plot1 = renderPlot(
    {
      p<-ggplot(data=df, aes(x=reorder(location_country, total_visitors), y=total_visitors, fill=location_country)) +
        ggtitle("Visits summarized per Country Worldwide") + geom_bar(stat="identity")
      p + coord_flip()}
    
  )
  
  
  
}

shinyApp(ui, server)