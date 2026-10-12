# Cabecera =====================================================================
# Tarea: Analizar Latencia Base
# Script 03: Generación de Diagramas.
# Autor: Angel Krasimirov Stoyanov
# 
# Queremos generar diagramas útiles para Lat_Base. Inicialmente: Histograma,
# Boxplot, Diagrama de frecuencias acumuladas.
#
# Entradas esperadas:
# - data/processed/Cloud_Performance_procesado.RData
# - data/processed/latencia_base_01_tabla_frecuencias.RData
# - data/processed/latencia_base_01_vectores_otros.RData
# - data/processed/latencia_base_02_tabla_med_dispersion.RData
# - data/processed/latencia_base_02_vectores_med_posicion.RData
# 
# Salidas:
# - outputs/latencia_base_03_histograma_poligono.png
# - outputs/latencia_base_03_boxplot.png
# - outputs/latencia_base_03_cumfreq.png
# ______________________________________________________________________________

rm(list = ls())

# ==== Librerías ====

library(here)
library(DescTools)
library(e1071)

# ==== Funciones externas ====

source(here("scripts", "Utilidades.R"))

# ==== Script ====

# cargar dataframe datos_cloud
path_datos <- here::here("data", "processed", "Cloud_Performance_procesado.RData")
if (!file.exists(path_datos)) {
  stop(paste("ERROR: Se esperaba:", path_datos))
}
load(path_datos)
lat_base <- datos_cloud$Lat_Base

h("Dataframe")
str(datos_cloud)

# cargar dataframe tabla_frec (tabla_frec_reagr_frame)
path_tabla_frec <- here::here("data", "processed", "latencia_base_01_tabla_frecuencias.RData")
if (!file.exists(path_datos)) {
  stop(paste("ERROR: Se esperaba:", path_tabla_frec))
}
load(path_tabla_frec)
tabla_frec <- tabla_frec_reagr_frame
rm(tabla_frec_reagr_frame)

h("Tabla de distribución de frecuencias")
print(tabla_frec)

# cargar vectores: `breaks_reagr`
path_vectores <- here::here("data", "processed", "latencia_base_01_vectores_otros.RData")
if (!file.exists(path_vectores)) {
  stop(paste("ERROR: Se esperaba:", path_vectores))
}
load(path_vectores)

cat("\nCortes de Intervalos: ", breaks_reagr, "\n")

# cargar dataframe `tabla_med_dispersion`
path_tabla_med_dispersion <- here::here("data", "processed", "latencia_base_02_tabla_med_dispersion.RData")
if (!file.exists(path_tabla_med_dispersion)) {
  stop(paste("ERROR: Se esperaba:", path_tabla_med_dispersion))
}
load(path_tabla_med_dispersion)

h("Tabla de medidas de dispersión")
print(tabla_med_dispersion)

# cargar vectores `cuartiles`, `deciles`, `percentiles_interesantes` y `percentiles`
path_med_posicion <- here::here("data", "processed", "latencia_base_02_vectores_med_posicion.RData")
if (!file.exists(path_med_posicion)) {
  stop(paste("ERROR: Se esperaba:", path_med_posicion))
}
load(path_med_posicion)
cat0("\nCuartiles:\n")
print(round(cuartiles, 3))
cat0("\nDeciles:\n")
print(round(deciles, 3))
cat0("\nPercentiles (P5, P90, P95):\n")
print(round(percentiles_interesantes, 3))

# ==== Histograma ====

path_hist <- here::here("outputs", "latencia_base_03_histograma_poligono.png")
png(path_hist, width = 850, height = 600, res = 100)

h <- hist(
  lat_base,
  breaks = breaks_reagr,
  freq = FALSE,
  col = "#C39BD3",
  border = "#5C068C",
  xaxt = "n",
  xlab = "Latencia Base del Servidor (ms)",
  ylab = "Densidad de Frecuencia",
  main = "Histograma de Latencia Base con Polígono de Frecuencias"
)

x <- c(min(breaks_reagr), h$mids, max(breaks_reagr))
y <- c(0, h$density, 0)

lines(x, y, col = "#5C068C", lwd = 2.5, type = "b", pch = 19)
axis(side = 1, at = round(breaks_reagr, 1))
dev.off()
cat("Se ha generado el fichero: ", path_hist, "\n")

# ==== Boxplot ====

path_box <- here::here("outputs", "latencia_base_03_boxplot.png")
png(path_box, width = 850, height = 600, res = 100)

boxplot(
  lat_base,
  col = "#C39BD3",
  border = "#5C068C",
  range = 1.5,
  ylab = "Latencia Base (ms)",
  main = "Diagrama de Caja y Patillas de Latencia Base"
)

cuartil_q3 <- cuartiles[["75%"]]
limite_superior <- cuartil_q3 + 1.5 * tabla_med_dispersion$iqr

abline(h = limite_superior, col = "red", lty = 2, lwd = 2)

dev.off()
cat("Se ha generado el fichero: ", path_box, "\n")

# ==== Polígono de frecuencias acumuladas ====

path_cumfreq <- here::here("outputs", "latencia_base_03_cumfreq.png")
png(path_cumfreq, width = 850, height = 600, res = 100)

x <- breaks_reagr
y <- c(0, tabla_frec$N_i)

plot(
  x, y,
  type = "b",
  xaxt = "n",
  yaxt = "n",
  pch = 19,
  col = "#5C068C",
  lwd = 2.5,
  main = "Polígono de Frecuencias Acumuladas",
  xlab = "Límites Superiores de Clase (ms)",
  ylab = "Frecuencia Absoluta Acumulada"
)

axis(side = 1, at = round(breaks_reagr, 1))
axis(side = 2, at = y)

dev.off()
cat("Se ha generado el fichero: ", path_cumfreq, "\n")
