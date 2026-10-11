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

path_tabla_med_centrales <- here::here("data", "processed", "latencia_base_02_tabla_med_centrales.RData")
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
     round(mediana, 3), " (ms)) como indicador robusto.\n\n")

cat0("El rango intercuartílico es sensiblemente más pequeño (",
     round(rango_iqr, 3), ") que el rango de la muestra (",
     round(rango, 3), "). Esto significa que el 50% de las observaciones ",
     "recaen un unos valores muy juntos.\n")

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

path_tabla_med_dispersion <- here::here("data", "processed", "latencia_base_02_tabla_med_dispersion.RData")
save(tabla_med_dispersion, file = path_tabla_med_dispersion)
cat("\nSe ha generado el fichero: ", path_tabla_med_dispersion, "\n")

# ==== Medidas de posición ====
h("Medidas de posición")

cuartiles <- quantile(lat_base, seq(0.25, 0.75, by = 0.25), na.rm = TRUE)
cat0("Cuartiles:\n")
print(round(cuartiles, 3))

deciles <- quantile(lat_base, seq(0.1, 0.9, by = 0.1), na.rm = TRUE)
cat0("\nDeciles:\n")
print(round(deciles, 3))

percentiles_interesantes <- quantile(lat_base, c(0.05, 0.90, 0.95), na.rm = TRUE)
cat0("\nPercentiles (P5, P90, P95):\n")
print(round(percentiles_interesantes, 3))

percentiles <- quantile(lat_base, seq(0.01, 0.99, by = 0.01), na.rm = TRUE)
cat0("\nPercentiles (Todos):\n")
print(round(percentiles, 3))

h("Observaciones")
cat0("Efectivamente, el 50% concuerda con la mediana: ", round(mediana, 3), "\n\n")

cat0("Observamos una larga cola por la derecha. Tenemos que pensar que esta ",
     "cola (P95 a P99) representa las latencias más lentas. Es decir, ",
     "las peores experiencias de usuario.\n\n")

cat0("Podemos afirmar que el 4% de los peores casos presenta una gran ", 
     "variabilidad frente al 50%. Es decir, tenemos valores atípicos.\n",
     "Esto significa que, antes de implementar la cache en memoria, ",
     "los microservicios se presentan inestables y generan una mala ",
     "experiencia de usuario.\n",
     "Sería interesante comparar esta situación con `Lat_Post` ", 
     "(Latencia tras haber implementado la cache).\n\n")

cat0("Sin embargo, también podemos afirmar que se garantiza una latencia ",
     "inferior a ", round(percentiles_interesantes[2], 1), "ms para el 90% ",
     "de las conexiones; indicando que si existe algún tipo de estabilidad si ",
     "se pudiera eliminar los valores atípicos. Es decir, si parece que pueda ",
     "haber algúna solución a la inestabilidad anterioremente descrita.\n")

path_med_posicion <- here::here("data", "processed", "latencia_base_02_vectores_med_posicion.RData")
save(cuartiles, deciles, percentiles_interesantes, file = path_med_posicion)
cat("\nSe ha generado el fichero: ", path_med_posicion, "\n")
