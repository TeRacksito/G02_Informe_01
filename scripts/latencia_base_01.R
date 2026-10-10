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

lat_base <- datos_cloud$Lat_Base

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
     "un agrupamiento.\n")

# ==== Agrupación ====
h("Agrupación")

k_raiz <- round(sqrt(length(lat_base)), 0)
k_sturges <- nclass.Sturges(lat_base)

cat0("Número de clases (raíz): ", k_raiz, "\n")
cat0("Número de clases (Sturges): ", k_sturges, "\n")
cat0("32 son demasiadas clases, 11 parece un número razonable.\n\n")

amplitud <- (rango_vals[2] - rango_vals[1]) / k_sturges
breaks <- seq(rango_vals[1], rango_vals[2], by=amplitud)

cat0("Número de intervalos elegido (k): ", k_sturges, "\n")
cat0("Amplitud de intervalo (c): ", round(amplitud, 4), "\n")
cat("Límites de intervalos:", breaks, "\n")

# ==== Tablas de frecuencias ====

tabla_frecuencias <- DescTools::Freq(lat_base, breaks = breaks, include.lowest = TRUE)
# colnames(tabla_frecuencias) <- c("intervalo", "n_i", "f_i", "N_i", "F_i")

h("Tabla de frecuencias - Propuesta 1")
print(tabla_frecuencias)

cat0("\nComo podemos observar, existen varios intervalos (6-11) que tienen ",
     "menos de cinco observaciones. Sería pertinente realizar una fusión ",
     "de dichos intervalos.\n")

h("Tabla de frecuencias - Propuesta 2.1")
breaks_reagrupacion <-c(breaks[1:6], max(lat_base))

tabla_frec_reagrupada <- DescTools::Freq(lat_base, breaks = breaks_reagrupacion, include.lowest = TRUE)

print(tabla_frec_reagrupada)






