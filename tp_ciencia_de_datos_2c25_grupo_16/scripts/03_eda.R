############################################################
# 03_eda.R
# Análisis Exploratorio de Datos (EDA)
############################################################

library(dplyr)
library(ggplot2)
library(scales)
library(tidyr)

# 1) Cargar base lista para análisis ------------------------

base_modelo <- readRDS("data/clean/eph_t3_2024_modelo.rds")

# Ver dimensiones
dim(base_modelo)


############################################################
# 2) Tablas descriptivas -----------------------------------
############################################################

# Tabla 1: informalidad total
tabla_inf_total <- table(base_modelo$informal)
tabla_inf_total

# Guardar
write.csv(as.data.frame(tabla_inf_total),
          "data/clean/tabla_informalidad_total.csv",
          row.names = FALSE)


# Tabla 2: informales por nivel educativo
tabla_inf_edu <- table(base_modelo$informal, base_modelo$educ_grupo)
tabla_inf_edu

write.csv(as.data.frame(tabla_inf_edu),
          "data/clean/tabla_informalidad_educacion.csv",
          row.names = FALSE)


# Tabla 3: informales por sexo
tabla_inf_sexo <- table(base_modelo$informal, base_modelo$sexo)
tabla_inf_sexo

write.csv(as.data.frame(tabla_inf_sexo),
          "data/clean/tabla_informalidad_sexo.csv",
          row.names = FALSE)


# Tabla 4: educación × sexo
tabla_edu_sexo <- table(base_modelo$educ_grupo, base_modelo$sexo)
tabla_edu_sexo

write.csv(as.data.frame(tabla_edu_sexo),
          "data/clean/tabla_educacion_sexo.csv",
          row.names = FALSE)


############################################################
# 3) Porcentajes -------------------------------------------
############################################################

# % de informalidad por educación
porc_inf_edu <- base_modelo %>%
  group_by(educ_grupo) %>%
  summarise(
    informalidad = mean(informal) * 100,
    n = n()
  )

write.csv(porc_inf_edu,
          "data/clean/porc_informalidad_educacion.csv",
          row.names = FALSE)

print(porc_inf_edu)


# % de informalidad por educación y sexo
porc_inf_edu_sexo <- base_modelo %>%
  group_by(educ_grupo, sexo) %>%
  summarise(
    informalidad = mean(informal) * 100,
    n = n(),
    .groups = "drop"
  )

write.csv(porc_inf_edu_sexo,
          "data/clean/porc_informalidad_educacion_sexo.csv",
          row.names = FALSE)

print(porc_inf_edu_sexo)


############################################################
# 4) Gráficos exploratorios --------------------------------
############################################################

# Gráfico 1: % informalidad por nivel educativo
g1 <- porc_inf_edu %>%
  ggplot(aes(x = educ_grupo, y = informalidad)) +
  geom_col(fill = "#1F78B4") +
  labs(title = "Porcentaje de informalidad por nivel educativo",
       x = "Nivel educativo",
       y = "% de trabajadores informales",
       caption = "Fuente: EPH-INDEC, T3 2024") +
  scale_y_continuous(labels = percent_format(scale = 1))

ggsave("output/grafico_informalidad_educacion.png",
       g1, width = 7, height = 5)


# Gráfico 2: % informalidad por educación y sexo
g2 <- porc_inf_edu_sexo %>%
  ggplot(aes(x = educ_grupo, y = informalidad, fill = sexo)) +
  geom_col(position = "dodge") +
  labs(title = "Informalidad laboral por educación y sexo",
       x = "Nivel educativo",
       y = "% de informales",
       fill = "Sexo",
       caption = "Fuente: EPH-INDEC, T3 2024") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_fill_manual(values = c("Varón" = "#1F78B4", "Mujer" = "#E31A1C"))

ggsave("output/grafico_informalidad_educacion_sexo.png",
       g2, width = 7, height = 5)


############################################################
# 5) Resumen de edad ---------------------------------------
############################################################

resumen_edad <- base_modelo %>%
  group_by(informal) %>%
  summarise(
    min = min(edad),
    p25 = quantile(edad, 0.25),
    mediana = median(edad),
    p75 = quantile(edad, 0.75),
    max = max(edad),
    n = n()
  )

print(resumen_edad)

write.csv(resumen_edad,
          "data/clean/resumen_edad_por_informalidad.csv",
          row.names = FALSE)

############################################################
# Fin 03_eda.R
############################################################
