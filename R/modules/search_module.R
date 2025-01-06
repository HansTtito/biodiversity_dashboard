library(shiny)
suppressWarnings(library(dplyr))


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
    req(searchTerm)
    
    if (nchar(searchTerm) == 0 | searchTerm == '') {
      filtered_data_reactive(NULL)
      return(NULL)
    }
    
    filtered_data <- data %>%
      filter(grepl(searchTerm, scientificName, ignore.case = TRUE) | 
               grepl(searchTerm, vernacularName, ignore.case = TRUE)) %>%
      distinct(id, longitudeDecimal, latitudeDecimal, eventDate, scientificName, vernacularName, .keep_all = TRUE)
    
    if (nrow(filtered_data) < 1) {
      showModal(modalDialog(
        title = "Error",
        "Specie not found in that Country",
        easyClose = TRUE,
        footer = NULL
      ))
      return(NULL)
    }
    
    filtered_data_reactive(filtered_data)
  })
  
  return(filtered_data_reactive)
}
