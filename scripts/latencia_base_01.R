# Cabecera =====================================================================
# Tarea: Analizar Latencia Base
# Script 01: Analizar la variable continua. Tabla de frecuencias.
# Autor: Angel Krasimirov Stoyanov
# 
# Queremos analizar, hacer una primera aproximación a, la variable continua
# `Lat_Base` (Latencia Base). Generar la tabla de frecuencias.
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

# cargar dataframe datos_cloud
path_datos <- here::here("data", "processed", "Cloud_Performance_procesado.RData")
load(path_datos)

h("Dataframe")
str(datos_cloud)

lat_base <- datos_cloud$Lat_Bas

# ==== Información Base ====
h("Información Base")

cat0("Tipo de variable asignado: ", class(lat_base), " (variable continua)", "\n")
cat0("Unidad: Milisegundos (ms)", "\n")

n_muestra <- length(lat_base)
cat0("Tamaño muestral (n): ", n_muestra, "\n")

n_unicos <- length(unique(lat_base))
cat0("Número de valores distintos: ", n_unicos, " (",(n_unicos / n_muestra) * 100, "% del total)\n")

rango_vals <- range(lat_base)
cat0("Rango de valores observados: [", rango_vals[1], " (ms), ", rango_vals[2], " (ms)]\n")

h("Conclusión inicial")
cat0("La variable Latencia Base tiene un número de valores (únicos) ",
     "considerable. No es factible la discretización. Es necesario realizar ",
     "un agrupamiento.")

