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

# ==== Tabla de frecuencias - Propuesta 2.1 ====

cat0("\nComo podemos observar, existen varios intervalos (6-11) que tienen ",
     "menos de cinco observaciones. Sería pertinente realizar una fusión ",
     "de dichos intervalos.\n")


breaks_reagr <-c(breaks[1:6], max(lat_base))

tabla_frec_reagrupada <- DescTools::Freq(lat_base, breaks = breaks_reagr, include.lowest = TRUE)

h("Tabla de frecuencias - Propuesta 2.1")
print(tabla_frec_reagrupada)

# ==== Tabla de frecuencias - Propuesta 2.2 ====

cat0("\nPuesto que ahora la amplitud no es homogenía, tendría sentido ",
     "representar las marcas de clase, las amplitudes y las alturas.\n")

tabla_frec_reagr_frame <- as.data.frame(tabla_frec_reagrupada)

# ya que estamos, renombramos las columnas
colnames(tabla_frec_reagr_frame) <- c("intervalo", "n_i", "f_i", "N_i", "F_i")

# añadir porcentaje, porque antes f_i lo era
tabla_frec_reagr_frame$perc <- round((tabla_frec_reagr_frame$f_i * 100), 2)

# para hacer esto, vamos a crear dos vectores
a_inf <- breaks_reagr[1:(length(breaks_reagr) - 1)] # vector: limites inferiores
a_sup <- breaks_reagr[2:length(breaks_reagr)] # vector: limites superiores

tabla_frec_reagr_frame$m_i <- round((a_inf + a_sup) / 2, 3)
tabla_frec_reagr_frame$c_i <- round(a_sup - a_inf, 3)
tabla_frec_reagr_frame$h_i <- round(tabla_frec_reagr_frame$n_i / tabla_frec_reagr_frame$c_i, 3)

h("Tabla de frecuencias - Propuesta 2.2")
print(tabla_frec_reagr_frame)


path_processed_tabla <- here::here("data", "processed", "latencia_base_01_tabla_frecuencias.RData")
save(tabla_frec_reagr_frame, file = path_processed_tabla)
cat("\nSe ha generado el fichero: ", path_processed_tabla, "\n")
