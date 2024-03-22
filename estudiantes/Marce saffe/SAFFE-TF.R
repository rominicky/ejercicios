En este script utilice datos de 
temperatura y humedad determinadas en un excel
del archivo de la facultad donde trabajo
attach(TABLA)
names(TABLA)
library(tidyverse)
library(lubridate)
plot(TABLA)
plot(`Temperatura 10 h.`)
plot(`Temperatura 17 h.`)
ggplot(`Temperatura 10 h.`)
ggplot(`HR10 h.`)
library(ggplot2)