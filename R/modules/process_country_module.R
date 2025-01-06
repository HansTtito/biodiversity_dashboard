suppressWarnings(library(arrow))

process_country <- function(country_name) {
  
  parquet_file <- paste0("data/countries/", country_name, ".parquet")
  
  full_data = read_parquet(file = parquet_file)
  
  return(full_data)
  
}

