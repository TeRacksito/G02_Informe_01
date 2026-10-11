# ==============================================================================
# Tarea: Análisis Descriptivo Unidimensional
# Script 02: Análisis de la variable Peticiones por Segundo (RPS)
# Autor: Mario y Eduardo
# 
# El script realiza el cálculo de las medidas de tendencia central, dispersión 
# y la representación gráfica (histograma) de la variable cuantitativa 'RPS'.
# 
# Entradas:
# - data/processed/Cloud_Performance_procesado.RData

# Salidas:
# - outputs/rps_01_histograma_frecuencias.png (Histograma)
# - Medidas descriptivas e interpretación por consola
# ==============================================================================

# 0. LIMPIEZA ENTORNO DE TRABAJO
rm(list = ls())

# 1. CARGA DE LIBRERÍAS
library(here)
library(DescTools)
library(ggplot2)

# 2. CARGA Y COMPROBACIÓN DE DATOS DE ENTRADA
path_datos <- here::here("data", "processed", "Cloud_Performance_procesado.RData")

if (!file.exists(path_datos)) {
  cat("ERROR: Se esperaba:", path_datos, "\n")
  cat("Ejecutando dependencias...\n")
  source(here::here("scripts", "carga_y_procesamiento_01.R"))
  stop("Dependencias ejecutadas. Intente ejecutar nuevamente.")
}

load(path_datos)

# 3. Realización de análisis exploratorio de la variable RPS e interpretación

cat("=====================================================\n")
cat("          1. RESUMEN ESTADÍSTICO DE RPS              \n")
cat("=====================================================\n")
print(summary(datos_cloud$RPS))

# 4. Cálculo de las medidas de tendencia central y dispersión
cat("\n=====================================================\n")
cat("      2. MEDIDAS DESCRIPTIVAS E INTERPRETACIÓN      \n")
cat("=====================================================\n")

# Cálculo de la media
media_rps <- mean(datos_cloud$RPS, na.rm = TRUE)
cat(" Media: ", round(media_rps, 2), " req/s\n")
cat(" El promedio de tráfico por servidor es de ", round(media_rps, 2), " peticiones/segundo.\n")

# Cálculo de la mediana
mediana_rps <- median(datos_cloud$RPS, na.rm = TRUE)
cat(" Mediana: ", round(mediana_rps, 2), " req/s\n")
cat(" El 50% de los servidores procesa ", round(mediana_rps, 2), " req/s o menos.\n")

# Cálculo de la moda
moda_rps <- Mode(datos_cloud$RPS, na.rm = TRUE)
cat(" Moda: ", as.numeric(moda_rps), " req/s\n")
cat(" El volumen de tráfico más frecuente entre los servidores es ", as.numeric(moda_rps), " req/s.\n")

# Cálculo de la desviación típica
sd_rps <- sd(datos_cloud$RPS, na.rm = TRUE)
cat(" Desviación Típica: ", round(sd_rps, 2), " req/s\n")

# Cuestión 3.b: Justificación del tipo de gráfico para RPS
cat("\n-----------------------------------------------------\n")
cat(" Cuestión 3.b: Justificación del gráfico para RPS\n")
cat("-----------------------------------------------------\n")
cat("Un gráfico de sectores (quesito) NO es adecuado para 'RPS' porque es una\n")
cat("variable cuantitativa con multitud de valores numéricos distintos.\n")
cat("Un gráfico de sectores crearía demasiadas porciones ilegibles.\n")
cat("Por ello, la representación correcta es un HISTOGRAMA de frecuencias.\n")


cat("\n=====================================================\n")
cat("      3. TABLA DE FRECUENCIAS Y FORMA DE DISTRIBUCIÓN \n")
cat("=====================================================\n")

# 1. Tabla de frecuencias agrupadas (¿Cómo se agrupa la frecuencia?)
cat("\n--- Tabla de Frecuencias Agrupadas ---\n")
tabla_frecuencias <- Freq(datos_cloud$RPS, na.rm = TRUE)
print(tabla_frecuencias)

# 2. Representatividad de la media (¿Es la media representativa?)
cat("\n--- Representatividad de la Media ---\n")
cv_rps <- (sd_rps / media_rps) * 100
cat(" Coeficiente de Variación (CV):", round(cv_rps, 2), "%\n")
if (cv_rps < 30) {
  cat(" Interpretación: Como el CV es menor al 30%, la media SÍ es representativa del tráfico.\n")
} else {
  cat(" Interpretación: Como el CV supera el 30%, hay mucha dispersión y la media NO es muy representativa.\n")
}

# 3. Forma de la distribución (Asimetría y Curtosis)
cat("\n--- Forma de la Distribución ---\n")
asimetria_rps <- Skew(datos_cloud$RPS, na.rm = TRUE)
curtosis_rps <- Kurt(datos_cloud$RPS, na.rm = TRUE)

cat(" Asimetría (Skewness):", round(asimetria_rps, 2), "\n")
cat(" Curtosis (Kurtosis):", round(curtosis_rps, 2), "\n")
cat("-----------------------------------------------------\n")


# 5. GENERACIÓN Y GUARDADO DEL GRÁFICO

dir.create(here::here("outputs"), showWarnings = FALSE, recursive = TRUE)

# Histograma ggplot 
p_rps <- ggplot(datos_cloud, aes(x = RPS)) + 
  geom_histogram(bins = 30, fill = "white", colour = "black") + 
  labs(
    title = "Distribución de Peticiones por Segundo (RPS)",
    subtitle = "Análisis unidimensional de la variable RPS",
    x = "Peticiones / segundo (req/s)",
    y = "Frecuencias (Nº de Servidores)"
  ) +
  theme_bw()

print(p_rps)

path_grafico <- here::here("outputs", "rps_01_histograma_frecuencias.png")
ggsave(
  filename = path_grafico, 
  plot = p_rps, 
  width = 8,
  height = 6, 
  dpi = 300
)

cat("\nSe ha generado correctamente el artefacto gráfico en:\n", path_grafico, "\n")
