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
# ______________________________________________________________________________

rm(list = ls())

# ==== Librerías ====

library(here)
library(DescTools)

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

# ==== Resumen inicial ====
h("Dataframe")
str(datos_cloud)

h("Tabla de Frecuencias")
print(tabla_frec)

lat_base <- datos_cloud$Lat_Base

h("Resumen estadístico Latencia Base")
print(summary(lat_base))
