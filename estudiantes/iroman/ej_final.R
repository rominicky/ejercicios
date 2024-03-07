#Cargo las librerías, previamente instaladas, que voy a usar.
library(rvest) 
library(httr)
library(dplyr)
library(stringr)

#Siguiendo el código em https://github.com/rominicky/ro_dl/blob/main/assets/scrapping-ejemplo.R ubico datos de interés y los descargo en un data frame.
link <- "https://es.wikipedia.org/wiki/Anexo:Provincias_de_Argentina"
page <- read_html(link)
htmlElement <- page %>% html_node("table.sortable") 
dfProv <- html_table(htmlElement, header = FALSE)
dfProv <- as.data.frame(dfProv)

#No hace falta usar XPath voy directo a la tabla vía "class", Borro el header de la tabla.

names(dfProv) <- dfProv[2,]
dfProv <- dfProv[-c(1,2), ]

#Borro las dos primeras columnas.

nuevos_titulos <- c("Provincia", "Bandera", "Escudo", "Capital", "Gobernador", "IATA", "ISO", "Poblacion", "Superficie", "Densidad", "Departamentos", "Gobiernos locales", "Autonomia", "INDEC", "Mapa")
names(dfProv) <- nuevos_titulos

#Cambio los títulos de las columnas.

dfProv <- dfProv %>% select(-Bandera, -Escudo, -Mapa, -Autonomia, -'Gobiernos locales', -Mapa)
dfProv$Provincia <- gsub("Provincia del |Provincia de ", "", dfProv$Provincia)
dfProv$Provincia <- str_replace_all(dfProv$Provincia, "Tierra del Fuego, Antártida e Islas del Atlántico Sur", "Tierra del Fuego")

#Modifico el nombre de Tierra del Fuego en la base de Wikipedia para evitar conflictos con rnaturalearth al momento de graficar el ejercicio.

dfProv <- dfProv %>%
  mutate_at(vars(Poblacion, Superficie, Densidad), ~ as.numeric(gsub("\\[.*?\\]|[^0-9]", "", ., perl = TRUE)))
#Limpio los datos y reduzco la cantidad de columnas.

library(ggplot2)
library(sf)
library(rnaturalearth)

# Cargo las librerías para la visualización. Investigué sober rnaturalearth para obtener el gráfico.

argentina <- ne_states(country = "argentina", returnclass = "sf")
dfProvMap <- merge(argentina, dfProv, by.x = "name", by.y = "Provincia")

#Junto los datos de la librería con los nombres de las provincias.

ggplot() +
  geom_sf(data = dfProvMap, aes(fill = Densidad)) +
  scale_fill_viridis_c(option = "plasma", name = "Densidad Poblacional") +
  theme_minimal() +
  labs(title = "República Argentina",
       caption = "Información obtenida del Censo 2022") +
  theme(legend.position = "bottom", axis.text = element_blank(), axis.title = element_blank())
