library(shinytest2)
library(testthat)
library(tibble)
library(dplyr)
library(mockery)
library(shiny)
library(here)

source(here("config", "global.R"))
source(here("R","modules", "process_country_module.R"))
source(here("R","modules", "search_module.R"))


mock_process_country <- function(country_name) {
  if (country_name == "Poland") {
    tibble(
      scientificName = c("Specie1", "Specie2", "Specie3"),
      vernacularName = c("CommonName1", "CommonName2", "CommonName3"),
      id = 1:3,
      longitudeDecimal = c(10.1, 20.2, 30.3),
      latitudeDecimal = c(50.5, 60.6, 70.7),
      eventDate = as.Date(c("2023-01-01", "2023-01-02", "2023-01-03"))
    )
  } else if (country_name == "Germany") {
    tibble(
      scientificName = c("SpecieA", "SpecieB", "SpecieC"),
      vernacularName = c("CommonNameA", "CommonNameB", "CommonNameC"),
      id = 4:6,
      longitudeDecimal = c(40.4, 50.5, 60.6),
      latitudeDecimal = c(80.8, 90.9, 100.1),
      eventDate = as.Date(c("2023-02-01", "2023-02-02", "2023-02-03"))
    )
  } else {
    tibble(
      scientificName = character(),
      vernacularName = character(),
      id = integer(),
      longitudeDecimal = numeric(),
      latitudeDecimal = numeric(),
      eventDate = as.Date(character())
    )
  }
}


test_that("searchModuleServer updates data when country changes", {
  testthat::with_mock(
    "process_country" = mock_process_country,
    {
      testServer(searchModuleServer, {
        # Selección inicial: "Poland"
        session$setInputs(
          search_country = "Poland",
          search_specie = "Specie1",
          searchBtn = 1
        )
        
        # Verificar resultados para "Poland"
        result <- session$getReturned()()
        expect_false(is.null(result))
        expect_equal(nrow(result), 1)
        expect_equal(result$scientificName, "Specie1")
        
        # Cambio a "Germany"
        session$setInputs(
          search_country = "Germany",
          search_specie = "SpecieA",
          searchBtn = 1
        )
        
        # Verificar resultados para "Germany"
        result <- session$getReturned()()
        expect_false(is.null(result))
        expect_equal(nrow(result), 1)
        expect_equal(result$scientificName, "SpecieA")
      })
    }
  )
})



test_that("searchModuleServer handles empty species selection", {

  testthat::with_mock(
    "process_country" = mock_process_country,
    {
      testServer(searchModuleServer, {
        session$setInputs(
          search_country = "Poland",
          search_specie = "",
          searchBtn = 1
        )
        
        expect_null(session$getReturned()())
      })
    }
  )
})


test_that("searchModuleServer updates species list correctly", {
  
  testthat::with_mock(
    "process_country" = mock_process_country,
    
    "updateSelectizeInput" = function(session, inputId, choices, selected, server) {
      expect_equal(inputId, "search_specie")
      expect_setequal(choices, c("", "SpecieA", "SpecieB", "SpecieC", "CommonNameA", "CommonNameB", "CommonNameC"))
      expect_equal(selected, "")
    },
    
    {
      testServer(searchModuleServer, {
        session$setInputs(search_country = "Germany")
        session$flushReact()
      })
    }
  )
})



