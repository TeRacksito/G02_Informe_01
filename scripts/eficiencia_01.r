# ==============================================================================
# Tarea: Análisis Descriptivo Unidimensional
# Script 02: Análisis de la variable Eficiencia Energética (Efficiency)
# Autor: Rodrigo Veiga Oliva
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

# ---- dependencias_eficiencia ----
# 1. CARGA DE LIBRERÍAS Y DATOS DE ENTRADA
library(here)
library(DescTools)
library(ggplot2)

path_datos <- here::here("data", "processed", "Cloud_Performance_procesado.RData")

if (!file.exists(path_datos)) {
  cat("ERROR: Se esperaba:", path_datos, "\n")
  cat("Ejecutando dependencias...\n")
  source(here::here("scripts", "carga_y_procesamiento_01.R"))
}

load(path_datos)

# ---- tabla_frec_eficiencia_01 ----
# 2. TABLA DE FRECUENCIAS DE EFFICIENCY
tabla_freq_eff <- Freq(datos_cloud$Efficiency)
n_muestra_eff <- sum(tabla_freq_eff$freq)

# Formateo de nombres de columnas para presentación de tabla
tabla_frecuencias_eff <- data.frame(
  Categoria = as.character(tabla_freq_eff$level),
  Frec_Absoluta = tabla_freq_eff$freq,
  Frec_Relativa = round(tabla_freq_eff$perc, 4),
  Porcentaje = round(tabla_freq_eff$perc * 100, 2),
  Frec_Abs_Acum = tabla_freq_eff$cumfreq,
  Frec_Rel_Acum = round(tabla_freq_eff$cumperc, 4),
  Porcentaje_Acum = round(tabla_freq_eff$cumperc * 100, 2)
)

# ---- medidas_eficiencia_01 ----
# 3. CÁLCULO DE LAS MEDIDAS DE POSICIÓN Y TENDENCIA CENTRAL
# Moda
modaeff <- Mode(datos_cloud$Efficiency)
num_moda <- attr(modaeff, "freq")
pct_moda <- round((num_moda / n_muestra_eff) * 100, 2)

# Mediana y Cuartiles
q1_eff <- quantile(datos_cloud$Efficiency, 0.25, type = 1)
medianaeff <- quantile(datos_cloud$Efficiency, 0.5, type = 1)
q3_eff <- quantile(datos_cloud$Efficiency, 0.75, type = 1)

num_mediana_acum <- sum(datos_cloud$Efficiency <= medianaeff, na.rm = TRUE)
pct_mediana_acum <- round((num_mediana_acum / n_muestra_eff) * 100, 2)

# ---- cuestion_3a_eficiencia ----
# 4. CUESTIÓN 3.a: PORCENTAJE SUPERIOR A BRONZE
n_sup_bronze <- sum(datos_cloud$Efficiency > "Bronze", na.rm = TRUE)
pct_sup_bronze <- mean(datos_cloud$Efficiency > "Bronze", na.rm = TRUE) * 100

# ---- grafico_eficiencia_01 ----
# 5. GENERACIÓN Y GUARDADO DEL GRÁFICO DE BARRAS
dir.create(here::here("outputs"), showWarnings = FALSE, recursive = TRUE)

p_eficiencia <- ggplot(datos_cloud, aes(x = Efficiency)) + 
  geom_bar(fill = "white", colour = "black") + 
  labs(
    title = "Distribución de Eficiencia Energética",
    subtitle = "Análisis unidimensional de la variable Efficiency",
    x = "Eficiencia",
    y = "Frecuencias (Nº de Servidores)"
  ) +
  theme_bw()

path_grafico_eff <- here::here("outputs", "eficiencia_01_diagrama_barras_frecuencias.png")
ggsave(
  filename = path_grafico_eff, 
  plot = p_eficiencia, 
  width = 8,
  height = 6, 
  dpi = 300
)
