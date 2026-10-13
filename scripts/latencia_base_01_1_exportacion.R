# Cabecera =====================================================================
# Tarea: Analizar Latencia Base
# Script 01_1: Exportar tabla de frecuencias estilizada
# Autor: Angel Krasimirov Stoyanov
# 
# Intentar exportar png estilizado de la tabla de frecuencias.
#
# Entradas esperadas:
# - data/processed/latencia_base_01_tabla_frecuencias.RData
# 
# Salidas:
# - outputs/latencia_base_01_tabla_frecuencias.png
# ______________________________________________________________________________

rm(list = ls())

## @knitr dependecias
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

path_tabla <- here::here("data", "processed", "latencia_base_01_tabla_frecuencias.RData")
if (!file.exists(path_tabla)) {
  stop(paste("ERROR: Se esperaba:", path_tabla))
}
load(path_tabla)

print(tabla_frec_reagr_frame)

# ==== Tabla estilizada ====

tabla_frec_reagr_frame <- tabla_frec_reagr_frame[, c(1, 7, 8, 2, 3, 6, 4, 5, 9)]

colnames(tabla_frec_reagr_frame) <- c(
  "Intervalo",
  "m<sub>i</sub>",
  "c<sub>i</sub>",
  "n<sub>i</sub>",
  "f<sub>i</sub>",
  "%<sub>i</sub>",
  "N<sub>i</sub>",
  "F<sub>i</sub>",
  "h<sub>i</sub>"
)
## @knitr exportar_tabla
tabla_kbl <- exportar_tabla(
  tabla_frec_reagr_frame,
  here::here("outputs", "latencia_base_01_tabla_frecuencias.png"),
  "Tabla de Frecuencias de 'Latencia Base'"
)
