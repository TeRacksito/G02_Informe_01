# ==============================================================================
# Tarea: Análisis Descriptivo Unidimensional
# Script 02: Análisis de la variable Eficiencia Energética (Efficiency)
# Autor: Adrián Reyes Gómez
# 
# El script realiza la tabla de frecuencias, Cálculo de las medidas de tendencia
# general y representación gráfica de la variable cualitativa ordinal 
# 'Efficiency'.
# 
# Entradas:
# - data/processed/Cloud_Performance_procesado.RData

# Salidas:
# - outputs/eficiencia_01_diagrama_barras_frecuencias.png (Gráfico de barras)
# - Tabla de frecuencias y medidas descriptivas por consola
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

# 3. Realización de análisis explorativo de de la variable Efficiency e
# interpretación de su resultado.

# TABLA DE FRECUENCIAS DE EFFICIENCY
tabla_freq <- Freq(datos_cloud$Efficiency)
cat("          1. TABLA DE FRECUENCIAS DE EFFICIENCY     \n")
print(tabla_freq)

# 4. Cálculo de las medidas de tendencia general
cat("      2. MEDIDAS DESCRIPTIVAS E INTERPRETACIÓN      \n")

# Cálculo de la moda
modaeff <- Mode(datos_cloud$Efficiency)
cat(" Moda: ", as.character(modaeff), "\n")
cat(" La categoría de eficiencia energética más frecuente es ", as.character(modaeff), "\n")

# Cálculo de la mediana
medianaeff <- quantile(datos_cloud$Efficiency, 0.5, type = 1)
cat(" Mediana: ", as.character(medianaeff), "\n")
cat(" Al ser ordinal, el 50% de los servidores tiene eficiencia ", as.character(medianaeff), " o inferior.\n")

# Cuestión 3.a: Porcentaje Superior a Bronze
pct_sup_bronze <- mean(datos_cloud$Efficiency > "Bronze", na.rm = TRUE) * 100
cat("Porcentaje con eficiencia superior a 'Bronze':", round(pct_sup_bronze, 2), "%\n")
cat("El ", round(pct_sup_bronze, 2), "% de los servidores tiene eficiencia superior a 'Bronze'.\n")

# 5. GENERACIÓN Y GUARDADO DEL GRÁFICO

dir.create(here::here("outputs"), showWarnings = FALSE, recursive = TRUE)

# Diagrama de barras ggplot
p_eficiencia <- ggplot(datos_cloud, aes(x = Efficiency)) + 
  geom_bar(fill = "white", colour = "black") + 
  labs(
    title = "Distribución de Eficiencia Energética",
    subtitle = "Análisis unidimensional de la variable Efficiency",
    x = "Eficiencia",
    y = "Frecuencias (Nº de Servidores)"
  ) +
  theme_bw()

print(p_eficiencia)

path_grafico <- here::here("outputs", "eficiencia_01_diagrama_barras_frecuencias.png")
ggsave(
  filename = path_grafico, 
  plot = p_eficiencia, 
  width = 8,
  height = 6, 
  dpi = 300
)

cat("Se ha generado correctamente el artefacto gráfico en:\n", path_grafico, "\n")
# 
