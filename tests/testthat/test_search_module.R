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


test_that("searchModuleServer handles basic search functionality", {
  # Mock the process_country function in the test environment
  testthat::with_mock(
    "process_country" = mock_process_country,
    {
      testServer(searchModuleServer, args = list(country_list = countries_list), {
        # Test initial state
        expect_null(session$getReturned()())
        
        # Test country selection and search
        session$setInputs(
          search_country = "Poland",
          search_specie = "Specie1",
          searchBtn = TRUE
        )
        
        # Get the reactive result
        result <- session$getReturned()()
        
        # Verify results
        expect_false(is.null(result))
        expect_equal(nrow(result), 1)
        expect_equal(result$scientificName, "Specie1")
      })
    }
  )
})



test_that("searchModuleServer handles empty species selection", {

  testthat::with_mock(
    "process_country" = mock_process_country,
    {
      testServer(searchModuleServer, args = list(country_list = countries_list), {
        # Test empty species search
        session$setInputs(
          search_country = "Poland",
          search_specie = "",
          searchBtn = 1
        )
        
        # Verify null result for empty search
        expect_null(session$getReturned()())
      })
    }
  )
})

