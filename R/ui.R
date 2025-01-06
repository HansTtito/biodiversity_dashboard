source("R/modules/map_module.R")
source("R/modules/timeline_module.R")
source("R/modules/search_module.R")

ui <- fluidPage(
  ## features
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js")
  ),
  
  # title panel
  div(class = "title-panel",
      h2("Biodiversity Dashboard")
  ),
  
  # Main container
  div(class = "container-fluid p-0",
      div(class = "row g-0",
          div(class = "col-12 main-content",
              
              # Search container
              div(class = "card search-container collapsed",
                  div(class = "drag-handle",
                      tags$i(class = "fas fa-grip-horizontal me-2"),
                      "Drag to move"
                  ),
                  
                  div(class = "collapse-button",
                      tags$i(class = "fas fa-chevron-down")
                  ),
                  
                  div(class = "search-content", style = "display: none;",
                      SearchUI("search")
                  )
              ),
              
              # Map Container
              div(class = "card map-container",
                  div(id = "map-container",
                      mapModuleUI("map_or_message")
                  )
              ),
              
              # Timeline container
              
              div(class = "card timeline-container",
                  timelineModuleUI("timeline_or_message")
              )
          )
      )
  ),
  
  tags$script(HTML("
    $(document).ready(function() {
      // Initialize draggable
      $('.search-container').draggable({
        handle: '.drag-handle',
        containment: 'window',
        start: function(event, ui) {
          // Remove the transform when starting to drag
          $(this).css('transform', 'none');
          $(this).css('left', ui.position.left + 'px'); // Añadimos posición explícita
        }
      });
      
      // Collapse functionality
      $('.collapse-button').click(function() {
        var container = $(this).closest('.search-container');
        var content = container.find('.search-content');
        var icon = $(this).find('i');
        
        content.slideToggle(300, function() {
          if (content.is(':visible')) {
            icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
            container.removeClass('collapsed');
          } else {
            icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
            container.addClass('collapsed');
          }
        });
      });
    });
  "))
)