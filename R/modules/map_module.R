library(leaflet)
suppressWarnings(library(dplyr))


mapModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("map_or_message"), height = "600px")
  )
}


mapModule <- function(input, output, session, observations) {
  
  ns <- session$ns
 
  output$map_or_message <- renderUI({

    if (is.null(observations())) {
      div(
        style = "height: 600px; display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #2c3e50;",
        h2("Welcome to the Biodiversity Dashboard",
           style = "color: #ffffff; text-align: center; font-size: 4rem; font-weight: bold; margin-bottom: 20px;"),
        
        p("This dashboard allows you to explore species observations from around the world.",
          style = "color: #ecf0f1; text-align: center; font-size: 2rem; max-width: 600px;"),
        
        p("You can search by common or scientific name of species, visualize observations on the map, and view the timeline of when these species were observed.",
          style = "color: #ecf0f1; text-align: center; font-size: 1.5rem; max-width: 800px;"),
        
        p("Select a species to get started. Explore the data and uncover interesting patterns about species biodiversity!",
          style = "color: #ecf0f1; text-align: center; font-size: 1.5rem; max-width: 800px;")
      )
      
      
    } else {
      
      leafletOutput(ns("map"), height = "600px")
      
    }
  })

  
    # Initial map
  output$map <- renderLeaflet({

    filtered_data <- observations()
    req(filtered_data)

    # Center of the points
    center_lat <- mean(filtered_data$latitudeDecimal, na.rm = TRUE)
    center_lng <- mean(filtered_data$longitudeDecimal, na.rm = TRUE)
    
    leaflet() %>%
      addTiles() %>%
      clearMarkers() %>%
      setView(lng = center_lng, lat = center_lat, zoom = 6) %>% # adjust the view using the center of the points
      addCircleMarkers(
        data = filtered_data,
        lng = ~longitudeDecimal, 
        lat = ~latitudeDecimal ,
        radius = 5,
        color = "blue",
        popup = ~sprintf(
          "<b>Common name:</b> %s<br>
          <b>Scientific Name:</b> %s<br>
          <b>Individual Count:</b> %d<br>
          <img src='%s' width='100' height='100'>",
          vernacularName,
          scientificName,
          individualCount,
          accessURI
        ),
        layerId = ~id_unique
      )
    
  })
  
  

}

