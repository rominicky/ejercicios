# Este es un script de prueba

# Limpiamos el entorno
rm(list = ls())

# Obtenemos nuestra ubicación actual
getwd()

# Instalamos los paquetes necesarios si no están instalados
install.packages("tidyverse")
install.packages("rvest")
install.packages("stringr")

# Cargamos los paquetes necesarios
library(tidyverse)
library(rvest)
library(stringr)

# Definimos la URL base para hacer scraping de un sitio web
base_url <- "https://listado.mercadolibre.com.ar/canastas-basicas-pascuas#D[A:canastas%20basicas%20pascuas]"

# Leemos el contenido HTML de la página web
webpage <- read_html(base_url)

# Extraemos el texto de los elementos HTML que tienen la clase ".ui-search-item__title"
cajass <- html_nodes(webpage, ".ui-search-item__title")
cajass <- as.character(html_text(cajass))
cajass

# Filtramos las cajas que contienen la palabra "Pascuas"
cajass_filtradas <- cajass[grep("Pascuas|Pascua|pascua|pascuas", cajass)]


# Creamos un vector con la longitud de cajass y cajass_filtradas
longitud <- c(length(cajass), length(cajass_filtradas))

# Creamos un gráfico de torta con los datos
pie(longitud,
    labels = c("Total de cajas", "Cajas de Pascuas"),
    main = "Comparación entre total de cajas y cajas de pascuas",
    col = c("steelblue", "lightblue"))


