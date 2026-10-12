# Cabecera =====================================================================
# Tarea: Analizar Latencia Base
# Script 02: Medidas descriptivas y estadisticos de Latencia Base.
# Autor: Angel Krasimirov Stoyanov
# 
# Queremos calcular todas las medidas descriptivas posibles de `Lat_Base` 
# (Latencia Base) y hacer analizar los resultados.
#
# Entradas esperadas:
# - data/processed/Cloud_Performance_procesado.RData
# - data/processed/latencia_base_01_tabla_frecuencias.RData
# 
# Salidas:
# - data/processed/latencia_base_02_tabla_med_centrales.RData
# - data/processed/latencia_base_02_tabla_med_dispersion.RData
# - data/processed/latencia_base_02_vectores_med_posicion.RData
# - data/processed/latencia_base_02_tabla_med_forma.RData
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

# cargar dataframe tabla_frec (tabla_frec_reagr_frame)
path_tabla_frec <- here::here("data", "processed", "latencia_base_01_tabla_frecuencias.RData")
if (!file.exists(path_datos)) {
  stop(paste("ERROR: Se esperaba:", path_tabla_frec))
}
load(path_tabla_frec)
tabla_frec <- tabla_frec_reagr_frame
rm(tabla_frec_reagr_frame)
