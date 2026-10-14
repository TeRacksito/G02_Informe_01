# Cabecera =====================================================================
# Tarea: Analizar Latencia Base
# Script 04_1: Exportar tablas estilizadas.
# Autor: Angel Krasimirov Stoyanov
#
# Intentar exportar png estilizado de las tablas que genera el script
# `latencia_base_04_cuestiones.R`.
#
# Entradas esperadas:
# - data/processed/latencia_base_04_tabla_atipicos.RData
# - data/processed/latencia_base_04_tabla_comparacion.RData
#
# Salidas:
# - outputs/latencia_base_04_tabla_atipicos.png
# - outputs/latencia_base_04_tabla_comparacion.png
# ______________________________________________________________________________

rm(list = ls())

## @knitr dependencias
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

# cargar dataframe `tabla_atipicos`
path_tabla_atipicos <- here::here("data", "processed", "latencia_base_04_tabla_atipicos.RData")
if (!file.exists(path_tabla_atipicos)) {
  stop(paste("ERROR: Se esperaba:", path_tabla_atipicos))
}
load(path_tabla_atipicos)

# cargar dataframe `tabla_comparacion`
path_tabla_comparacion <- here::here("data", "processed", "latencia_base_04_tabla_comparacion.RData")
if (!file.exists(path_tabla_comparacion)) {
  stop(paste("ERROR: Se esperaba:", path_tabla_comparacion))
}
load(path_tabla_comparacion)

# ==== Exportar - Tabla de valores atípicos ====

## @knitr exportar_tabla_atipicos

tabla_kbl <- exportar_tabla(
  atipicos_frame_top3,
  here::here("outputs", "latencia_base_04_tabla_atipicos.png"),
  "Tabla de los tres valores atípicos más extremos de Latencia Base"
)

# ==== Exportar - Tabla de comparación ====

## @knitr exportar_tabla_comparacion

colnames(tabla_comparacion) <- c(
  "Métrica",
  "Latencia Sin Caché",
  "Latencia Con Caché",
  "Mejora (%)"
)

tabla_kbl <- exportar_tabla(
  tabla_comparacion,
  here::here("outputs", "latencia_base_04_tabla_comparacion.png"),
  "Tabla de comparación de Latencia Base con Latencia Posterior"
)
