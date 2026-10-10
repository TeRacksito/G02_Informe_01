# Cabecera =====================================================================
# Tarea: Cargar y Procesamiento
# Script 01: carga y definición inicial de tipos de variables
# Autor: Angel Krasimirov Stoyanov
# 
# Este script tiene como objeto exportar un RData para ser utilizado en los
# posteriores análisis.
#
# Entradas esperadas:
# - data/raw/Cloud_Performance_01.csv
# 
# Salidas:
# - data/processed/Cloud_Performance_procesado.RData
# ______________________________________________________________________________

rm(list = ls())

# ==== Librerías ====

library(here)

# ==== Funciones externas ====

source(here("scripts", "Utilidades.R"))

# ==== Script ====

# necesario por si github no preservó el directorio
processed_dir <- here::here("data", "processed")
if (!dir.exists(processed_dir)) {
  dir.create(processed_dir, recursive = TRUE, showWarnings = FALSE)
}

path_raw <- here::here("data", "raw", "Cloud_Performance_01.csv")

if (!file.exists(path_raw)) {
  stop(paste("ERROR: Se esperaba:", path_raw))
}

datos_raw <- read.csv(path_raw, stringsAsFactors = FALSE, na.strings = c("NA", "", " "))

# Evitamos manipular los datos originales?
datos_cloud <- datos_raw

h("dataframe en bruto")
str(datos_cloud)

# ==== Variables Discretas y Continuas ====
# ID: Cadena alfanumérica única
# No es una variable estadística.
datos_cloud$ID <- as.character(datos_cloud$ID)

# RPS: Peticiones por segundo 
# Variable Cuantitativa Discreta
datos_cloud$RPS <- as.numeric(datos_cloud$RPS)

# CPU: Porcentaje de uso de procesador
# Variable Cuantitativa Continua
datos_cloud$CPU <- as.numeric(datos_cloud$CPU)

# Lat_Base: Latencia previa a la caché en ms
# Variable Cuantitativa Continua
datos_cloud$Lat_Base <- as.numeric(datos_cloud$Lat_Base)

# Lat_Post: Latencia posterior a la caché en ms
# Variable Cuantitativa Continua
datos_cloud$Lat_Post <- as.numeric(datos_cloud$Lat_Post)

# Bandwidth: Ancho de banda de red en Mbps
# Variable Cuantitativa Continua
datos_cloud$Bandwidth <- as.numeric(datos_cloud$Bandwidth)

# Containers: Conteo de microservicios 
# Variable Cuantitativa Discreta
datos_cloud$Containers <- as.numeric(datos_cloud$Containers)

# ==== Atributos Ordinales ====
# Restarts: Número de caídas/reinicios
# Atributo ordinal (0 < 1 < 2)
# A pesar de que son números, son tan pocos que funcionan etiquetas
# Por ello, voy a incluso etiquetarlas.
datos_cloud$Restarts <- factor(
  datos_cloud$Restarts,
  levels = c(0, 1, 2),
  labels = c("0 reinicios", "1 reinicio", "2 reinicios"),
  ordered = TRUE
)

# Efficiency: Clasificación de eficiencia
# Atributo ordinal (Bronze < Silver < Gold)
datos_cloud$Efficiency <- factor(
  datos_cloud$Efficiency,
  levels = c("Bronze", "Silver", "Gold"),
  ordered = TRUE
)


# ==== Atributos Nominales ====
# Provider: Proveedor cloud
# Atributo nominal (AWS, Azure, GCP)
datos_cloud$Provider <- factor(
  datos_cloud$Provider,
  levels = c("AWS", "Azure", "GCP")
)

# Region: Ubicación geográfica 
# Atributo nominal (Asia-Pacific, EU-West, US-East)
datos_cloud$Region <- factor(
  datos_cloud$Region,
  levels = c("Asia-Pacific", "EU-West", "US-East")
)

# ==== Guardar dataframe ====
h("dataframe")
str(datos_cloud)

h("valores 'not available'")
print(colSums(is.na(datos_cloud)))
cat("Parece que existen valores NA, ¿Qué hacemos?")

h("resumen estadístico")
print(summary(datos_cloud))

path_processed_rdata <- here::here("data", "processed", "Cloud_Performance_procesado.RData")
save(datos_cloud, file = path_processed_rdata)
cat("Se ha generado el fichero: ", path_processed_rdata, "\n")
