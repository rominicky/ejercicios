#1. Cargamos las librerías. Leemos la base de datos
library(readr) 
library(tidyverse)

#dataURL <- "https://www.argentina.gob.ar/sites/default/files/2023_generales.zip"
#temp <- file.path(getwd(), filename)
#filename <- "2023_generales.zip"
#download.file(dataURL, destfile = temp, mode = 'wb', quiet = TRUE)
#unzip("2023_generales.zip")
#setwd("2023_generales/")

read.csv("ResultadosElectorales_2023.csv")
elec_2023 <- data.frame(read_csv("ResultadosElectorales_2023.csv"))

#2. Utilizamos algunas de las funciones exploratorias propuestas
summary(elec_2023)
dim(elec_2023)

any(is.na(elec_2023))

head(elec_2023, n = 20)
tail(elec_2023, n = 20)

#3. Describimos brevemente la base de datos (tip tiene NAs? podemos describir estadisticamente alguna columna?)

#Votos solo a presidente y simplifico nombres de columnas

elec_datos_raw <- elec_2023 %>%
  select(distrito = distrito_nombre, mesa = mesa_electores, cargo = cargo_nombre, agrupacion = agrupacion_nombre, tipo = votos_tipo, cant = votos_cantidad) %>%
  arrange(distrito, agrupacion, cargo, cant, tipo) %>%
  filter(cargo == 'PRESIDENTE Y VICE', cant > 0) %>%
  group_by(distrito, agrupacion, cargo, cant, tipo)

#Votos a presidente no positivos total por distrito

elec_datos_blanco <- elec_datos_raw %>%
  filter(tipo != 'POSTIVO') %>%
  group_by(distrito) %>%
  summarise(cant_total = sum(cant))%>%
  arrange(desc(cant_total))

#4. Extraemos todos los registros de algunas columnas. Guardarlo en un nuevo dataframe.

#Votos totales a presidente por agrupación, con porcentajes y agrupando no positivos

elec_datos <- elec_datos_raw %>%
  group_by(agrupacion) %>%
  summarise(cant_total = sum(cant)) %>%
  mutate_all(~ifelse(is.na(.), "VOTO EN BLANCO/NULO", .)) %>%
  mutate(agrupacion = ifelse(agrupacion == "FRENTE DE IZQUIERDA Y DE TRABAJADORES - UNIDAD", "FRENTE DE IZQUIERDA", agrupacion))%>%
  arrange(desc(cant_total)) %>%
  mutate(porc = (cant_total / sum(cant_total)) * 100) %>%
  group_by(agrupacion) %>%
  summarise(cant_total = sum(cant_total), porc = sum(porc))%>%
  arrange(desc(cant_total)) %>%
  mutate(agrupacion = factor(agrupacion, levels = agrupacion))

#5. Exportaremos el dataFrame como un archivo .csv

write.csv(elec_datos, "elecciones.csv")

#6. Podrías realizar algunos gráficos con los datos obtenidos, cómo lo harías?

ggplot(elec_datos, aes(x = "", y = cant_total, fill = agrupacion)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y", start = 0) + 
  scale_fill_manual(values = gray.colors(length(unique(elec_datos$agrupacion)))) +
  theme_void() +
  ggtitle(".  RESULTADOS TOTAL PAIS:") + 
  guides(fill = guide_legend(title = NULL)) 
