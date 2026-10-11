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
# - scripts/carga_y_procesamiento_01.R (Carga 'datos_cloud')

# Salidas:
# - Tabla de frecuencias (DescTools::Freq) y estadísticos en consola
# - Gráficos de distribución (barplot o ggplot2)
# ==============================================================================

# 1. INSTALACIÓN Y CARGA DE PAQUETES


library(here)
library(DescTools)
library(ggplot2)
source(here::here("scripts", "carga_y_procesamiento_01.R"))

# 2. Realización de análisis explorativo de de la variable Efficiency e
# interpretación de su resultado.

# TABLA DE FRECUENCIAS
tabla_freq <- Freq(datos_cloud$Efficiency)
tabla_freq

# Cálculo de las medidas de tendencia general
# Cálculo de la moda
modaeff <- Mode(datos_cloud$Efficiency)
modaeff
# Cálculo de la mediana
medianaeff <- quantile(datos_cloud$Efficiency, 0.5, type = 1)
medianaeff
# 
# Diagrama de barras ggplot
ggplot(datos_cloud, aes(x = Efficiency)) + 
  geom_bar(fill = "white", colour = "black") + 
  labs(title = "Distribución de Eficiencia Energética", 
       x = "Eficiencia", 
       y = "Frecuencias") + 
  theme_bw()

pct_sup_bronze <- mean(datos_cloud$Efficiency > "Bronze", na.rm = TRUE) * 100
cat("Porcentaje con eficiencia superior a Bronze:", round(pct_sup_bronze, 2), "%\n")
