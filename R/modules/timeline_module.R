suppressWarnings(library(lubridate))
suppressWarnings(library(plotly))


timelineModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("timeline_or_message"), height = "600px")
  )
}


timelineModuleServer <- function(id, observations) {
  
  moduleServer(
    id,
    
    function(input, output, session) {
      
      ns <- session$ns
      
      output$timeline_or_message <- renderUI({
        
        if (is.null(observations()) || nrow(observations()) == 0) {
          div(
            style = "height: 600px; display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #2c3e50;",
          )
          
        } else {
          
          tagList(
            h2(paste0("Observation Timeline for ", unique(observations()$scientificName)), style = "color: white; text-align: center;"),
            plotlyOutput(ns("timeline"), height = "600px")
          )
        }
      })
      
      observe({
        
        req(observations())
        
        # Procesamiento de datos
        filtered_data <- observations() %>%
          mutate(observationDate = ymd(eventDate)) %>%
          reframe(individualCount = sum(individualCount, na.rm = TRUE), .by = c(observationDate, scientificName))
        
        if (nrow(filtered_data) == 0) {
          output$timeline <- NULL # Ocultar el gráfico si no hay datos
          return(NULL)
        }
        
        # Gráfico de la línea de tiempo
        output$timeline <- renderPlotly({
          
          req(filtered_data)
          
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
                text = "",
                font = list(size = 16, color = "transparent"),
                y = 0.97,
                x = 0.5,
                xanchor = "center",
                yanchor = "top"
              ),
              xaxis = list(title = "Date"),
              yaxis = list(title = "Observation Count"),
              bargap = 0.2
            ) 
        })
        
        
      })
    }
    
    
  )
  
}
  
  
