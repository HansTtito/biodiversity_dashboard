
server <- function(input, output, session) {

  filtered_data_reactive <- searchModuleServer('search')
  
  mapModuleServer('map_or_message', observations = filtered_data_reactive)
  
  timelineModuleServer('timeline_or_message', observations = filtered_data_reactive)
  
}
