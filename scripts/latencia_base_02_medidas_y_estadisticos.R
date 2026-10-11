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
# - data/processed/latencia_base_02_trabla_med_centrales.RData
# - data/processed/latencia_base_02_trabla_med_dispersion.RData
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

# ==== Medidas de tendencia central ====
h("Medidas de tendencia central")

w_media <- weighted.mean(tabla_frec$m_i, tabla_frec$f_i)
cat0("Media Agrupada: ", w_media, " (ms)\n")

media <- mean(lat_base, na.rm = TRUE)
cat0("Media: ", media, " (ms)\n")

mediana <- median(lat_base, na.rm = TRUE)
cat0("Mediana: ", mediana, " (ms)\n")

modas <- DescTools::Mode(lat_base, na.rm = TRUE)
cat("Modas:", modas, " (ms)\n")

cat0("\nComo podemos ver, hay muchas modas, porque calcular la moda de una ",
     "variable continua sin agrupar no teine mucho sentido estadistico.\n",
     "Calculemos la moda de los intervalos de la distribución.\n\n")

# si usamos which.max no tendríamos en cuenta múltiples intervalos modales.
# Aunque en este caso no ocurre, prefiero intentar hacerlo bien.

max_h <- max(tabla_frec$h_i)

indices_modales <- which(tabla_frec$h_i == max_h)

intervalos_modales <- tabla_frec$intervalo[indices_modales]
clases_modales <- tabla_frec$m_i[indices_modales]

cat("Intervalos modales:", paste(intervalos_modales, collapse = " y "), "\n")
cat("Modas (m_i):", paste(clases_modales, collapse = " y "), "(ms)\n")

cat0("\nSolo tenemos un intervalo modal. Es decir, Unimodal.\n")

tabla_med_centrales <- data.frame(
  "media_agrupada" = round(w_media, 3),
  "media" = round(media, 3),
  "mediana" = round(mediana, 3),
  "intervalo_modal" = intervalos_modales[1],
  row.names = ""
)

h("Tabla de medidas de tendencia central")
print(tabla_med_centrales)

path_tabla_med_centrales <- here::here("data", "processed", "latencia_base_02_trabla_med_centrales.RData")
save(tabla_med_centrales, file = path_tabla_med_centrales)
cat("\nSe ha generado el fichero: ", path_tabla_med_centrales, "\n")

# ==== Medidas de dispersión ====
h("Medidas de dispersión")

n_muestra <- length(lat_base)

cuasivarianza <- var(lat_base, na.rm = TRUE)
cuasidesviacion <- sd(lat_base, na.rm = TRUE)

varianza <- cuasivarianza * (n_muestra - 1) / n_muestra
cat0("Varianza: ",  round(varianza, 3), "\n")

desviacion <- sqrt(varianza)
cat0("Desviación estándar: ", round(desviacion, 3), "\n")

cv_pearson <- desviacion / abs(media)
cv_pearson_perc <- round(cv_pearson * 100, 2)
cat0("Coeficiente de Variación de Pearson: ", cv_pearson_perc, "%\n")

rango <- diff(range(lat_base, na.rm = TRUE))
cat0("Rango: ", round(rango, 3), "\n")

rango_iqr <- IQR(lat_base, na.rm = TRUE)
cat0("Rango Intercuartílico: ", round(rango_iqr, 3), "\n")

h("Observaciones")
cat0("El coeficiente de variación es mayor del 30% ",
     "(", cv_pearson_perc, "% > 30%). Esto indica que la media (",
     round(media, 3), " (ms)) no es representativa.\n",
     "Es recomendable utilizar la mediana (",
     round(mediana, 3), " (ms)) como indicador robusto.\n")

tabla_med_dispersion <- data.frame(
  "cuasivarianza" = round(cuasivarianza, 3),
  "cuasidesviacion" = round(cuasidesviacion, 3),
  "varianza" = round(varianza, 3),
  "desviacion" = round(desviacion, 3),
  "cv_pearson" = round(cv_pearson, 3),
  "rango" = round(rango, 3),
  "iqr" = round(rango_iqr, 3)
)

h("Tabla de medidas de dispersión")
print(tabla_med_dispersion)

path_tabla_med_dispersion <- here::here("data", "processed", "latencia_base_02_trabla_med_dispersion.RData")
save(tabla_med_dispersion, file = path_tabla_med_dispersion)
cat("\nSe ha generado el fichero: ", path_tabla_med_dispersion, "\n")

