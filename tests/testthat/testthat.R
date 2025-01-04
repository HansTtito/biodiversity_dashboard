
library(testthat)
library(shiny)
source('R/modules/search_module.R')
source('R/modules/map_module.R')
source('R/modules/process_country_module.R')
source('R/modules/timeline_module.R')

source('config/global.R')
source('R/server.R')



test_that("Search module filters data correctly", {

  testServer(server, {
    session$setInputs(
      search_country = "Poland",
      search_specie = "Chub",
      searchBtn = TRUE
    )

    filtered_data <- filtered_data_reactive()

    expect_true(all(filtered_data$country == "Poland"))
    expect_true(all(filtered_data$vernacularName == "Chub"))

  })
})



