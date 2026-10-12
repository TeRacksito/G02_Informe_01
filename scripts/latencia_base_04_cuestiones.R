# Cabecera =====================================================================
# Tarea: Analizar Latencia Base
# Script 04: Responder cuestiones extra.
# Autor: Angel Krasimirov Stoyanov
# 
# Queremos responder a las cuestiones:
#   3.c: ¿Qué porcentaje es superior a 36.56?
#   3.d: ¿Hay valores atípicos? ¿Los 3 valores más extremos?
#
# Entradas esperadas:
# - data/processed/Cloud_Performance_procesado.RData
# - data/processed/latencia_base_02_tabla_med_centrales.RData
# - data/processed/latencia_base_02_tabla_med_dispersion.RData
# - data/processed/latencia_base_02_vectores_med_posicion.RData
# 
# Salidas:
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
lat_base <- datos_cloud$Lat_Base
n_muestra <- length(lat_base)

h("Dataframe")
str(datos_cloud)

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
cat0("\nCuartiles:\n")
print(round(cuartiles, 3))
cat0("\nDeciles:\n")
print(round(deciles, 3))
cat0("\nPercentiles (P5, P90, P95):\n")
print(round(percentiles_interesantes, 3))

# ==== Cuestión 3.c ====

h("Cuestión 3.c")
cat0("¿Porcentaje de Lat_Base > 36.56 ms?\n\n")

cat0("Si nos fijamos en el diagrama de caja y patillas, el valor 36.56 ",
     "coincide con el cuartil superior (Q3). Por ende, es trivial saber ",
     "que el 25% (1 - 0,75) de los servidores presentan una latencia base ",
     "superior a 36.56 ms.\n\n")

cat0("De todas formas, veamos como se calcula, para conocer el porcentaje exacto.\n\n")

umbral <- 36.56

n_cumplen <- sum(lat_base > umbral)
perc_cumplen <- (n_cumplen / n_muestra) * 100

cat0("Valor umbral: ", umbral, " (ms)\n")
cat0("Número de servidores: ", n_cumplen, " sobre ", n_muestra, "\n")
cat0("Porcentaje: ", perc_cumplen, "%\n")

# ==== Cuestión 3.d ====

h("Cuestión 3.d")
cat0("¿Hay valores atípicos? ¿Cúales son los 3 valores más extremos?\n\n")

cat0("Al observar el diagrama de caja y patillas, nos damos cuenta ",
     "inmediatamente que existe una serie de valores atípicos.\n")

vector_outliers <- DescTools::Outlier(lat_base, method = "boxplot", value = TRUE, na.rm = TRUE)
n_outliers <- length(vector_outliers)

cat0("Número de valores atípicos: ", n_outliers, " sobre ", n_muestra, " (",
     round((n_outliers / n_muestra) * 100, 2), "%)\n")
cat("3 Valores más extremos: ", paste(head(sort(vector_outliers, decreasing = TRUE), 3)), "\n")

cat0("\nEncuentro interesante poder saber toda la información acerca de esos ",
     "tres servidores. Para ello sería más conveniente filtrar el dataframe.\n")

cuartil_q1 <- cuartiles[["25%"]]
cuartil_q2 <- cuartiles[["50%"]]
cuartil_q3 <- cuartiles[["75%"]]
limite_superior <- cuartil_q3 + 1.5 * tabla_med_dispersion$iqr

atipicos_frame <- datos_cloud[datos_cloud$Lat_Base > limite_superior,]
atipicos_frame <- atipicos_frame[order(atipicos_frame$Lat_Base, decreasing = TRUE), ]

h("Tres servidores con mayor latencia base")
print(head(atipicos_frame, 3))

cat0("\nHay varias cosas que podriamos observar.\n")
cat0("Todos pertenencen al mismo proveedor/región (", as.character(atipicos_frame$Provider[1]),
     "/", as.character(atipicos_frame$Region[1]),"). Esto podría indicar que existe algún ",
     "problema con dicha región.\n")
cat0("Todos presentan un uso intensivo de CPU (", atipicos_frame$CPU[3],
     "% - ", atipicos_frame$CPU[1], "%) al momento de registar la latencia. ",
     "Esto podría indicar colapsos o nodos saturados.")

