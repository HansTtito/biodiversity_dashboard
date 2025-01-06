suppressWarnings(library(dplyr))
suppressWarnings(library(arrow))

source('R/modules/process_country_module.R')

SearchUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectizeInput(ns("search_country"), "Search country:", 
                   choices = NULL,
                   options = list(
                     placeholder = 'Type Country Name',
                     maxItems = 1
                   )),
    selectizeInput(ns("search_specie"), "Search species:", 
                   choices = NULL,
                   options = list(
                     placeholder = 'Type vernacular or scientific name',
                     maxItems = 1
                   )),
    actionButton(ns("searchBtn"), "Search", class = "btn btn-primary"),
    helpText("Enter a species name and click search to visualize observations.")
  )
}

searchModule <- function(input, output, session, country_list) {
  
  filtered_data_reactive <- reactiveVal(NULL)
  
  observe({
    updateSelectizeInput(session, "search_country", 
                         choices = country_list,
                         selected = 'Poland')
  })
  
  # Read country data
  country_data <- reactive({
    req(input$search_country)
    process_country(input$search_country) 
  })
  
  # Update species based on the country
  observeEvent(country_data(), {
    req(country_data())
    species_list <- unique(c('', country_data()$scientificName, country_data()$vernacularName))
    updateSelectizeInput(session, "search_specie", 
                         choices = species_list,
                         selected = '')
  })
  
  # filtering data using search btn
  observeEvent(input$searchBtn, {
    
    data <- country_data()
    req(data)
    searchTerm <- input$search_specie

    if (nchar(searchTerm) == 0 | searchTerm == "") {
      
      showModal(modalDialog(
        title = tags$div(style = "color: white; background-color: #333; padding: 10px; border-radius: 5px;", "Error"),
        tags$div(style = "color: white; background-color: #222; padding: 20px; border-radius: 5px;",
                 "You have to choose one species"),
        easyClose = TRUE,
        footer = NULL
      ))
      
      filtered_data_reactive(NULL)
      
      return(NULL)
      
    }
    
    req(searchTerm)
    
    filtered_data <- data %>%
      filter((scientificName == searchTerm | vernacularName == searchTerm)) %>%
      distinct(id, longitudeDecimal, latitudeDecimal, eventDate, scientificName, vernacularName, .keep_all = TRUE)
    
    filtered_data_reactive(filtered_data)
    
  })
  
  return(filtered_data_reactive)
  
}
