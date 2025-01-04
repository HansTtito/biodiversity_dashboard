# Shiny Biodiversity Visualization App

## Descripción

Esta aplicación Shiny permite visualizar observaciones de especies de biodiversidad en Polonia. Los usuarios pueden buscar especies por su nombre vulgar o científico, y luego visualizar sus observaciones en un mapa interactivo. También pueden explorar una línea de tiempo que muestra cuándo fueron observadas las especies seleccionadas.

El proyecto utiliza datos de la Global Biodiversity Information Facility (GBIF) y está diseñado para ser una herramienta interactiva, fácil de usar y optimizada para grandes volúmenes de datos.

## Requisitos Técnicos

- **R** (versión 4.0 o superior)
- **Shiny**: Para la creación de la aplicación web interactiva.
- **leaflet**: Para visualizar las observaciones de especies en un mapa.
- **dplyr**: Para el procesamiento de los datos.
- **plotly**: Para la visualización de la línea de tiempo de observaciones.

## Instalación

1. Clona el repositorio en tu máquina local:

```bash
   git clone https://github.com/HansTtito/appsilon_test.git
```

Uso
- Búsqueda de Especies: Los usuarios pueden buscar especies utilizando su nombre común o científico en el campo de búsqueda. A medida que escriben, se mostrarán resultados coincidentes.
- Visualización en el Mapa: Una vez seleccionada una especie, la aplicación mostrará las observaciones de la especie en un mapa interactivo, con los puntos representando las ubicaciones de las observaciones.
- Línea de Tiempo de Observaciones: Al seleccionar una especie, se generará una línea de tiempo que muestra las fechas en los que las observaciones fueron registradas.

## Estructura del Proyecto

### El proyecto está organizado de la siguiente manera:

- ui.R: Contiene la interfaz de usuario de la aplicación.
- server.R: Contiene la lógica de servidor de la aplicación.
- modules: Carpeta que contiene los módulos de Shiny para descomponer funcionalidades independientes (por ejemplo, búsqueda de especies, visualización del mapa).
- data: Carpeta que contiene los datos procesados y cualquier archivo adicional que se utilice en la aplicación.
- tests: Carpeta que contiene pruebas unitarias para las funciones clave.
- README.md: Este archivo, que proporciona una descripción del proyecto y cómo usarlo.

### Funcionalidades

- Búsqueda de Especies: Los usuarios pueden buscar especies por su nombre vulgar o científico, y los resultados se actualizan dinámicamente.
- Visualización en el Mapa: Utiliza leaflet para mostrar las observaciones geolocalizadas en un mapa interactivo.
- Línea de Tiempo: Muestra una línea de tiempo con las observaciones de la especie seleccionada.
- Optimización: Se han implementado técnicas para asegurar que la aplicación se cargue rápidamente, incluso con grandes conjuntos de datos.

### Módulos

La aplicación está organizada utilizando módulos de Shiny para mejorar la modularidad y reutilización del código. Los módulos incluyen:

- module_search_species.R: Módulo para manejar la búsqueda de especies.
- module_map.R: Módulo para la visualización del mapa.
- module_timeline.R: Módulo para generar la línea de tiempo de las observaciones.
