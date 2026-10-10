# Cabecera =====================================================================
# Tarea: Analizar Latencia Base
# Script 01: Analizar la variable continua. Tabla de frecuencias.
# Autor: Angel Krasimirov Stoyanov
# 
# Queremos analizar la variable continua `Lat_Base` (Latencia Base). Generar
# la tabla de frecuencias.
#
# Entradas esperadas:
# - data/processed/Cloud_Performance_procesado.RData
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

