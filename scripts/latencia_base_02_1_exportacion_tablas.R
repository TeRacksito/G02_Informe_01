# Cabecera =====================================================================
# Tarea: Analizar Latencia Base
# Script 02_1: Exportar tablas estilizadas.
# Autor: Angel Krasimirov Stoyanov
# 
# Intentar exportar png estilizado de las tablas que genera el script
# `latencia_base_02_medidas_y_estadisticos.R`.
#
# Entradas esperadas:
# - data/processed/latencia_base_02_tabla_med_centrales.RData
# - data/processed/latencia_base_02_tabla_med_dispersion.RData
# - data/processed/latencia_base_02_vectores_med_posicion.RData
# - data/processed/latencia_base_02_tabla_med_forma.RData
# 
# Salidas:
# - outputs/latencia_base_02_tabla_med_centrales.png
# - outputs/latencia_base_02_tabla_med_dispersion.png
# - outputs/latencia_base_02_tabla_cuartiles.png
# - outputs/latencia_base_02_tabla_deciles.png
# - outputs/latencia_base_02_tabla_percentiles.png
# - outputs/latencia_base_02_tabla_med_forma.png
# ______________________________________________________________________________

rm(list = ls())

# ==== Librerías ====

library(here)
library(knitr)
library(kableExtra)

# ==== Funciones externas ====

source(here("scripts", "Utilidades.R"))

# ==== Script ====

# verificar outputs
outputs_dir <- here::here("outputs")
if (!dir.exists(outputs_dir)) {
  dir.create(outputs_dir, recursive = TRUE, showWarnings = FALSE)
}

# cargar dataframe `tabla_med_centrales`
path_tabla_med_centrales <- here::here("data", "processed", "latencia_base_02_tabla_med_centrales.RData")
if (!file.exists(path_tabla_med_centrales)) {
  stop(paste("ERROR: Se esperaba:", path_tabla_med_centrales))
}
load(path_tabla_med_centrales)

h("Tabla de medidas de tendencia central")
print(tabla_med_centrales)

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
cat0("Cuartiles:\n")
print(round(cuartiles, 3))
cat0("\nDeciles:\n")
print(round(deciles, 3))
cat0("\nPercentiles (P5, P90, P95):\n")
print(round(percentiles_interesantes, 3))

# cargar dataframe `tabla_med_forma`
path_tabla_med_forma <- here::here("data", "processed", "latencia_base_02_tabla_med_forma.RData")
if (!file.exists(path_tabla_med_forma)) {
  stop(paste("ERROR: Se esperaba:", path_tabla_med_forma))
}
load(path_tabla_med_forma)

h("Tabla de medidas de forma")
print(tabla_med_forma)

# ==== Exportar - Med Tendencia Central ====

colnames(tabla_med_centrales) <- c(
  "Media Agrupada (ms)",
  "Media (ms)",
  "Mediana (ms)",
  "Moda (ms)",
  "Intervalo Modal"
)

exportar_tabla(
  tabla_med_centrales,
  here::here("outputs", "latencia_base_02_tabla_med_centrales.png"),
  "Medidas de Tendencia Central"
)

# ==== Exportar - Med Dispersión ====

# finalmente no vamos a incluir las cuasi-
tabla_med_dispersion$cuasivarianza <- NULL
tabla_med_dispersion$cuasidesviacion <- NULL

tabla_med_dispersion$cv_pearson <- round(tabla_med_dispersion$cv_pearson * 100, 3)

colnames(tabla_med_dispersion) <- c(
  "Varianza (S<sup>2</sup>)",
  "Desv. Típica (S)",
  "Cv de Pearson (%)",
  "Rango",
  "IQR"
)

exportar_tabla(
  tabla_med_dispersion,
  here::here("outputs", "latencia_base_02_tabla_med_dispersion.png"),
  "Medidas de Dispersión"
)

# ==== Exportar - Med Posición ====

cuartiles_frame <- as.data.frame(
  t(round(cuartiles, 3)),
  check.names = FALSE
)

colnames(cuartiles_frame) <- c(
  "Q<sub>1</sub> (P25)(ms)",
  "Q<sub>2</sub> (P50)(ms)",
  "Q<sub>3</sub> (P75)(ms)"
)

exportar_tabla(
  cuartiles_frame,
  here::here("outputs", "latencia_base_02_tabla_cuartiles.png"),
  "Cuartiles"
)

deciles_frame <- as.data.frame(
  t(round(deciles, 3)),
  check.names = FALSE
)

colnames(deciles_frame) <- c(
  "P10 (ms)",
  "P20 (ms)",
  "P30 (ms)",
  "P40 (ms)",
  "Q<sub>2</sub> (P50)(ms)",
  "P60 (ms)",
  "P70 (ms)",
  "P80 (ms)",
  "P90 (ms)"
)

exportar_tabla(
  deciles_frame,
  here::here("outputs", "latencia_base_02_tabla_deciles.png"),
  "Deciles"
)

percentiles_frame <- as.data.frame(
  t(round(percentiles_interesantes, 3)),
  check.names = FALSE
)

colnames(percentiles_frame) <- c(
  "P05 (ms)",
  "P90 (ms)",
  "P95 (ms)"
)

exportar_tabla(
  percentiles_frame,
  here::here("outputs", "latencia_base_02_tabla_percentiles.png"),
  "Percentiles Interesantes"
)

# ==== Exportar - Med Forma ====

colnames(tabla_med_forma) <- c(
  "Asimetría (A<sub>F</sub>)",
  "Curtosis (g<sub>2</sub>)"
)

exportar_tabla(
  tabla_med_forma,
  here::here("outputs", "latencia_base_02_tabla_med_forma.png"),
  "Medidas de Forma"
)
