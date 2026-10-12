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
# ______________________________________________________________________________

rm(list = ls())

# ==== Librerías ====

library(here)
library(knitr)
library(kableExtra)

# ==== Funciones externas ====

source(here("scripts", "Utilidades.R"))

# ==== Script ====

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

# cargar dataframe `tabla_med_dispersion`
path_tabla_med_forma <- here::here("data", "processed", "latencia_base_02_tabla_med_forma.RData")
if (!file.exists(path_tabla_med_forma)) {
  stop(paste("ERROR: Se esperaba:", path_tabla_med_forma))
}
load(path_tabla_med_forma)

h("Tabla de medidas de forma")
print(tabla_med_forma)


