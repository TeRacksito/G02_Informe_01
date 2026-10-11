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

# ==== Librerías ====

library(here)
library(knitr)
library(kableExtra)

# ==== Funciones externas ====

source(here("scripts", "Utilidades.R"))

# ==== Script ====

path_tabla <- here::here("data", "processed", "latencia_base_01_tabla_frecuencias.RData")
load(path_tabla)

print(tabla_frec_reagr_frame)

# ==== Tabla estilizada ====

colnames(tabla_frec_reagr_frame) <- c(
  "intervalo",
  "n<sub>i</sub>",
  "f<sub>i</sub>",
  "N<sub>i</sub>",
  "F<sub>i</sub>",
  "%<sub>i</sub>",
  "m<sub>i</sub>",
  "c<sub>i</sub>",
  "h<sub>i</sub>"
  )

tabla_kbl <- tabla_frec_reagr_frame %>%
  kbl(
    caption = "Distribución de Frecuencias de 'Latencia Base'",
    align = "c",
    row.names = FALSE,
    escape = FALSE # fix: permite interpretar los <sub>
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = FALSE,
    position = "center"
  ) %>%
  row_spec(0, bold = TRUE, background = "#5C068C", color = "white")

cat0("\nGuardando resultado PNG, espere un momento...")
path_tabla_kbl <- here::here("outputs", "latencia_base_01_tabla_frecuencias.png")
save_kable(tabla_kbl, file = path_tabla_kbl, zoom = 2)
cat("Se ha generado el fichero: ", path_tabla_kbl, "\n")
