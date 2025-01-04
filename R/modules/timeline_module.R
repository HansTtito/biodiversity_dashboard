suppressWarnings(library(plotly))
library(lubridate)

timelineModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    plotlyOutput(ns("timeline"), height = "600px")
  )
}

timelineModule <- function(input, output, session, observations) {
  
  ns <- session$ns
  
  observe({
    req(observations())
    
    # Processing data
    filtered_data <- observations() %>%
      mutate(observationDate = ymd(eventDate))%>%
      reframe(individualCount = sum(individualCount, na.rm = TRUE), .by = c(observationDate, scientificName))
    
    species_name <- ifelse(
      all(is.na(filtered_data$scientificName)), 
      unique(filtered_data$vernacularName), 
      unique(filtered_data$scientificName)
    )
    
    # Time line plot
    output$timeline <- renderPlotly({
      
      req(filtered_data)
      
      library(plotly)
      
      plot_ly(
        filtered_data, 
        x = ~factor(observationDate), 
        y = ~individualCount, 
        type = "bar",
        hovertext = ~paste("Day: ", observationDate, "<br>Occurrence: ", individualCount),
        hoverinfo = "text",
        marker = list(
          color = 'rgba(0, 123, 255, 0.7)', 
          line = list(color = 'black', width = 1)
        )
      ) %>%
        layout(
          title = list(
            text = paste("Observation Timeline for", species_name),
            font = list(
              size = 24,
              color = "darkblue",
              family = "Arial, sans-serif"
            ),
            y = 0.97
          ),
          xaxis = list(title = "Date"),
          yaxis = list(title = "Observation Count"),
          bargap = 0.2
        )
      
      
    })
  })
}
