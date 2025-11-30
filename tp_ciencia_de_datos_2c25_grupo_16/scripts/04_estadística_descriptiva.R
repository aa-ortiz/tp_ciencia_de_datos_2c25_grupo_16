############################################################
# 04_estadisticas_descriptivas.R
# Estadísticas descriptivas para el TP final
# Cumple con:
# - Medidas de tendencia central y dispersión
# - Distribución de frecuencias de variables categóricas
# - Visualizaciones (histogramas y boxplots)
############################################################

library(tidyverse)

#-----------------------------------------------------------
# 1) Cargar base de análisis
#    (la misma que usás para el modelo logístico)
#-----------------------------------------------------------

base_modelo <- readRDS("data/clean/eph_t3_2024_modelo.rds")

# Aseguramos tipos de variables
base_modelo <- base_modelo %>%
  mutate(
    sexo        = factor(sexo, levels = c("Varón", "Mujer")),
    educ_grupo  = factor(educ_grupo, levels = c("Baja", "Media", "Alta")),
    informal_fac = factor(informal,
                          levels = c(0, 1),
                          labels = c("Formal", "Informal"))
  )

# Creamos carpetas para guardar resultados si no existen
dir.create("output", showWarnings = FALSE)
dir.create("output/tables", showWarnings = FALSE)
dir.create("output/figures", showWarnings = FALSE)

#-----------------------------------------------------------
# 2) Medidas de tendencia central y dispersión (edad)
#-----------------------------------------------------------

# función simple para calcular la moda
moda_simple <- function(x) {
  x <- x[!is.na(x)]
  as.numeric(names(which.max(table(x))))
}

resumen_edad <- base_modelo %>%
  summarise(
    n          = n(),
    media      = mean(edad, na.rm = TRUE),
    mediana    = median(edad, na.rm = TRUE),
    moda       = moda_simple(edad),
    sd         = sd(edad, na.rm = TRUE),
    p25        = quantile(edad, 0.25, na.rm = TRUE),
    p75        = quantile(edad, 0.75, na.rm = TRUE),
    iqr        = IQR(edad, na.rm = TRUE),
    min        = min(edad, na.rm = TRUE),
    max        = max(edad, na.rm = TRUE)
  )

print(resumen_edad)

write.csv(resumen_edad,
          "output/tables/resumen_edad_total.csv",
          row.names = FALSE)

# Resumen de edad por condición laboral (formal / informal)
resumen_edad_inf <- base_modelo %>%
  group_by(informal_fac) %>%
  summarise(
    n       = n(),
    media   = mean(edad, na.rm = TRUE),
    mediana = median(edad, na.rm = TRUE),
    sd      = sd(edad, na.rm = TRUE),
    p25     = quantile(edad, 0.25, na.rm = TRUE),
    p75     = quantile(edad, 0.75, na.rm = TRUE),
    iqr     = IQR(edad, na.rm = TRUE),
    .groups = "drop"
  )

print(resumen_edad_inf)

write.csv(resumen_edad_inf,
          "output/tables/resumen_edad_por_informalidad.csv",
          row.names = FALSE)

#-----------------------------------------------------------
# 3) Distribuciones de frecuencias (variables categóricas)
#-----------------------------------------------------------

# Sexo
dist_sexo <- base_modelo %>%
  count(sexo, name = "n") %>%
  mutate(
    prop     = n / sum(n),
    prop_pct = round(prop * 100, 1)
  )

print(dist_sexo)

write.csv(dist_sexo,
          "output/tables/dist_sexo.csv",
          row.names = FALSE)

# Nivel educativo
dist_educ <- base_modelo %>%
  count(educ_grupo, name = "n") %>%
  mutate(
    prop     = n / sum(n),
    prop_pct = round(prop * 100, 1)
  )

print(dist_educ)

write.csv(dist_educ,
          "output/tables/dist_nivel_educativo.csv",
          row.names = FALSE)

# Condición laboral: formal / informal
dist_informal <- base_modelo %>%
  count(informal_fac, name = "n") %>%
  mutate(
    prop     = n / sum(n),
    prop_pct = round(prop * 100, 1)
  )

print(dist_informal)

write.csv(dist_informal,
          "output/tables/dist_informalidad.csv",
          row.names = FALSE)

#-----------------------------------------------------------
# 4) Visualizaciones complementarias
#    (histogramas y boxplots de edad)
#-----------------------------------------------------------

# Histograma de edad (total)
p_hist_edad <- ggplot(base_modelo, aes(x = edad)) +
  geom_histogram(bins = 30, color = "white") +
  labs(
    title = "Distribución de la edad de los ocupados (18–64 años)",
    x = "Edad",
    y = "Frecuencia"
  ) +
  theme_minimal()

ggsave("output/figures/hist_edad_total.png",
       p_hist_edad, width = 7, height = 5, dpi = 300)

# Histograma de edad por condición laboral
p_hist_edad_inf <- ggplot(base_modelo,
                          aes(x = edad, fill = informal_fac)) +
  geom_histogram(bins = 30, position = "identity", alpha = 0.5) +
  labs(
    title = "Distribución de la edad según condición laboral",
    x = "Edad",
    y = "Frecuencia",
    fill = "Condición"
  ) +
  theme_minimal()

ggsave("output/figures/hist_edad_por_informalidad.png",
       p_hist_edad_inf, width = 7, height = 5, dpi = 300)

# Boxplot de edad por condición laboral
p_box_edad_inf <- ggplot(base_modelo,
                         aes(x = informal_fac, y = edad)) +
  geom_boxplot() +
  labs(
    title = "Distribución de la edad por condición laboral",
    x = "Condición laboral",
    y = "Edad"
  ) +
  theme_minimal()

ggsave("output/figures/boxplot_edad_por_informalidad.png",
       p_box_edad_inf, width = 6, height = 5, dpi = 300)

############################################################
# FIN 04_estadisticas_descriptivas.R
############################################################
