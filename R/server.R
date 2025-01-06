
server <- function(input, output, session) {

  filtered_data_reactive <- callModule(searchModule, "search", country_list = countries_list)
  
  callModule(mapModule, "map_or_message", observations = filtered_data_reactive)
  
  callModule(timelineModule, "timeline_or_message", observations = filtered_data_reactive)
  
}
