# Shiny Biodiversity Visualization App

## Description

This Shiny app allows the visualization of biodiversity species observations in Poland. Users can search for species by their common or scientific name, and then view their observations on an interactive map. They can also explore a timeline showing when the selected species were observed.

The project uses data from the Global Biodiversity Information Facility (GBIF) and is designed to be an interactive, user-friendly tool optimized for handling large datasets.

## Technical Requirements

- **R** (version 4.0 or higher)
- **Shiny**: For creating the interactive web app.
- **leaflet**: For visualizing species observations on a map.
- **dplyr**: For data processing.
- **plotly**: For visualizing the observation timeline.

## Installation

1. Clone the repository to your local machine:

```bash
   git clone https://github.com/HansTtito/appsilon_test.git
```

2. Run the app directly in R

```bash
   shiny::runApp()
```


## Usage

- Species Search: Users can search for species using their common or scientific name in the search field. As they type, matching results will be displayed.
- Map Visualization: Once a species is selected, the app will display the species' observations on an interactive map, with points representing the locations of the observations.
- Observation Timeline: Upon selecting a species, a timeline will be generated showing the dates when the observations were recorded.

## Project Structure

### The project is organized as follows:

- ui.R: Contains the user interface of the app.
- server.R: Contains the server logic of the app.
- modules: Folder containing Shiny modules to break down independent functionalities (e.g., species search, map visualization).
- data: Folder containing processed data used in the app.
- tests: Folder containing unit tests for key functions.
- README.md: This file, which provides a description of the project and instructions on how to use it.

### Features

- Species Search: Users can search for species by their common or scientific name, and the results are updated dynamically.
- Map Visualization: Uses leaflet to display geolocated observations on an interactive map.
- Timeline: Displays a timeline with observations of the selected species.
- Optimization: Techniques have been implemented to ensure the app loads quickly, even with large datasets.

### Modules

The app is organized using Shiny modules to improve code modularity and reusability. The modules include:

- search_module.R: Module for handling species search.
- map_module.R: Module for visualizing the map.
- timeline_module.R: Module for generating the observation timeline.
- process_country_module.R: Module for finding the database to be used in the app.
