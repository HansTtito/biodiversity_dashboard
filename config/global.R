library(shiny)
source('R/modules/process_country_module.R')

countries_list = gsub(pattern = '.parquet',replacement = '', x = list.files(path = 'data/countries'))


